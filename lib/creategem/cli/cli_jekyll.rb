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

    method_option :generator, type: :string,
      desc: 'Specifies a Jekyll generator plugin.'

    method_option :hooks, type: :boolean,
      desc: 'Specifies a Jekyll hooks plugin.'

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
      options.each do |option|
        case option.first
        when 'block' then     option[1].each { |name| create_jekyll_block_scaffold     name }
        when 'filter' then    option[1].each { |name| create_jekyll_filter_scaffold    name }
        when 'generator' then option[1].each { |name| create_jekyll_generator_scaffold name }
        when 'tag' then       option[1].each { |name| create_jekyll_tag_scaffold       name }
        when 'hooks' then     create_jekyll_hooks_scaffold
        end
      end

      initialize_repository gem_name
    end

    private

    def create_jekyll_scaffold
      say "Creating a new Jekyll scaffold for a new gem named #{@gem_name} in #{@dir}", :green
      directory 'jekyll_scaffold', @dir
    end

    def create_jekyll_block_scaffold(block_name)
      @block_name = block_name
      @jekyll_class_name = camel_case block_name
      say "Creating Jekyll tag block #{@block_name} scaffold within #{@jekyll_class_name}", :green
      directory 'jekyll_block_scaffold', @dir
    end

    def create_jekyll_filter_scaffold(filter_name)
      @filter_name = filter_name
      # @jekyll_class_name = camel_case filter_name
      say "Creating a new Jekyll filter method scaffold #{@filter_name}", :green
      directory 'jekyll_filter_scaffold', @dir
    end

    def create_jekyll_generator_scaffold(generator_name)
      @generator_name = generator_name
      @jekyll_class_name = camel_case generator_name
      say "Creating a new Jekyll generator class scaffold #{@jekyll_class_name}", :green
      directory 'jekyll_generator_scaffold', @dir
    end

    def create_jekyll_hooks_scaffold
      say 'Creating a new Jekyll hook scaffold', :green
      directory 'jekyll_hooks_scaffold', @dir
    end

    def create_jekyll_tag_scaffold(tag_name)
      @tag_name = tag_name
      @jekyll_class_name = camel_case tag_name
      say "Creating Jekyll tag #{@tag_name} scaffold within #{@jekyll_class_name}", :green
      directory 'jekyll_tag_scaffold', @dir
    end
  end
end
