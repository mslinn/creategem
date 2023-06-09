require 'jekyll_plugin_support'

module JekyllPluginTagTemplate
  PLUGIN_NAME = 'tag_template'.freeze
end

# This Jekyll tag plugin creates an emoji of the desired size and alignment.
#
# @example Float Smiley emoji right, sized 3em
#     {% tag_template name='smile' align='right' size='5em' %}
#   The above results in the following HTML:
#     <span style="float: right; font-size: 5em;">&#x1F601;</span>
#
# @example Defaults
#     {% tag_template name='smile' %}
#   The above results in the following HTML:
#     <span style="font-size: 3em;">&#x1F601;</span>
#
# The Jekyll log level defaults to :info, which means all the Jekyll.logger statements below will not generate output.
# You can control the log level when you start Jekyll.
# To set the log level to :debug, write an entery into _config.yml, like this:
# plugin_loggers:
#   MyTag: debug
module JekyllTagPlugin
  # This class implements the Jekyll tag functionality
  class MyTag < JekyllSupport::JekyllTag
    include JekyllPluginTemplateVersion

    # Supported emojis (GitHub symbol, hex code) - see https://gist.github.com/rxaviers/7360908 and
    # https://www.quackit.com/character_sets/emoji/emoji_v3.0/unicode_emoji_v3.0_characters_all.cfm
    @@emojis = {
      'angry'      => '&#x1F620;',
      'boom'       => '&#x1F4A5;', # used when requested emoji is not recognized
      'grin'       => '&#128512;',
      'horns'      => '&#128520;',
      'kiss'       => '&#x1F619;',
      'open'       => '&#128515;',
      'poop'       => '&#x1F4A9;',
      'sad'        => '&#128546;',
      'scream'     => '&#x1F631;',
      'smiley'     => '&#x1F601;', # default emoji
      'smirk'      => '&#x1F60F;',
      'two_hearts' => '&#x1F495;',
    }.sort_by { |k, _v| [k] }.to_h

    # @param tag_name [String] is the name of the tag, which we already know.
    # @param argument_string [String] the arguments from the web page.
    # @param tokens [Liquid::ParseContext] tokenized command line
    # @return [void]
    def render_impl
      @emoji_name     = @helper.parameter_specified?('name')  || 'smiley' # Ignored if `list` is specified
      @emoji_align    = @helper.parameter_specified?('align') || 'inline' # Allowable values are: inline, right or left
      @emoji_size     = @helper.parameter_specified?('size')  || '3em'
      @emoji_and_name = @helper.parameter_specified?('emoji_and_name')
      @list           = @helper.parameter_specified?('list')
      @emoji_hex_code = @@emojis[@emoji_name] if @emoji_name || @@emojis['boom']

      # variables defined in pages are stored as hash values in liquid_context
      # _assigned_page_variable = @liquid_context['assigned_page_variable']

      @layout_hash = @page['layout']

      @logger.debug do
        <<~HEREDOC
          liquid_context.scopes=#{@liquid_context.scopes}
          mode="#{@mode}"
          page attributes:
            #{@page.sort
                   .reject { |k, _| REJECTED_ATTRIBUTES.include? k }
                   .map { |k, v| "#{k}=#{v}" }
                   .join("\n  ")}
        HEREDOC
      end

      # Return the value of this Jekyll tag
      if @list
        list
      else
        assemble_emoji(@emoji_name, @emoji_hex_code)
      end
    end

    private

    def assemble_emoji(emoji_name, emoji_hex_code)
      case @emoji_align
      when 'inline'
        align = ''
      when 'right'
        align = ' float: right; margin-left: 5px;'
      when 'left'
        align = ' float: left; margin-right: 5px;'
      else
        @logger.error { "Invalid emoji alignment #{@emoji_align}" }
        align = ''
      end

      name = " <code>#{emoji_name}</code>" if @emoji_and_name

      "<span style='font-size: #{@emoji_size};#{align}'>#{emoji_hex_code}</span>#{name}"
    end

    def list
      items = @@emojis.map do |ename, hex_code|
        "  <li>#{assemble_emoji(ename, hex_code)}</li>"
      end
      <<~END_RESULT
        <ul class='emoji_list'>
          #{items.join("\n  ")}
        </ul>
      END_RESULT
    end

    JekyllPluginHelper.register(self, JekyllPluginTagTemplate::PLUGIN_NAME)
  end
end
