require 'thor'

module Creategem
  module Git
    include Thor::Actions

    def create_local_git_repository
      say 'Create local git repository', :green
      run 'git init'
      run 'git add .'
      run "git commit -aqm 'Initial commit'"
    end

    def create_remote_git_repository(repository)
      say "Create remote #{repository.host} repository", :green
      if repository.github?
        token = ask('Please enter your Github personal access token', echo: false)
        run <<~END_CURL
          curl --request POST \
            --user '#{repository.user}:#{token}' \
            https://api.github.com/user/repos \
            -d '{"name":"#{repository.name}", "private":#{repository.private?}}'
        END_CURL
      else # BitBucket
        password = ask('Please enter yout Bitbucket password', echo: false)
        fork_policy = repository.public? ? 'allow_forks' : 'no_public_forks'
        run "curl --request POST --user #{repository.user}:#{password} https://api.bitbucket.org/2.0/repositories/#{repository.user}/#{repository.name} -d '{\"scm\":\"git\", \"fork_policy\":\"#{fork_policy}\", \"is_private\":\"#{repository.private?}\"}'"
      end
      run "git remote add origin #{repository.origin}"
      say "Push initial commit to remote #{repository.host} repository", :green
      run 'git push -u origin master'
    end

    def git_repository_user_name(host)
      git_config_key = "creategem.#{host}user"
      user = ::Git.global_config(git_config_key)
      if user.nil? || user.empty?
        user = ask("What is your #{host} user name?")
        ::Git.global_config(git_config_key, user)
      end
      user
    end

    def gem_server_url(private)
      if private
        git_config_key = 'creategem.gemserver'
        url = ::Git.global_config(git_config_key)
        if url.nil? || url.empty?
          url = ask('What is the url of your geminabox server?')
          ::Git.global_config(git_config_key, url)
        end
        url
      else
        'https://rubygems.org'
      end
    end
  end
end
