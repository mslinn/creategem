# Inspired by the badly broken example on https://jekyllrb.com/docs/plugins/generators/, and completely redone so it works.
module CategoryIndexGenerator
  # Creates an index page for each catagory, plus a main index, all within a directory called _site/categories.
  class CategoryGenerator < Jekyll::Generator
    safe true

    # Only generates content in development mode
    # rubocop:disable Style/StringConcatenation, Metrics/AbcSize
    def generate(site)
      # This plugin is disabled unless _config.yml contains an entry for category_generator_enable and the value is not false
      return if site.config['category_generator_enable']

      return if site.config['env']['JEKYLL_ENV'] == 'production'

      index = Jekyll::PageWithoutAFile.new(site, site.source, 'categories', 'index.html')
      index.data['layout'] = 'default'
      index.data['title'] = 'Post Categories'
      index.content = '<p>'

      site.categories.each do |category, posts|
        new_page = Jekyll::PageWithoutAFile.new(site, site.source, 'categories', "#{category}.html")
        new_page.data['layout'] = 'default'
        new_page.data['title'] = "Category #{category} Posts"
        new_page.content = '<p>' + posts.map do |post|
          "<a href='#{post.url}'>#{post.data['title']}</a><br>"
        end.join("\n") + "</p>\n"
        site.pages << new_page
        index.content += "<a href='#{category}.html'>#{category}</a><br>\n"
      end
      index.content += '</p>'
      site.pages << index
    end
    # rubocop:enable Style/StringConcatenation, Metrics/AbcSize
  end

  PluginMetaLogger.instance.logger.info { 'Loaded CategoryGenerator plugin.' }
end
