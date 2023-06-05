require 'thor'
require 'rugged'
require_relative '../creategem'
require_relative 'cli/cli_gem'
require_relative 'cli/cli_rails'

# Creategem::CLI is a Thor class that is invoked when a user runs a creategem executable.
# This file defines the common aspects of the Thor class.
# The cli/ directory contains class extensions specific to each Thor subcommand.
module Creategem
  class CLI < Thor
    include Thor::Actions
    include Creategem::Git

    # Surround gem_name with percent symbols when using the property to name file within the template directory
    # For example: "generated/%gem_name%"
    attr_accessor :gem_name

    # @return Path to the Thor generator templates
    def self.source_root
      File.expand_path '../../templates', __dir__
    end

    private

    def count_todos(filename)
      content = File.read "#{source_root}/#{filename}"
      content.scan(/TODO:/).length
    end

    def initialize_repository(gem_name)
      Dir.chdir gem_name do
        run 'chmod +x bin/*'
        run 'chmod +x exe/*' if @executable
        create_local_git_repository
        run 'bundle update'
        create_remote_git_repository @repository \
          if yes? "Do you want to create a repository on #{@host} named #{gem_name}? (y/n)"
      end
      say "The #{gem_name} gem was successfully created.", :green
      msg <<~END_TODO
        Please complete the #{count_todos "#{gem_name}.gemspec"} TODOs in #{gem_name}.gemspec
        and the #{count_todos 'README.md'} TODOs in README.md.
      END_TODO
      say msg, :blue
    end
  end
end
