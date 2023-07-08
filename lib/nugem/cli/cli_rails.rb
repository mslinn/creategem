require_relative '../cli'

module Nugem
  class Cli < Thor
    include Thor::Actions
    include Nugem::Git

    desc 'rails NAME', 'Creates a new Rails rails scaffold.'

    long_desc <<~END_DESC
      Creates a new Rails rails scaffold with the given NAME,
      by default hosted by GitHub and published on RubyGems.
    END_DESC

    method_option :engine, type: :boolean, default: false,
      desc: 'Create a gem containing a Rails engine.'

    test_option 'minitest'

    method_option :mountable, type: :boolean, default: false,
      desc: 'Create a gem containing a mountable Rails engine.'

    def rails(gem_name)
      @host           = options['host']
      @mountable      = options['mountable']
      @private        = options['private']
      @test_framework = options['test_framework']

      @dir = Nugem.dest_root gem_name
      @engine = @host || @mountable
      @rails = true

      create_plain_scaffold gem_name
      create_rails_scaffold gem_name
      create_engine_scaffold gem_name if @engine
      create_mountable_scaffold gem_name if @mountable
      initialize_repository gem_name
    end

    private

    def create_engine_scaffold(gem_name)
      say "Creating a new Rails engine scaffold for a new gem named #{gem_name} in #{@dir}", :green
      directory 'rails/engine_scaffold', @dir, force: true, mode: :preserve
    end

    def create_mountable_scaffold(gem_name)
      say "Creating a mountable Rails engine scaffold for a new gem named #{gem_name} in #{@dir}", :green
      directory 'rails/mountable_scaffold', @dir, force: true, mode: :preserve
    end

    def create_rails_scaffold(gem_name)
      say "Creating a new Rails plugin scaffold as a gem named #{gem_name} in #{@dir}", :green
      directory 'rails/rails_scaffold', @dir, force: true, mode: :preserve
      Dir.chdir @dir do
        run 'chmod +x test/dummy/bin/*' # TODO: fix me
      end
    end
  end
end
