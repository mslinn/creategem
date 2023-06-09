require_relative '../cli'

module Creategem
  class Cli < Thor
    desc 'jekyll NAME', 'Creates a new Jekyll plugin scaffold.'

    long_desc <<~END_DESC
      Creates a new Jekyll plugin scaffold with the given NAME,
      by default hosted by GitHub and published on RubyGems.
    END_DESC

    method_option :private, type: :boolean, default: false, desc: <<~END_DESC
      Publish the gem on a private repository.
    END_DESC

    method_option :type, type: :string, default: 'tag', enum: %w[tag block generator], repeatable: false,
      desc: 'Specifies the types of plugin.'

    method_option :host, type: :string, default: 'github', enum: %w[bitbucket github],
      desc: 'Repository host.'

    def jekyll(gem_name)
      @gem_name = gem_name
      @dir = Creategem.dest_root gem_name
      @jekyll = true
      @jekyll_types = [options[:type] || 'tag']

      create_gem_scaffold gem_name
      create_jekyll_scaffold

      create_jekyll_tag_scaffold       if @jekyll_types.include? 'tag'
      create_jekyll_block_scaffold     if @jekyll_types.include? 'block'
      create_jekyll_generator_scaffold if @jekyll_types.include? 'generator'

      initialize_repository gem_name
    end

    private

    def create_jekyll_scaffold
      say "Creating a new Jekyll scaffold for a new gem named #{@gem_name} in #{@dir}", :green
      directory 'jekyll_scaffold', @dir
    end

    def create_jekyll_tag_scaffold
      say 'Creating a new Jekyll tag scaffold', :green
      directory 'jekyll_tag_scaffold', @dir
    end

    def create_jekyll_block_scaffold
      say 'Creating a new Jekyll tag block scaffold', :green
      directory 'jekyll_block_scaffold', @dir
    end

    def create_jekyll_generator_scaffold
      say 'Creating a new Jekyll generator scaffold', :green
      directory 'jekyll_generator_scaffold', @dir
    end
  end
end
