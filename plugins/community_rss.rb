require 'cinch'
require 'open-uri'
require 'rss'

module Mendibot

  module Plugins

    class CommunityRSS
      include Cinch::Plugin

      timer Mendibot::Config::RSS_INTERVAL, method: :pull

      def pull
        open(Mendibot::Config::RSS_URL) do |rss|

          feed = RSS::Parser.parse(rss)
          min_time = Time.now - Mendibot::Config::RSS_INTERVAL

          feed.items.each do |item|
            if item.pubDate >= min_time
              Mendibot::Config::CHANNELS.each do |chan|
                Channel(chan).send "Community post by #{item.author}: #{item.link}"
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