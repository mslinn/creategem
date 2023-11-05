require 'thor'

# Nugem::Cli is a Thor class that is invoked when a user runs a nugem executable
require_relative '../cli'

module Nugem
  class Cli < Thor
    include Thor::Actions
    include Nugem::Git

    desc 'plain NAME', 'Creates a new plain gem scaffold.'

    long_desc <<~END_DESC
      Creates a new plain gem scaffold with the given NAME,
      by default hosted by GitHub and published on RubyGems.
    END_DESC

    method_option :host, type: :string, default: 'github',
      enum: %w[bitbucket github], desc: 'Repository host.'

    method_option :private, type: :boolean, default: false,
      desc: 'Publish the gem in a private repository.'

    def plain(gem_name)
      say "gem_name=#{gem_name}".yellow
      super if gem_name.empty?

      @dir = Nugem.dest_root gem_name

      @host           = options['host']
      @private        = options['private']
      @test_framework = options['test_framework']

      create_plain_scaffold gem_name
      initialize_repository gem_name
    end

    private

    # Defines globals for templates
    def create_plain_scaffold(gem_name)
      @gem_name = gem_name
      say "Creating a scaffold for a new plain Ruby gem named #{@gem_name} in #{@dir}.", :green
      @class_name = Nugem.camel_case @gem_name
      @executable = options[:executable]
      @host = options[:bitbucket] ? :bitbucket : :github
      @private = options[:private]
      @repository = Nugem::Repository.new(
        host:           @host,
        user:           git_repository_user_name(@host),
        name:           @gem_name,
        gem_server_url: gem_server_url(@private),
        private:        @private
      )
      exclude_pattern = case @test_framework
                        when 'minitest' then /spec.*/
                        when 'rspec'    then /test.*/
                        end
      directory('common/gem_scaffold',        @dir, force: true, mode: :preserve, exclude_pattern:)
      directory 'common/executable_scaffold', @dir, force: true, mode: :preserve if @executable
      template  'common/LICENCE.txt',         "#{@dir}/LICENCE.txt", force: true if @repository.public?
    end
  end
end
