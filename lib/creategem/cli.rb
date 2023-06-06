require 'thor'
require 'rugged'
require_relative '../creategem'
require_relative 'cli/cli_gem'
require_relative 'cli/cli_jekyll'
require_relative 'cli/cli_rails'

# Creategem::Cli is a Thor class that is invoked when a user runs a creategem executable.
# This file defines the common aspects of the Thor class.
# The cli/ directory contains class extensions specific to each Thor subcommand.
module Creategem
  # @return Path to the generated gem
  def self.dest_root(gem_name)
    File.expand_path "../../generated/#{gem_name}"
  end

  class Cli < Thor
    include Thor::Actions
    include Creategem::Git

    # Surround gem_name with percent symbols when using the property to name file within the template directory
    # For example: "generated/%gem_name%"
    attr_accessor :gem_name

    def self.exit_on_failure?
      true
    end

    # @return Path to the Thor generator templates
    def self.source_root
      File.expand_path '../../templates', __dir__
    end

    private

    def count_todos(filename)
      filename_fq = "#{Creategem.dest_root(gem_name)}/#{filename}"
      content = File.read filename_fq
      content.scan(/TODO/).length
    end

    def initialize_repository(gem_name)
      Dir.chdir Creategem.dest_root(gem_name) do
        # say "Working in #{Dir.pwd}", :yellow
        run 'chmod +x bin/*'
        run 'chmod +x exe/*' if @executable
        create_local_git_repository
        run 'bundle update'
        create_remote_git_repository @repository \
          if yes? "Do you want to create a repository on #{@repository.host_camel_case} named #{gem_name}? (y/n)"
      end
      say "The #{gem_name} gem was successfully created.", :green
      msg = <<~END_TODO
        Please complete the #{count_todos "#{gem_name}.gemspec"} TODOs in #{gem_name}.gemspec
        and the #{count_todos 'README.md'} TODOs in README.md.
      END_TODO
      say msg, :blue
    end
  end
end
