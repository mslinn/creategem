require 'thor'

# Creategem::Cli is a Thor class that is invoked when a user runs a creategem executable
require_relative '../cli'

module Creategem
  class Cli < Thor
    include Thor::Actions
    include Creategem::Git

    desc 'gem NAME', 'Creates a new gem scaffold.'

    long_desc <<~END_DESC
      Creates a new gem scaffold with the given NAME,
      by default hosted by GitHub and published on RubyGems.
    END_DESC

    executable_option

    method_option :host, type: :string, default: 'github',
      enum: %w[bitbucket github], desc: 'Repository host.'

    method_option :private, type: :boolean, default: false,
    desc: 'Publish the gem in a private repository.'

    def gem(gem_name)
      @dir = Creategem.dest_root gem_name

      @host           = options['host']
      @private        = options['private']
      @test_framework = options['test_framework']

      create_gem_scaffold gem_name
      initialize_repository gem_name
    end

    private

    # Defines globals for templates
    def create_gem_scaffold(gem_name)
      @gem_name = gem_name
      say "Creating a scaffold for a new gem named #{@gem_name} in #{@dir}.", :green
      @class_name = Creategem.camel_case @gem_name
      @executable = options[:executable]
      @host = options[:bitbucket] ? :bitbucket : :github
      @private = options[:private]
      @repository = Creategem::Repository.new(
        host:           @host,
        user:           git_repository_user_name(@host),
        name:           @gem_name,
        gem_server_url: gem_server_url(@private),
        private:        @private
      )
      directory 'common/gem_scaffold',        @dir, force: true, mode: :preserve
      directory 'common/executable_scaffold', @dir, force: true, mode: :preserve if @executable
      template  'common/LICENCE.txt',         "#{@dir}/LICENCE.txt", force: true if @repository.public?
    end
  end
end
