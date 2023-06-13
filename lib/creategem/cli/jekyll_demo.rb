module Creategem
  class Cli < Thor
    include Thor::Actions

    private

    def add_demo_example(tag)
      <<~END_EX
        <!-- #region tag1 -->
        <h2 id="#{tag}">#{tag}</h2>
        <p>
          <code>#{tag}</code> option.
        </p>
        {% #{tag} %}
        <!-- endregion -->
      END_EX
    end
  end
end
