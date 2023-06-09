require 'thor'

class Cli < Thor
  desc 'test NAME', 'I do not exist therefore I am confused.'

  method_option :type, type: :string, default: 'tag', enum: %w[tag block generator], repeatable: true,
    desc: 'Specifies the types of plugin.'

  def test
    type = options[:type]
    puts type
  end
end

Cli.start
