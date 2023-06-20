require_relative '../cli'

module Creategem
  class Cli < Thor
    include Thor::Actions
    include Creategem::Git

    desc 'plugin NAME', 'Creates a new Rails plugin scaffold.'

    long_desc <<~END_DESC
      Creates a new Rails plugin scaffold with the given NAME,
      by default hosted by GitHub and published on RubyGems.
    END_DESC

    method_option :engine, type: :boolean, default: false,
      desc: 'Create a gem containing a Rails engine.'

    executable_option

    host_option

    test_option 'minitest'

    method_option :mountable, type: :boolean, default: false,
      desc: 'Create a gem containing a mountable Rails engine.'

    private_option

    def plugin(gem_name)
      @host           = options['host']
      @mountable      = options['mountable']
      @private        = options['private']
      @test_framework = options['test_framework']

      @dir = Creategem.dest_root gem_name
      @engine = @host || @mountable
      @plugin = true

      create_gem_scaffold gem_name
      create_plugin_scaffold gem_name
      create_engine_scaffold gem_name if @engine
      create_mountable_scaffold gem_name if @mountable
      initialize_repository gem_name
    end

    private

    def create_engine_scaffold(gem_name)
      say "Creating a new Rails engine scaffold for a new gem named #{gem_name} in #{@dir}", :green
      directory 'rails/engine_scaffold', @dir, force: true
    end

    def create_mountable_scaffold(gem_name)
      say "Creating a mountable Rails engine scaffold for a new gem named #{gem_name} in #{@dir}", :green
      directory 'rails/mountable_scaffold', @dir, force: true
    end

    def create_plugin_scaffold(gem_name)
      say "Creating a new Rails plugin scaffold for gem named #{gem_name} in #{@dir}", :green
      directory 'rails/plugin_scaffold', @dir, force: true
      Dir.chdir @dir do
        run 'chmod +x test/dummy/bin/*'
      end
    end
  end
end
