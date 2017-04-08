require_relative 'environment'

crawler = HorrorParser::Crawler.new
HorrorParser::SettingObserver.new(crawler)
HorrorParser::BotObserver.new(crawler)
crawler.persist_new_pages
