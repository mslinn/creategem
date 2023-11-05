require 'thor'
require_relative 'util'

module Nugem
  # @return Path to the generated gem
  def self.dest_root(gem_name)
    File.expand_path "generated/#{gem_name}"
  end

  class Cli < Thor
    include Thor::Actions

    package_name 'Nugem'

    # These declarations make the class instance variable values available as an accessor,
    # which is necessary to name template files that are named '%variable_name%.extension'.
    # See https://www.rubydoc.info/gems/thor/Thor/Actions#directory-instance_method
    attr_reader :block_name, :filter_name, :generator_name, :tag_name, :test_framework

    def self.test_option(default_value)
      method_option :test_framework, type: :string, default: default_value,
        enum: %w[minitest rspec],
        desc: "Use rspec or minitest for the test framework (default is #{default_value})."
    end

    # Return a non-zero status code on error. See https://github.com/rails/thor/issues/244
    def self.exit_on_failure?
      true
    end
  end
end

require_relative 'nugem/git'
require_relative 'nugem/cli'
require_relative 'nugem/repository'
require_relative 'nugem/version'
