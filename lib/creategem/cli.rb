require 'thor'
require 'git'
# require 'creategem'

# Creategem::CLI is a Thor class that is invoked when a user runs a creategem executable
module Creategem
  class CLI < Thor
    include Thor::Actions
    include Creategem::Git

    # there has to be a method gem_name to use gem_name in the file names in the template directory: %gem_name%
    attr_accessor :gem_name

    # this is where the thor generator templates are found
    def self.source_root
      File.expand_path('../../../templates', __FILE__)
    end

    desc "gem NAME", "Creates a new gem with a given NAME with Github git repository; Options: --private (Geminabox), --no-executable, --bitbucket"
    option :private, type: :boolean, default: false, desc: "When true, gem is published in a private geminabox repository, otherwise gem is published to Rubygems (default)"
    option :executable, type: :boolean, default: true, desc: "When true, gem with executable is created"
    option :bitbucket, type: :boolean, default: false, desc: "When true, bitbucket repository is created, otherwise Github (default)"
    def gem(gem_name)
      create_gem_scaffold(gem_name)
      initialize_repository(gem_name)
    end

    desc "plugin NAME", "Creates a new rails plugin with a given NAME with Github git repository; Options: --private (Geminabox), --executable, --engine, --mountable, --bitbucket"
    option :private, type: :boolean, default: false, desc: "When true, gem is published in a private geminabox repository, otherwise gem is published to Rubygems (default)"
    option :engine, type: :boolean, default: false, desc: "When true, gem with rails engine is created"
    option :mountable, type: :boolean, default: false, desc: "When true, gem with mountable rails engine is created"
    option :executable, type: :boolean, default: false, desc: "When true, gem with executable is created"
    option :bitbucket, type: :boolean, default: false, desc: "When true, bitbucket repository is created, otherwise Github (default)"
    def plugin(gem_name)
      @plugin = true
      @engine = options[:engine] || options[:mountable]
      @mountable = options[:mountable]
      create_gem_scaffold(gem_name)
      create_plugin_scaffold(gem_name)
      create_engine_scaffold(gem_name) if @engine
      create_mountable_scaffold(gem_name) if @mountable
      initialize_repository(gem_name)
    end

    private

    def create_gem_scaffold(gem_name)
      say "Create a gem scaffold for gem named: #{gem_name}", :green
      @gem_name = gem_name
      @class_name = Thor::Util.camel_case(gem_name.gsub("-", "_"))
      @executable = options[:executable]
      @vendor = options[:bitbucket] ? :bitbucket : :github
      @repository = Creategem::Repository.new(vendor: @vendor,
                                              user: git_repository_user_name(@vendor),
                                              name: gem_name,
                                              gem_server_url: gem_server_url(@vendor),
                                              private: options[:private])
      directory "gem_scaffold", gem_name
      if @executable
        directory "executable_scaffold", gem_name
      end
      if @repository.public?
        template "LICENCE.txt", "#{gem_name}/LICENCE.txt"
      end
    end

    def create_plugin_scaffold(gem_name)
      say "Create a rails plugin scaffold for gem named: #{gem_name}", :green
      directory "plugin_scaffold", gem_name
      Dir.chdir gem_name do
        run "chmod +x test/dummy/bin/*"
      end
    end

    def create_engine_scaffold(gem_name)
      say "Create a rails engine scaffold for gem named: #{gem_name}", :green
      directory "engine_scaffold", gem_name
    end

    def create_mountable_scaffold(gem_name)
      say "Create a rails mountable engine scaffold for gem named: #{gem_name}", :green
      directory "mountable_scaffold", gem_name
    end

    def initialize_repository(gem_name)
      Dir.chdir gem_name do
        run "chmod +x bin/*"
        run "chmod +x exe/*" if @executable
        create_local_git_repository
        run "bundle update"
        create_remote_git_repository(@repository) if yes?("Do you want me to create #{@vendor} repository named #{gem_name}? (y/n)")
      end
      say "The gem #{gem_name} was successfully created.", :green
      say "Please complete the information in #{gem_name}.gemspec and README.md (look for TODOs).", :blue
    end
  end
end
