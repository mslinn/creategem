# Creategem::Cli is a Thor class that is invoked when a user runs a creategem executable
require_relative '../cli'

module Creategem
  class Cli < Thor
    desc 'gem NAME', 'Creates a new gem scaffold.'

    long_desc <<~END_DESC
      Creates a new gem scaffold with the given NAME,
      by default hosted by GitHub and published on RubyGems.
    END_DESC

    method_option :private, type: :boolean, default: false, desc: <<~END_DESC
      Publish the gem in a private repository.
    END_DESC

    method_option :executable, type: :boolean, default: false,
      desc: 'Include an executable for the gem.'

    method_option :bitbucket, type: :boolean, default: false, desc: <<~END_DESC
      Host the repository on BitBucket.
    END_DESC

    def gem(gem_name)
      @dir = Creategem.dest_root gem_name
      create_gem_scaffold gem_name
      initialize_repository gem_name
    end

    private

    def create_gem_scaffold(gem_name)
      @gem_name = gem_name
      say "Creating a scaffold for a new gem named #{gem_name} in #{@dir}.", :green
      @class_name = Thor::Util.camel_case gem_name.tr('-', '_')
      @executable = options[:executable]
      @host = options[:bitbucket] ? :bitbucket : :github
      @private = options[:private]
      @repository = Creategem::Repository.new(
        host:           @host,
        user:           git_repository_user_name(@host),
        name:           gem_name,
        gem_server_url: gem_server_url(@private),
        private:        @private
      )
      directory 'gem_scaffold',        @dir
      directory 'executable_scaffold', @dir if @executable
      template  'LICENCE.txt',         "#{@dir}/LICENCE.txt" if @repository.public?
    end
  end
end
