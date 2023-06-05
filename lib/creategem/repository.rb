# Creategem::Repository contains informations about the git repository and the git user
module Creategem
  class Repository
    attr_reader :gem_server_url, :global_config, :host, :name, :private, :user, :user_name, :user_email

    REPOSITORIES = { github: 'github.com', bitbucket: 'bitbucket.org' }.freeze

    def initialize(options)
      @host = options[:host]
      @private = options[:private]
      @name = options[:name]
      @user = options[:user]
      @global_config = Rugged::Config.global
      abort 'Git global config not found' if @global_config.nil?

      @user_name  = @global_config['user.name']
      @user_email = @global_config['user.email']
      @gem_server_url = options[:gem_server_url]
      @private = options[:private]
    end

    def github?
      @host == :github
    end

    def bitbucket?
      @host == :bitbucket
    end

    # TODO: Currently all private repositories are on BitBucket and all public repos are on GitHub
    # TODO: Drop BitBucket?
    # TODO: Support private repos on GitHub
    def private?
      @private
    end

    def public?
      !@private
    end

    def url
      "https://#{REPOSITORIES[@host]}/#{@user}/#{@name}"
    end

    def origin
      "git@#{REPOSITORIES[@host]}:#{@user}/#{@name}.git"
    end
  end
end
