module Creategem
  class Cli < Thor
    include Thor::Actions

    def self.combinations(params)
      (0..params.length).flat_map do |n|
        params.combination(n).map do |param|
          next [] if param.empty?

          param.flat_map do |p|
            name = p.first
            type = p[1]
            case type
            when 'boolean' then name
            when 'string' then "#{name}='somevalue'"
            when 'numeric' then "#{name}=1234"
            else "#{name} has unknown type: #{type}"
            end
          end
        end
      end
    end

    def self.add_demo_example(tag, params)
      last_tag = ''
      examples = combinations(params).map do |option|
        options = option.join ' '
        label = options.empty? ? ' (invoked without parameters)' : options
        example = <<~END_EX
          <!-- #region #{tag} #{label} -->
          <h3 id="#{tag}" class="code">#{tag} #{label}</h3>
          {% #{tag} #{options} %}
          <!-- endregion -->
        END_EX
        if tag != last_tag
          last_tag = tag
          "<h2 id=\"tag_#{tag}\" class='code'>#{tag}</h2>\n" + example
        else
          example
        end
      end
      examples.join("\n\n")
    end
  end
end
