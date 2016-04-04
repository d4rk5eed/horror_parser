require 'open-uri'
require 'nokogiri'
require 'reverse_markdown'

url = 'http://horrorbook.ru/category/news'

article_list = []

loop do
  html = open(url)
  doc = Nokogiri::HTML(html)
  next_page_link = doc.at_css('.pagination-next')

  doc.css('article').each do |article|
    # print ">>>>>>>>>>>>>>>>>>>\n"
    # print article.inner_html.strip
    article_link = article.at_css('header h1 a')
    if article_link['href']
      article_list << article_link['href']
    end
  end

  break unless next_page_link['href']
  url = next_page_link['href']
end

if article_list.any?
  article_list.each do |article_url|
    html = open(article_url)
    doc = Nokogiri::HTML(html)

    title = doc.at_css('header h1').inner_html.strip

    print "HEADER: #{title}\n"

    article_body = doc.at_css('article .mso-page-content').inner_html
    print "BODY------------->\n"
    print ReverseMarkdown.convert(article_body).gsub(/<\/?[^>]*>/, "")
    print "\n"
    break
  end
end
