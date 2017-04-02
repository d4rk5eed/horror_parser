class HorrorParser
  class Service
    class << self
      def persist_pages(pages)
        pages.each do |page|
          page_body = Nokogiri::HTML(page[:body])
          # title = page.at_css('header h1').inner_html.strip
          article_body = page_body.at_css('article .mso-page-content').inner_html
          tags = article_body.scan(%r{<strong>(.*)</strong>}).flatten.map{ |p| normalize(p) }
          persisted_page = Page.create(body: article_body, tags: tags, url: page[:url])
          $logger.info("#{persisted_page.id} persisted for url #{persisted_page.url} and tags #{persisted_page.tags}")
          $logger.debug("Persisted page body #{persisted_page.body}")
        end
        true
      end

      def normalize(text)
        # TODO need normalizing for these wierd
        # №6
        # 20/18
        # 30-й километр
        # 32
        # "4, 8, 16, 32"
        text
          .mb_chars
          .downcase
          .gsub(/[^\w\s\p{Cyrillic}]+/, ' ')
          .gsub(/\s{2,}/, ' ')
          .tr('ё', 'е')
          .gsub(/\sда$|\sнет$/, '')
          .gsub(/^\d+/, '')
          .strip
          .to_s
      end
    end
  end
end
