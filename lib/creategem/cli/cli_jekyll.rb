require_relative '../cli'

module Creategem
  class Cli < Thor
    desc 'jekyll NAME', 'Creates a new Jekyll plugin scaffold.'

    long_desc <<~END_DESC
      Creates a new Jekyll plugin scaffold with the given NAME,
      by default hosted by GitHub and published on RubyGems.
    END_DESC

    # rubocop:disable Layout/HashAlignment
    method_option :private, type: :boolean, default: false,
      desc: 'Publish the gem on a private repository.'

    method_option :block, type: :string, repeatable: true,
      desc: 'Specifies the name of a Jekyll block tag plugin.'

    method_option :filter, type: :string, repeatable: true,
      desc: 'Specifies the name of a Jekyll/Liquid filter.'

    method_option :generator, type: :boolean,
      desc: 'Specifies a Jekyll generator plugin.'

    method_option :host, type: :string, default: 'github',
      enum: %w[bitbucket github], desc: 'Repository host.'

    method_option :tag, name: :string, repeatable: true,
      desc: 'Specifies the name of a Jekyll tag plugin.'
    # rubocop:enable Layout/HashAlignment

    def jekyll(gem_name)
      @gem_name = gem_name
      @dir = Creategem.dest_root gem_name
      @jekyll = true

      create_gem_scaffold gem_name
      create_jekyll_scaffold

      options.each do |option| # TODO: pass plugn name (except for hooks)
        create_jekyll_block_scaffold     if option == 'block'
        create_jekyll_filter_scaffold    if option == 'filter'
        create_jekyll_generator_scaffold if option == 'generator'
        create_jekyll_hooks_scaffold     if option == 'hooks'
        create_jekyll_tag_scaffold       if option == 'tag'
      end
      initialize_repository gem_name
    end

    private

    def create_jekyll_scaffold
      say "Creating a new Jekyll scaffold for a new gem named #{@gem_name} in #{@dir}", :green
      directory 'jekyll_scaffold', @dir
    end

    def create_jekyll_block_scaffold
      say 'Creating a new Jekyll tag block scaffold', :green
      directory 'jekyll_block_scaffold', @dir
    end

    def create_jekyll_filter_scaffold
      say 'Creating a new Jekyll filter scaffold', :green
      directory 'jekyll_filter_scaffold', @dir
    end

    def create_jekyll_generator_scaffold
      say 'Creating a new Jekyll generator scaffold', :green
      directory 'jekyll_generator_scaffold', @dir
    end

    def create_jekyll_hooks_scaffold
      say 'Creating a new Jekyll hook scaffold', :green
      directory 'jekyll_hooks_scaffold', @dir
    end

    def create_jekyll_tag_scaffold
      say 'Creating a new Jekyll tag scaffold', :green
      directory 'jekyll_tag_scaffold', @dir
    end
  end
end
