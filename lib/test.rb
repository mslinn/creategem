require 'thor'

# Call like this:
# $ ruby lib/test.rb test --type block
class Cli < Thor
  desc 'test NAME', 'I do not exist therefore I am confused.'

  method_option :type, type: :string, default: 'tag', enum: %w[tag block generator], repeatable: true,
    desc: 'Specifies the types of plugin.'

  def test
    puts options[:type]
  end
end

Cli.start
