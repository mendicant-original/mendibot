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
            data     = ::RSS::Parser.parse(rss)
            min_time = Time.now - Mendibot::Config::RSS_SETTINGS[:interval]

            data.items.each do |item|
              next unless item.respond_to?(:pubDate) && !item.pubDate.nil?

              if item.pubDate >= min_time
                feed[:channels].each do |chan|
                  Channel(chan).send <<-MESSAGE
via #{feed[:name]} comes the epic saga "#{item.title}" (#{item.link})!
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
