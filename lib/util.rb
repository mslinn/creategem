module Creategem
  def self.camel_case(str)
    Thor::Util.camel_case str.tr('-', '_')
  end

  def self.expand_env(str)
    str.gsub(/\$([a-zA-Z_][a-zA-Z0-9_]*)|\${\g<1>}|%\g<1>%/) do
      ENV.fetch(Regexp.last_match(1), nil)
    end
  end
end
