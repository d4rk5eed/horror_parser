require 'spec_helper'

describe HorrorParser::Observer do
  let!(:setting) {
    Setting.create(last_article_time: DateTime.parse('2000-01-01'))
  }

  let(:crawler) {
    HorrorParser::Crawler.new
  }

  context HorrorParser::SettingObserver do
    before {
      HorrorParser::SettingObserver.new(crawler)
    }

    it "doesn't update setting empty list" do
      crawler.reviews_list = []
      crawler.notify
      expect(Setting.last.last_article_time).to eq(DateTime.parse('2000-01-01'))
    end

    it "updates setting on populated list" do
      crawler.reviews_list = [{ title: 'title', url: 'url', tags: ['tag'] }]
      crawler.init_check_point(DateTime.parse('2001-01-01'))
      crawler.notify
      expect(Setting.last.last_article_time).not_to eq(DateTime.parse('2000-01-01'))
    end
  end

  context HorrorParser::SettingObserver do
    before {
      HorrorParser::BotObserver.new(crawler)
    }

    it "doesn't send post on empty list" do
      crawler.reviews_list = []
      crawler.notify
      expect(WebMock).not_to have_requested(:post, $config[:bot_uri])
    end

    it "sends post on populated list" do
      User.create(chat_id: "1", active: true)
      User.create(chat_id: "2", active: true)
      crawler.reviews_list = [{tags: ["tag1", "tag2"], url: "url"}]
      crawler.notify
      expect(WebMock).to have_requested(:post, $config[:bot_uri])
    end

  end

  context '.markdown_hash' do
    let(:observer) {
      HorrorParser::BotObserver.new(crawler)
    }

    it 'post_body' do
      list = [{title: "title1", url: "http://mail.google.com", tags: ['a', 'b']}, {title: "title2", url: "http://www.google.com", tags: ['c', 'd']}]

      User.create(chat_id: "1", active: true, tags: ['a','c'])
      User.create(chat_id: "2", active: true, tags: ['e', 'f'])
      User.create(chat_id: "3", active: true, tags: [])

      expect(observer.post_body(list)).to eq("{\"1\":\"[title1](http://mail.google.com)\\n_a, b_\\n\\n[title2](http://www.google.com)\\n_c, d_\\n\\n\",\"3\":\"[title1](http://mail.google.com)\\n_a, b_\\n\\n[title2](http://www.google.com)\\n_c, d_\\n\\n\"}")
    end
  end

  context '.markdown_hash' do
    let(:observer) {
      HorrorParser::BotObserver.new(crawler)
    }

    it 'markdowns text' do
      list = [{title: "title1", url: "http://mail.google.com", tags: ['a', 'b']}, {title: "title2", url: "http://www.google.com", tags: ['c', 'd']}]
      text = "[title1](http://mail.google.com)\n_a, b_\n\n[title2](http://www.google.com)\n_c, d_\n\n"
      expect(observer.markdown_hash(list)).to eq(text)
    end
  end
end
