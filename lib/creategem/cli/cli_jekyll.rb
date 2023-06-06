module Creategem
  class Cli < Thor
    desc 'jekyll NAME', 'Creates a new Jekyll plugin scaffold.'

    long_desc <<~END_DESC
      Creates a new Jekyll plugin scaffold with the given NAME,
      by default hosted by GitHub and published on RubyGems.
    END_DESC

    option :private, type: :boolean, default: false, desc: <<~END_DESC
      Publish the gem on a private repository.
    END_DESC

    option :type, type: :string, default: 'tag',
      desc: 'Specifies the type of plugin. Allowable values are: tag, block and generator.'

    option :bitbucket, type: :boolean, default: false,
      desc: 'Host the repository on BitBucket.'

    def jekyll(gem_name)
      @jekyll = true
      @jekyll_type = options[:type]
      create_gem_scaffold gem_name
      create_jekyll_scaffold gem_name
      create_jekyll_tag_scaffold gem_name if @jekyll_type == 'tag'
      create_jekyll_block_scaffold gem_name if @jekyll_type == 'block'
      create_jekyll_generator_scaffold gem_name if @jekyll_type == 'generator'
      initialize_repository gem_name
    end

    private

    def create_jekyll_scaffold(gem_name)
      # TODO: write me
    end

    def create_jekyll_tag_scaffold(gem_name)
      # TODO: write me
    end

    def create_jekyll_block_scaffold(gem_name)
      # TODO: write me
    end

    def create_jekyll_generator_scaffold(gem_name)
      # TODO: write me
    end
  end
end
