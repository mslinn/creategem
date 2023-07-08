require 'thor'
require 'yaml'

module Nugem
  module Git
    include Thor::Actions

    def create_local_git_repository
      say 'Creating the local git repository', :green
      run 'git init'
      run 'git add .'

      # See https://github.com/rails/thor/blob/v1.2.2/lib/thor/actions.rb#L236-L278
      run "git commit -aqm 'Initial commit'", abort_on_failure: false
    end

    def github_config
      gh_hosts_file = Nugem.expand_env('$HOME/.config/gh/hosts.yml')
      return nil unless File.exist? gh_hosts_file

      YAML.safe_load(File.read(gh_hosts_file))
    end

    def create_remote_git_repository(repository)
      say "Creating a remote #{repository.host} repository", :green
      if repository.github?
        gh_config = github_config
        token = gh_config&.dig('github.com', 'oauth_token')

        token ||= ask('What is your Github personal access token', echo: false)
        run <<~END_CURL
          curl --request POST \
            --user '#{repository.user}:#{token}' \
            https://api.github.com/user/repos \
            -d '{"name":"#{repository.name}", "private":#{repository.private?}}'
        END_CURL
      else # BitBucket
        password = ask('Please enter your Bitbucket password', echo: false)
        fork_policy = repository.public? ? 'allow_forks' : 'no_public_forks'
        run <<~END_BITBUCKET
          curl --request POST \
            --user #{repository.user}:#{password} \
            https://api.bitbucket.org/2.0/repositories/#{repository.user}/#{repository.name} \
            -d '{"scm":"git", "fork_policy":"#{fork_policy}", "is_private":"#{repository.private?}"}'
        END_BITBUCKET
      end
      run "git remote add origin #{repository.origin}"
      say "Pushing initial commit to remote #{repository.host} repository", :green
      run 'git push -u origin master'
    end

    def git_repository_user_name(host)
      global_config = Rugged::Config.global
      git_config_key = "nugem.#{host}user"
      user = global_config[git_config_key]

      gh_config = github_config
      user ||= gh_config&.dig('github.com', 'user')

      user = ask "What is your #{host} user name?" if user.to_s.empty?
      global_config[git_config_key] = user if user != global_config[git_config_key]
      user
    end

    def gem_server_url(private_)
      if private_
        global_config = Rugged::Config.global
        git_config_key = 'nugem.gemserver'
        url = global_config[git_config_key]

        if url.to_s.empty?
          url = ask('What is the url of your Geminabox server?')
          global_config[git_config_key] = url
        end
        url
      else
        'https://rubygems.org'
      end
    end
  end
end
