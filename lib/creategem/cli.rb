require 'fileutils'
require 'rugged'
require_relative '../creategem'

# Creategem::Cli is a Thor class that is invoked when a user runs a creategem executable.
# This file defines the common aspects of the Thor class.
# The cli/ directory contains class extensions specific to each Thor subcommand.
module Creategem
  class Cli < Thor
    include Thor::Actions
    include Creategem::Git

    class_option :executable, type: :boolean, default: false,
      desc: 'Include an executable for the gem.'

    class_option :host, type: :string, default: 'github',
      enum: %w[bitbucket github], desc: 'Repository host.'

    class_option :private, type: :boolean, default: false,
      desc: 'Publish the gem on a private repository.'

    class_option :quiet, type: :boolean, default: true,
      desc: 'Suppress detailed messages.', group: :runtime

    class_option :todos, type: :boolean, default: true,
      desc: 'Generate TODO: messages in generated code.', group: :runtime

    # Surround gem_name with percent symbols when using the property to name files
    # within the template directory
    # For example: "generated/%gem_name%"
    attr_accessor :gem_name

    require_relative 'cli/cli_gem'
    require_relative 'cli/cli_jekyll'
    require_relative 'cli/cli_rails'

    def self.exit_on_failure?
      true
    end

    # @return Path to the Thor generator templates
    def self.source_root
      File.expand_path '../../templates', __dir__
    end

    def self.todo
      'TODO: ' if @todos
    end

    private

    def count_todos(filename)
      filename_fq = "#{Creategem.dest_root gem_name}/#{filename}"
      content = File.read filename_fq
      content.scan(/TODO/).length
    end

    def initialize_repository(gem_name)
      Dir.chdir Creategem.dest_root(gem_name) do
        # say "Working in #{Dir.pwd}", :green
        run 'chmod +x bin/*'
        run 'chmod +x exe/*' if @executable
        create_local_git_repository
        FileUtils.rm_f 'Gemfile.lock'
        # say "Running 'bundle install'", :green
        # run 'bundle', abort_on_failure: false
        say 'Creating remote repository', :green
        create_remote_git_repository @repository \
          if yes? "Do you want to create a repository on #{@repository.host.camel_case} named #{gem_name}? (y/n)"
      end
      say "The #{gem_name} gem was successfully created.", :green
      report_todos gem_name
    end

    def report_todos(gem_name)
      gemspec_todos = count_todos "#{gem_name}.gemspec"
      readme_todos  = count_todos 'README.md'
      if readme_todos.zero? && gemspec_todos.zero?
        say "There are no TODOs. You can run 'bundle install' from within your new gem project now.", :blue
        return
      end

      msg = 'Please complete'
      msg << " the #{gemspec_todos} TODOs in #{gem_name}.gemspec" if gemspec_todos.positive?
      msg << ' and' if gemspec_todos.positive? && readme_todos.positive?
      msg << " the #{readme_todos} TODOs in README.md." if readme_todos.positive?
      say msg, :yellow
    end
  end
end
