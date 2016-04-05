require 'open-uri'
require 'nokogiri'
require 'reverse_markdown'
require 'yaml'
require 'libnotify'

url = 'http://horrorbook.ru/category/news'

article_list = []


#def read_config
config = YAML.load_file("config/config.yml")
@targets = config['targets']

@last_article_time =
  if File.exists? 'config/last_timestamp'
    @last_article_time = File.open('config/last_timestamp', 'r') {
      |file| file.read
    }
    DateTime.parse(@last_article_time)
  else
    DateTime.new(0)
  end

print @last_article_time
#exit
#end

loop do
  html = open(url)
  doc = Nokogiri::HTML(html)
  next_page_link = doc.at_css('.pagination-next')

  cycle_break = false
  doc.css('article').each do |article|
    article_link = article.at_css('header h1 a')
    @article_time = DateTime.parse(article.at_css('header time')['datetime'])
    @check_point ||= @article_time

    #Log and remove
    print @article_time
    if article_link['href'] && @article_time > @last_article_time
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

if article_list.any?
  article_list.each do |article_url|
    html = open(article_url)
    doc = Nokogiri::HTML(html)

    filename = article_url[/[^\/]+$/]
    title = doc.at_css('header h1').inner_html.strip
    article_body = doc.at_css('article .mso-page-content').inner_html

    if article_body =~ Regexp.new(@targets.join('|'), :i)
      article_body = ReverseMarkdown.convert(article_body).gsub(/<\/?[^>]*>/, "")
      Libnotify.show(:body => title, :append=> true, :summary => 'Incoming review', :timeout => 60)

      File.open(filename + '.md', 'w') {
        |file| file.write(title + "\n" + article_body)
      }
    end
  end
end

File.open('config/last_timestamp', 'w') {
  |file| file.write(@check_point)
}
