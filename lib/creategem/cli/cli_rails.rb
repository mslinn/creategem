module Creategem
  class Cli < Thor
    desc 'plugin NAME', 'Creates a new Rails plugin .scaffold'

    long_desc <<~END_DESC
      Creates a new Rails plugin scaffold with the given NAME,
      by default hosted by GitHub and published on RubyGems.
    END_DESC

    option :private, type: :boolean, default: false, desc: <<~END_DESC
      Publish the gem on a private repository.
    END_DESC

    option :engine, type: :boolean, default: false,
      desc: 'Create a gem containing a Rails engine.'

    option :mountable, type: :boolean, default: false,
      desc: 'Create a gem containing a mountable Rails engine.'

    option :executable, type: :boolean, default: false,
      desc: 'Include an executable for the gem.'

    option :bitbucket, type: :boolean, default: false,
      desc: 'Host the repository on BitBucket.'

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

    def create_engine_scaffold(gem_name)
      dir = "generated/#{gem_name}"
      say "Creating a new Rails engine scaffold for a new gem named #{gem_name} in #{dir}", :green
      directory 'engine_scaffold', dir
    end

    def create_mountable_scaffold(gem_name)
      dir = "generated/#{gem_name}"
      say "Creating a mountable Rails engine scaffold for a new gem named #{gem_name} in #{dir}", :green
      directory 'mountable_scaffold', dir
    end

    def create_plugin_scaffold(gem_name)
      dir = "generated/#{gem_name}"
      say "Creating a new Rails plugin scaffold for gem named #{gem_name} in #{dir}", :green
      directory 'plugin_scaffold', dir
      Dir.chdir dir do
        run 'chmod +x test/dummy/bin/*'
      end
    end
  end
end
