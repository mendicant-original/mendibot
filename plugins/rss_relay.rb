require 'cinch'
require 'open-uri'
require 'rss'

module Mendibot
  module Plugins
    class RSSRelay
      include Cinch::Plugin

      timer Mendibot::Config::RSS_SETTINGS[:interval], method: :pull

      def pull
        Mendibot::Config::RSS_SETTINGS[:feeds].each do |feed|
          open(feed[:url]) do |rss|
            feed     = ::RSS::Parser.parse(rss)
            min_time = Time.now - Mendibot::Config::RSS_SETTINGS[:interval]

            feed.items.each do |item|
              if item.pubDate >= min_time
                feed[:channels].each do |chan|
                  Channel(chan).send <<-MESSAGE
via #{feed[:name]} comes the epic saga "#{item.link}", by #{item.author}!
MESSAGE
                end
              end
            end
          end
        end
      rescue Exception => e
        bot.logger.debug e.message
      end
    end
  end
end
