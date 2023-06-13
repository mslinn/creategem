require_relative '../lib/jekyll_href'

class MyTest
  Dir.chdir 'demo'
  HashArray.reset

  RSpec.describe HrefTag::HrefTag do
    let(:logger) do
      PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
    end

    let(:parse_context) { TestParseContext.new }

    let(:helper) do
      JekyllTagHelper2.new(
        'href',
        'mailto:j.smith@super-fake-merger.com',
        logger
      )
    end

    it 'obtains internal link with blank' do
      href = described_class.send(
        :new,
        'href',
        + 'blank path/page.html internal link text',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq('')
      expect(href.link).to   eq('path/page.html')
      expect(href.target).to eq(" target='_blank'")
      expect(href.text).to   eq('internal link text')
    end

    it 'obtains external link with text' do
      href = described_class.send(
        :new,
        'href',
        + 'summary_exclude https://feeds.soundcloud.com/users/soundcloud:users:7143896/sounds.rss  SoundCloud RSS Feed',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq(" rel='nofollow'")
      expect(href.link).to   eq('https://feeds.soundcloud.com/users/soundcloud:users:7143896/sounds.rss')
      expect(href.target).to eq(" target='_blank'")
      expect(href.text).to   eq('SoundCloud RSS Feed')
    end

    it 'obtains external link using url parameter with text' do
      href = described_class.send(
        :new,
        'href',
        + 'summary_exclude url="https://feeds.soundcloud.com/users/soundcloud:users:7143896/sounds.rss" SoundCloud RSS Feed',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq(" rel='nofollow'")
      expect(href.link).to   eq('https://feeds.soundcloud.com/users/soundcloud:users:7143896/sounds.rss')
      expect(href.target).to eq(" target='_blank'")
      expect(href.text).to   eq('SoundCloud RSS Feed')
    end

    it 'obtains external link without scheme or text' do
      href = described_class.send(
        :new,
        'href',
        + 'super-fake-merger.com',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq(" rel='nofollow'")
      expect(href.link).to   eq('https://super-fake-merger.com')
      expect(href.target).to eq(" target='_blank'")
      expect(href.text).to   eq('<code>super-fake-merger.com</code>')
    end

    it 'expands YAML hash with link text' do
      href = described_class.send(
        :new,
        'href',
        + '{{github}}/diasks2/confidential_info_redactor <code>confidential_info_redactor</code>',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq(" rel='nofollow'")
      expect(href.link).to   eq('https://github.com/diasks2/confidential_info_redactor')
      expect(href.target).to eq(" target='_blank'")
      expect(href.text).to   eq('<code>confidential_info_redactor</code>')
    end

    it 'obtains external link with follow' do
      href = described_class.send(
        :new,
        'href',
        + 'follow https://www.mslinn.com Awesome',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq('')
      expect(href.link).to   eq('https://www.mslinn.com')
      expect(href.target).to eq(" target='_blank'")
      expect(href.text).to   eq('Awesome')
    end

    it 'obtains external link with follow and notarget' do
      href = described_class.send(
        :new,
        'href',
        + 'follow notarget https://www.mslinn.com Awesome',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq('')
      expect(href.link).to   eq('https://www.mslinn.com')
      expect(href.target).to eq('')
      expect(href.text).to   eq('Awesome')
    end

    it 'obtains external link with blank' do
      href = described_class.send(
        :new,
        'href',
        + 'blank https://www.mslinn.com Awesome',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq(" rel='nofollow'")
      expect(href.link).to   eq('https://www.mslinn.com')
      expect(href.target).to eq(" target='_blank'")
      expect(href.text).to   eq('Awesome')
    end

    it 'implicitly computes external link from text' do
      href = described_class.send(
        :new,
        'href',
        + 'www.mslinn.com',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq(" rel='nofollow'")
      expect(href.link).to   eq('https://www.mslinn.com')
      expect(href.target).to eq(" target='_blank'")
      expect(href.text).to   eq('<code>www.mslinn.com</code>')
    end

    it 'implicitly computes external link from text with follow and notarget' do
      href = described_class.send(
        :new,
        'href',
        + 'follow notarget www.mslinn.com',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq('')
      expect(href.link).to   eq('https://www.mslinn.com')
      expect(href.target).to eq('')
      expect(href.text).to   eq('<code>www.mslinn.com</code>')
    end

    it 'implicitly computes external link from text with blank' do
      href = described_class.send(
        :new,
        'href',
        + 'follow blank www.mslinn.com',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq('')
      expect(href.link).to   eq('https://www.mslinn.com')
      expect(href.target).to eq(" target='_blank'")
      expect(href.text).to   eq('<code>www.mslinn.com</code>')

      # hrefs = HashArray.instance_variable_get(:@global_hrefs)
      # expect(hrefs).to eq(
      #   {
      #     "index.html" => [
      #       "<a href='https://feeds.soundcloud.com/users/soundcloud:users:7143896/sounds.rss' target='_blank' rel='nofollow'>SoundCloud RSS Feed</a>",
      #       "<a href='https://github.com/diasks2/confidential_info_redactor' target='_blank' rel='nofollow'><code>confidential_info_redactor</code></a>",
      #       "<a href='https://super-fake-merger.com' target='_blank' rel='nofollow'><code>super-fake-merger.com</code></a>",
      #       "<a href='https://www.mslinn.com' target='_blank'><code>www.mslinn.com</code></a>"
      #     ],
      #   }
      # )
    end

    it 'obtains mailto without text' do
      href = described_class.send(
        :new,
        'href',
        + 'mailto:mslinn@mslinn.com',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq('')
      expect(href.link).to   eq('mailto:mslinn@mslinn.com')
      expect(href.target).to eq('')
      expect(href.text).to   eq('<code>mslinn@mslinn.com</code>')
    end

    it 'obtains mailto with text' do
      href = described_class.send(
        :new,
        'href',
        + 'mailto:mslinn@mslinn.com Mike Slinn',
        parse_context
      )
      href.render TestLiquidContext.new
      expect(href.follow).to eq('')
      expect(href.link).to   eq('mailto:mslinn@mslinn.com')
      expect(href.target).to eq('')
      expect(href.text).to   eq('Mike Slinn')
    end
  end
end
