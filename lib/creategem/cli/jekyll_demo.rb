module Creategem
  class Cli < Thor
    include Thor::Actions

    def self.combinations(params)
      names = params.map(&:first)
      (0..params.length).flat_map do |n|
        names.combination(n).map { |x| x.join ' ' }
      end
    end

    def self.add_demo_example(tag, params)
      examples = combinations(params).map do |ps|
        names = ps.map(&:first)
        values = ps.map do |p|
          case p[1]
          when 'boolean' then p.first
          when 'string' then "#{p.first}='somevalue' "
          when 'numeric' then "#{p.first}='1234' "
          end
        end
        <<~END_EX
          <!-- #region #{tag} #{values} -->
          <h2 id="#{tag}">#{tag} #{names.join ' '}</h2>
          {% #{tag} #{values.join ' '} %}
          <!-- endregion -->
        END_EX
      end
      examples.join("\n\n")
    end
  end
end
