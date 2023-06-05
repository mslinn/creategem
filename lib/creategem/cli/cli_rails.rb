module Creategem
  class CLI < Thor
    include Thor::Actions
    include Creategem::Git

    desc 'plugin NAME', <<~END_DESC
      Create a new Rails plugin with the given NAME, hosted on GitHub.
      Options: --private, --executable, --engine, --mountable, --bitbucket
    END_DESC

    option :private, type: :boolean, default: false, desc: <<~END_DESC
      Publish the gem on a private Geminabox repository,
      instead of the default, which is to publish the gem on Rubygems.
    END_DESC

    option :engine, type: :boolean, default: false,
      desc: 'Create a gem containing a Rails engine.'
    option :mountable, type: :boolean, default: false,
      desc: 'Create a gem containing a mountable rails engine.'
    option :executable, type: :boolean, default: false,
      desc: 'Create a gem containing an executable.'
    option :bitbucket, type: :boolean, default: false,
      desc: 'Host the repository on BitBucket, instead of the default, which is to host on GitHub.'

    def plugin(gem_name)
      @plugin = true
      @engine = options[:engine] || options[:mountable]
      @mountable = options[:mountable]
      create_gem_scaffold gem_name
      create_plugin_scaffold gem_name
      create_engine_scaffold gem_name if @engine
      create_mountable_scaffold gem_name if @mountable
      initialize_repository gem_name
    end

    private

    def create_plugin_scaffold(gem_name)
      say "Creating a new Rails plugin scaffold for gem named #{gem_name} in generated/#{gem_name}", :green
      directory 'plugin_scaffold', "generated/#{gem_name}"
      Dir.chdir gem_name do
        run 'chmod +x test/dummy/bin/*'
      end
    end

    def create_engine_scaffold(gem_name)
      say "Creating a new Rails engine scaffold for a new gem named #{gem_name} in generated/#{gem_name}", :green
      directory 'engine_scaffold', "generated/#{gem_name}"
    end

    def create_mountable_scaffold(gem_name)
      say "Creating a mountable Rails engine scaffold for a new gem named #{gem_name} in generated/#{gem_name}", :green
      directory 'mountable_scaffold', "generated/#{gem_name}"
    end
  end
end
