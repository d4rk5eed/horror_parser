require 'open-uri'
class HorrorParser
  class Crawler
    def initialize
      @start_url = $config[:start_url]
    end

    def last_article_time
      @last_article_time ||= Setting.last.last_article_time
    end

    def update_last_article_time(timestamp)
      Setting.last.update_attribute(:last_article_time, timestamp)
      $logger.info "Checkpoint updated to: #{timestamp}"
    end

    def init_check_point(checkpoint)
      @check_point ||= checkpoint
    end

    def check_point
      @check_point
    end

    def persist_new_pages
      $logger.info "Crawling started with checkpoint: #{last_article_time}"
      article_list = []
      url = @start_url

      loop do
        html = open(url)
        doc = Nokogiri::HTML(html)
        next_page_link = doc.at_css('.pagination-next')

        cycle_break = false
        doc.css('article').each do |article|
          article_link = article.at_css('header h1 a')
          article_time = DateTime.parse(article.at_css('header time')['datetime'])
          init_check_point(article_time)
          #Log and remove
          $logger.info "Found article with timestamp #{article_time.to_s}"
          if article_link['href'] && article_time > last_article_time
            article_list << article_link['href']
          else
            cycle_break = !cycle_break
            break
          end
        end

        break if cycle_break
        break unless next_page_link['href']
        url = next_page_link['href']
      end

      $logger.info "Fetching list #{article_list}"
      HorrorParser::Service.persist_pages(fetch_pages_from_urls(article_list))

      update_last_article_time(check_point)
      $logger.info "Crawling finished"
    end

    def fetch_pages_from_urls(urls)
      urls.map { |url| grab_page(url) }
    end

    def grab_page(url)
      { url: url, body: open(url) }
    end
  end
end
