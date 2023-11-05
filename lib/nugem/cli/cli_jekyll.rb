require_relative '../cli'
require_relative 'jekyll_demo'

module Nugem
  class Cli < Thor # rubocop:disable Metrics/ClassLength
    include Thor::Actions

    attr_accessor :class_name, :filter_params, :trailing_args, :trailing_dump, :trailing_params

    desc 'jekyll NAME', 'Creates a new Jekyll plugin scaffold.'

    long_desc <<~END_DESC
      Creates a new Jekyll plugin scaffold with the given NAME,
      by default hosted by GitHub and published on RubyGems.
    END_DESC

    method_option :block, type: :string, repeatable: true,
      desc: 'Specifies the name of a Jekyll block tag.'

    method_option :blockn, type: :string, repeatable: true,
      desc: 'Specifies the name of a Jekyll no-arg block tag.'

    method_option :filter, type: :string, repeatable: true,
      desc: 'Specifies the name of a Jekyll/Liquid filter module.'

    method_option :generator, type: :string, repeatable: true,
      desc: 'Specifies a Jekyll generator.'

    method_option :hooks, type: :string, desc: 'Specifies Jekyll hooks.'

    method_option :tag, name: :string, repeatable: true,
      desc: 'Specifies the name of a Jekyll tag.'

    method_option :tagn, name: :string, repeatable: true,
      desc: 'Specifies the name of a Jekyll no-arg tag.'

    test_option 'rspec'

    def jekyll(gem_name)
      @gem_name = gem_name
      @dir = Nugem.dest_root @gem_name
      @class_name = Nugem.camel_case @gem_name
      @jekyll   = true
      @rspec    = true

      @host           = options['host']
      @private        = options['private']
      @test_framework = options['test_framework']
      @todos          = options['todos']

      create_plain_scaffold @gem_name
      create_jekyll_scaffold
      options.each do |option|
        case option.first
        when 'block' then     option[1].each { |name| create_jekyll_block_scaffold        name }
        when 'blockn' then    option[1].each { |name| create_jekyll_block_no_arg_scaffold name }
        when 'filter' then    option[1].each { |name| create_jekyll_filter_scaffold       name }
        when 'generator' then option[1].each { |name| create_jekyll_generator_scaffold    name }
        when 'tag' then       option[1].each { |name| create_jekyll_tag_scaffold          name }
        when 'tagn' then      option[1].each { |name| create_jekyll_tag_no_arg_scaffold   name }
        when 'hooks' then     create_jekyll_hooks_scaffold option[1]
        when 'host', 'executable', 'private', 'test_framework', 'todos', 'quiet' then next
        else puts "Warning: Unrecognized option: #{option}"
        end
      end

      initialize_repository @gem_name
    end

    no_commands do
      # Invoked by directory action when processing Jekyll tags and block tags
      def parse_jekyll_parameters
        content = @jekyll_parameter_names_types.map do |name, _type|
          "@#{name} = @helper.parameter_specified? '#{name}' # Obtain the value of parameter #{name}"
        end
        content.join "\n      "
      end

      # Invoked by directory action when processing Jekyll tags and block tags
      def dump_jekyll_parameters
        content = @jekyll_parameter_names_types.map do |name, _type|
          "@#{name}='\#{@#{name}}'"
        end
        content.join "\n          "
      end
    end

    private

    # Sets @jekyll_parameter_names_types, which contains a
    # list of pairs that describe each Jekyll/Liquid tag invocation option:
    # [[name1, type1], ... [nameN, typeN]]
    def ask_option_names_types(tag)
      names = ask(set_color("Please list the names of the options for the #{tag} Jekyll/Liquid tag:", :green)).split(/[ ,\t]/)
      types = names.reject(&:empty?).map do |name|
        ask set_color("What is the type of #{name}? (tab autocompletes)", :green),
            default: 'string', limited_to: %w[boolean string numeric]
      end
      @jekyll_parameter_names_types = names.zip types
      @jekyll_parameter_names_types
    end

    def create_jekyll_scaffold
      puts set_color("Creating a Jekyll scaffold for a new gem named #{@gem_name} in #{@dir}", :green)
      @mute = true
      directory 'jekyll/common_scaffold', @dir, force: true, mode: :preserve
      directory 'jekyll/demo', @dir, force: true, mode: :preserve
    end

    def create_jekyll_block_scaffold(block_name)
      @block_name = block_name
      @jekyll_class_name = Nugem.camel_case block_name
      ask_option_names_types block_name # Defines @jekyll_parameter_names_types, which is a nested array of name/value pairs:
      # [["opt1", "string"], ["opt2", "boolean"]]
      puts set_color("Creating Jekyll block tag #{@block_name} scaffold within #{@jekyll_class_name}", :green)
      @mute = true
      directory 'jekyll/block_scaffold', @dir, force: true, mode: :preserve
      append_to_file "#{Nugem.dest_root gem_name}/demo/index.html", Cli.add_demo_example(block_name, @jekyll_parameter_names_types, :block)
    end

    def create_jekyll_block_no_arg_scaffold(block_name)
      @block_name = block_name
      @jekyll_class_name = Nugem.camel_case block_name
      puts set_color("Creating Jekyll block tag no_arg #{@block_name} scaffold within #{@jekyll_class_name}", :green)
      @mute = true
      directory 'jekyll/block_no_arg_scaffold', @dir, force: true, mode: :preserve
      append_to_file "#{Nugem.dest_root gem_name}/demo/index.html", Cli.add_demo_example(block_name, @jekyll_parameter_names_types, :block)
    end

    def create_jekyll_filter_scaffold(filter_name)
      # rubocop:disable Style/StringConcatenation
      @filter_name = filter_name
      @jekyll_class_name = Nugem.camel_case filter_name
      prompt = set_color('Jekyll filters have at least one input. ' \
                         "What are the names of additional inputs for #{filter_name}, if any?", :green)
      @filter_params = ask(prompt)
                         .split(/[ ,\t]/)
                         .reject(&:empty?)
      unless @filter_params.empty?
        @trailing_args   = ', ' + @filter_params.join(', ')
        @trailing_params = ': ' + @filter_params.join(', ')
        @trailing_dump1 = @filter_params.map { |arg| "#{@class_name}.logger.debug { \"#{arg} = \#{#{arg}}\" }" }.join "\n    "
        lspace = "\n      "
        @trailing_dump2 = lspace + @filter_params.map { |arg| "#{arg} = \#{#{arg}}" }.join(lspace) unless @filter_params.empty?
      end
      puts set_color("Creating a new Jekyll filter method scaffold #{@filter_name}", :green)
      @mute = true
      directory 'jekyll/filter_scaffold', @dir, force: true, mode: :preserve

      tp = ': ' + @filter_params.map { |x| "'#{x}_value'" }.join(', ') unless @filter_params.empty?
      append_to_file "#{Nugem.dest_root gem_name}/demo/index.html", Cli.add_filter_example(filter_name, tp)
      # rubocop:enable Style/StringConcatenation
    end

    def create_jekyll_generator_scaffold(generator_name)
      @generator_name = generator_name
      @jekyll_class_name = Nugem.camel_case generator_name
      puts set_color("Creating a new Jekyll generator class scaffold #{@jekyll_class_name}", :green)
      @mute = true
      directory 'jekyll/generator_scaffold', @dir, force: true, mode: :preserve
    end

    def create_jekyll_hooks_scaffold(plugin_name)
      @plugin_name = plugin_name
      @jekyll_class_name = Nugem.camel_case plugin_name
      puts set_color('Creating a new Jekyll hook scaffold', :green)
      @mute = true
      directory 'jekyll/hooks_scaffold', @dir, force: true, mode: :preserve
    end

    def create_jekyll_tag_no_arg_scaffold(tag_name)
      @tag_name = tag_name
      @jekyll_class_name = Nugem.camel_case @tag_name
      puts set_color("Creating Jekyll tag no_arg #{@tag_name} scaffold within #{@jekyll_class_name}", :green)
      @mute = true
      directory 'jekyll/tag_no_arg_scaffold', @dir, force: true, mode: :preserve
      append_to_file "#{Nugem.dest_root gem_name}/demo/index.html", Cli.add_demo_example(tag_name, @jekyll_parameter_names_types, :tag)
    end

    def create_jekyll_tag_scaffold(tag_name)
      @tag_name = tag_name
      @jekyll_class_name = Nugem.camel_case @tag_name
      ask_option_names_types tag_name # Defines @jekyll_parameter_names_types, which is a nested array of name/value pairs:
      # [["opt1", "string"], ["opt2", "boolean"]]
      puts set_color("Creating Jekyll tag #{@tag_name} scaffold within #{@jekyll_class_name}", :green)
      @mute = true
      # puts set_color("@jekyll_parameter_names_types=#{@jekyll_parameter_names_types}", :yellow)
      directory 'jekyll/tag_scaffold', @dir, force: true, mode: :preserve
      append_to_file "#{Nugem.dest_root gem_name}/demo/index.html", Cli.add_demo_example(tag_name, @jekyll_parameter_names_types, :tag)
    end
  end
end
