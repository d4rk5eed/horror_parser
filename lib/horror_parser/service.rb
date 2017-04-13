class HorrorParser
  class Service
    class << self
      def persist_pages(pages)
        pages.reduce([]) do |acc, page|
          page_body = Nokogiri::HTML(page[:body])
          title = page_body.at_css('header h1').inner_html.strip
          article_body = page_body.at_css('article .mso-page-content').inner_html

          tags = article_body.scan(%r{<strong>(.*)</strong>})
          tags = article_body.scan(%r{<p>(.*)\.*\s*(?:ДА|НЕТ|да|нет|Да|Нет|Возможно)\.*</p>}) if tags.empty?
          if tags.any?
            tags = tags.flatten.map{ |p| normalize(p) }
            tags.select! { |tag| tag.present? }
            persisted_page = Page.create(body: article_body, tags: tags, url: page[:url], title: title)
            acc << { tags: tags, url: page[:url], title: title }
            $logger.info("#{persisted_page.id} persisted for url #{persisted_page.url} and tags #{persisted_page.tags}")
            $logger.debug("Persisted page body #{persisted_page.body}")
          else
            $logger.info("No tags found for url #{page[:url]}")
          end

          acc
        end
      end

      def normalize(text)
        text
          .mb_chars
          .downcase
          .gsub(/^\d+\.\s/, '')
          .gsub(/№/, 'N')
          .gsub(/[^\w\s\p{Cyrillic}]+/, ' ')
          .gsub(/\s{2,}/, ' ')
          .tr('ё', 'е')
          .gsub(/\sда$|\sнет$/, '')
          .strip
          .to_s
      end
    end
  end
end
