require 'thor'
require_relative 'creategem/git'
require_relative 'creategem/repository'
require_relative 'creategem/version'
require_relative 'util'

module Creategem
  # @return Path to the generated gem
  def self.dest_root(gem_name)
    File.expand_path "generated/#{gem_name}"
  end

  class Cli < Thor
    include Thor::Actions

    package_name 'Creategem'

    # These declarations make the class instance variable values available as an accessor,
    # which is necessary to name template files that are named '%variable_name%.extension'.
    # See https://www.rubydoc.info/gems/thor/Thor/Actions#directory-instance_method
    attr_reader :block_name, :filter_name, :generator_name, :tag_name, :test_framework

    class << self
      def executable_option
        method_option :executable, type: :boolean, default: false,
          desc: 'Include an executable for the gem.'
      end

      def host_option
        method_option :host, type: :string, default: 'github',
          enum: %w[bitbucket github], desc: 'Repository host.'
      end

      def private_option
        method_option :private, type: :boolean, default: false,
          desc: 'Publish the gem on a private repository.'
      end

      def quiet_option
        # options[:quiet] = true
        method_option :quiet, type: :boolean, default: true,
          desc: 'Suppress detailed messages.'
      end

      def test_option(default_value)
        method_option :test_framework, type: :string, default: default_value,
          enum: %w[minitest rspec],
          desc: "Use rspec or minitest for the test framework (default is #{default_value})."
      end
    end
  end
end
