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
      def test_option(default_value)
        method_option :test_framework, type: :string, default: default_value,
          enum: %w[minitest rspec],
          desc: "Use rspec or minitest for the test framework (default is #{default_value})."
      end
    end
  end
end
