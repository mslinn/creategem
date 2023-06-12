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
    end
  end
end
