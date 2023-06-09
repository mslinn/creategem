require 'jekyll_plugin_support'

# @example Heading for this example
#   Describe what this example does
#   {% block_tag_template 'parameter' %}
#     Hello, world!
#   {% endblock_tag_template %}
#
# The Jekyll log level defaults to :info, which means all the Jekyll.logger statements below will not generate output.
# You can control the log level when you start Jekyll.
# To set the log level to :debug, write an entery into _config.yml, like this:
# plugin_loggers:
#   MyBlock: debug

module JekyllBlockTagPlugin
  PLUGIN_NAME = 'block_tag_template'.freeze

  # This class implements the Jekyll block tag functionality
  class MyBlock < JekyllSupport::JekyllBlock
    include JekyllPluginTemplateVersion

    REJECTED_ATTRIBUTES = %w[content excerpt next previous].freeze

    # Method prescribed by the Jekyll support plugin.
    # @return [String]
    def render_impl(content)
      @helper.gem_file __FILE__ # This enables attribution

      @param1  = @helper.keys_values['param1'] # Obtain the value of parameter param1
      @param2  = @helper.keys_values['param2']
      @param3  = @helper.keys_values['param3']
      @param4  = @helper.keys_values['param4']
      @param5  = @helper.keys_values['param5']
      @param_x = @helper.keys_values['not_present'] # The value of parameters that are present is nil, but displays as the empty string

      @logger.debug do
        <<~HEREDOC
          tag_name = '#{@helper.tag_name}'
          argument_string = '#{@helper.argument_string}'
          @param1 = '#{@param1}'
          @param2 = '#{@param2}'
          @param3 = '#{@param3}'
          @param4 = '#{@param4}'
          @param5 = '#{@param5}'
          @param_x = '#{@param_x}'
          params =
            #{@helper.keys_values.map { |k, v| "#{k} = #{v}" }.join("\n  ")}
        HEREDOC
      end

      @layout_hash = @envs['layout']

      @logger.debug do
        <<~HEREDOC
          mode="#{@mode}"
          page attributes:
            #{@page.sort
                   .reject { |k, _| REJECTED_ATTRIBUTES.include? k }
                   .map { |k, v| "#{k}=#{v}" }
                   .join("\n  ")}
        HEREDOC
      end

      # Compute the return value of this Jekyll tag
      <<~HEREDOC
        <p style='color: green; background-color: yellow; padding: 1em; border: solid thin grey;'>
          #{content} #{@param1}
          #{@helper.attribute if @helper.attribution}
        </p>
      HEREDOC
    rescue StandardError => e
      @logger.error { "#{self.class} died with a #{e.full_message}" }
      exit 3
    end

    JekyllPluginHelper.register(self, JekyllPluginBlockTagTemplate::PLUGIN_NAME)
  end
end
