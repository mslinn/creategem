require 'jekyll_plugin_logger'

# Sample Jekyll filter.
module MyJekyllFilter
  class << self
    attr_accessor :logger
  end
  self.logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)

  # This Jekyll filter evaluates the input string and returns the result.
  # Use it as a calculator or one-line Ruby program evaluator.
  #
  # @param input_string [String].
  # @return [String] input string and the evaluation result.
  # @example Use.
  #   {{ '1+2/3' | my_filter }} => "<pre>1+2/3 = 2.5</pre>"
  def my_filter(input_string)
    input_string.strip!
    self.logger.debug { "input_string=#{input_string}" }
    "<pre>#{input_string} = #{eval input_string}</pre>"
    end

  PluginMetaLogger.instance.logger.info { "Loaded MyJekyllFilter plugin." }
end

Liquid::Template.register_filter(JekyllFilterTemplate)
