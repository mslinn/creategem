require 'thor'

module Nugem
  class Cli < Thor
    include Thor::Actions

    desc 'gem NAME', 'Creates a new gem scaffold.'

    long_desc <<~END_DESC
      Creates a new gem scaffold with the given NAME,
      by default hosted by GitHub and published on RubyGems.
    END_DESC

    method_option :host, type: :string, default: 'github',
      enum: %w[bitbucket github], desc: 'Repository host.'

    method_option :private, type: :boolean, default: false,
      desc: 'Publish the gem in a private repository.'

    def gem(gem_name)
      # puts set_color("gem_name=#{gem_name}", :yellow)
      super if gem_name.empty?

      @executable = options[:executable]
      @host           = options[:host] # FIXME: conflicts with @host in create_gem_scaffold()
      @out_dir        = options[:out_dir]
      @private        = options[:private]
      @test_framework = options[:test_framework]
      @yes            = options[:yes]

      @dir = Nugem.dest_root @out_dir, gem_name

      create_plain_scaffold gem_name
      initialize_repository gem_name
    end

    private

    # Defines globals for templates
    def create_plain_scaffold(gem_name)
      @gem_name = gem_name
      @class_name = Nugem.camel_case @gem_name
      @host       = options[:bitbucket] ? :bitbucket : :github # FIXME: conflicts with @host in gem()
      @repository = Nugem::Repository.new(
        host:           @host,
        user:           git_repository_user_name(@host),
        name:           @gem_name,
        gem_server_url: gem_server_url(@private),
        private:        @private
      )
      puts set_color("Creating a scaffold for a new Ruby gem named #{@gem_name} in #{@dir}.", :green)
      exclude_pattern = case @test_framework
                        when 'minitest' then /spec.*/
                        when 'rspec'    then /test.*/
                        end
      directory('common/gem_scaffold',        @dir, force: true, mode: :preserve, exclude_pattern:)
      directory 'common/executable_scaffold', @dir, force: true, mode: :preserve if @executable
      template  'common/LICENCE.txt',         "#{@dir}/LICENCE.txt", force: true if @repository.public?
    end
  end
end
