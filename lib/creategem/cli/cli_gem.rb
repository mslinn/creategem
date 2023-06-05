# Creategem::CLI is a Thor class that is invoked when a user runs a creategem executable
module Creategem
  class CLI < Thor
    desc 'gem NAME', <<~END_DESC
      Creates a new gem with the given NAME, hosted by GitHub and published on RubyGems.
      Options: --private, --no-executable, --bitbucket.
    END_DESC

    option :private, type: :boolean, default: false, desc: <<~END_DESC
      Publish the gem in a private repository,
      instead of the default, which is to publish the gem on Rubygems.
    END_DESC

    option :executable, type: :boolean, default: false,
      desc: 'Create an executable for the gem.'

    option :bitbucket, type: :boolean, default: false, desc: <<~END_DESC
      Create the repository on BitBucket, otherwise host the repository on GitHub (default).
    END_DESC

    def gem(gem_name)
      create_gem_scaffold gem_name
      initialize_repository gem_name
    end

    private

    def create_gem_scaffold(gem_name)
      say "Creating a scaffold for a new gem named #{gem_name} in generated/#{gem_name}.", :green
      @gem_name = gem_name
      @class_name = Thor::Util.camel_case gem_name.tr('-', '_')
      @executable = options[:executable]
      @host = options[:bitbucket] ? :bitbucket : :github
      @private = options[:private]
      @repository = Creategem::Repository.new(host:           @host,
                                              user:           git_repository_user_name(@host),
                                              name:           gem_name,
                                              gem_server_url: gem_server_url(@private),
                                              private:        @private)
      directory 'gem_scaffold', "generated/#{gem_name}"
      directory 'executable_scaffold', "generated/#{gem_name}" if @executable
      template 'LICENCE.txt', "#{gem_name}/LICENCE.txt" if @repository.public?
    end
  end
end
