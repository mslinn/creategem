require 'thor'
require 'git'
require_relative '../creategem'
require_relative 'cli/cli_gem'
require_relative 'cli/cli_rails'

# Creategem::CLI is a Thor class that is invoked when a user runs a creategem executable
# This file defines the common aspects of the Thor class.
# The cli/ directory contains class extensions specific to each Thor subcommand.
module Creategem
  class CLI < Thor
    include Thor::Actions
    include Creategem::Git

    # There must be a method called gem_name.
    # To use gem_name in the file names in the template directory: "generated/%gem_name%"
    attr_accessor :gem_name

    # this is where the thor generator templates are found
    def self.source_root
      File.expand_path('../../templates', __dir__)
    end

    private

    def initialize_repository(gem_name)
      Dir.chdir gem_name do
        run 'chmod +x bin/*'
        run 'chmod +x exe/*' if @executable
        create_local_git_repository
        run 'bundle update'
        create_remote_git_repository @repository if yes? "Do you want me to create #{@host} repository named #{gem_name}? (y/n)"
      end
      say "The gem #{gem_name} was successfully created.", :green
      say "Please complete the information in #{gem_name}.gemspec and README.md (look for TODOs).", :blue
    end
  end
end
