require 'cinch'
require 'open-uri'
require 'rss'

module Mendibot
  module Plugins
    class RSSRelay
      include Cinch::Plugin

      Mendibot::Config::RSS_SETTINGS[:feeds].each do |feed|
        method_name = "#{feed[:name]}_pull"

        define_method method_name do
          data = RSS::Parser.parse(open(feed[:url]))
          process_items(feed, data.items)
        end

        timer feed[:interval], method: method_name
      end

      def process_items(feed, items)
        items.each do |item|
          next unless post_time = item.updated.content

          if post_time >= Time.now - feed[:interval]
            author = item.author.name.content || 'a mysterious stranger'

            feed[:channels].each do |chan|
              Channel(chan).send <<-MESSAGE
via #{feed[:name]} comes the epic saga "#{item.title.content}", by #{author}! #{item.link.href}
MESSAGE
            end
          end
        end

      rescue Exception => e
        bot.logger.debug e.message
      end

    end
  end
end
