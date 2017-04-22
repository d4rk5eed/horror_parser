class HorrorParser
  class Observer
    def initialize(crawler)
      crawler.add_observer(self)
    end
  end
end

class HorrorParser
  class SettingObserver < Observer
    def update(list:, check_point:)
      Setting.last.update_attribute(:last_article_time, check_point)
      $logger.info "Checkpoint updated to: #{check_point}"
    end
  end
end

class HorrorParser
  class BotObserver < Observer
    def update(list:, check_point:)
      uri = URI($config[:bot_uri])
      $logger.info "Request for URI #{uri.inspect}"
      req = Net::HTTP::Post.new(uri)
      req.body = post_body(list)
      req.content_type = 'application/json'
      $logger.info "Request: #{req.inspect}"
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        $logger.info 'OK'
      else
        $logger.info res.value
      end

      #$logger.info "Resp: #{response.inspect}"
    end

    def post_body(list)
      #tag_list = list.each_with_object([]) { |x, acc| acc << x[:tags] }.flatten.uniq

      User.active.each_with_object({}) do |u, acc|
        if u.tags.empty?
          acc[u.chat_id] = markdown_hash(list)
        else
          pages_list = filter_by(u.tags, list)
          acc[u.chat_id] = markdown_hash(pages_list) if pages_list.any?
          #(u.tags & tag_list).present?
        end
      end.to_json
    end

    def markdown_hash(list)
      list.each_with_object('') do |obj, memo|
        memo << "[#{obj[:title]}](#{obj[:url]})\n_#{obj[:tags].join(', ')}_\n\n"
      end
    end

    def filter_by(tags, list)
      list.select { |page| (page[:tags] & tags).present? }
    end
  end
end
