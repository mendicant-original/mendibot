require 'cinch'
require 'date'
require 'uri'

module Mendibot

  module Plugins

    class Default
      include Cinch::Plugin

      match /site/,                   method: :site
      match /start_discussion (.+)$/, method: :start_discussion
      match /end_discussion/,         method: :end_discussion
      match /topic/,                  method: :topic

      def site(m)
        m.reply "#{m.user.nick}: http://university.rubymendicant.com"
      rescue Exception => e
        bot.logger.debug e.message
      end

      def start_discussion(m, topic)
        Mendibot::TOPICS[m.channel] = topic
        m.reply "The topic under discussion is now '#{topic}'"
        reply_with_topic_link(m, topic)
      rescue Exception => e
        m.reply "Failed to start discussion"
        bot.logger.debug e.message
      end

      def end_discussion(m)
        topic = Mendibot::TOPICS[m.channel]
        Mendibot::TOPICS[m.channel] = nil

        if topic
          m.reply "The topic about '#{topic}' has now ended"
          reply_with_topic_link(m, topic)
        else
          m.reply "There is no topic under discussion at the moment"
        end
      rescue Exception => e
        m.reply "Failed to end discussion"
        bot.logger.debug e.message
      end

      def topic(m)
        topic = Mendibot::TOPICS[m.channel]

        if topic
          m.reply "The current topic under discussion is '#{topic}'"
          reply_with_topic_link(m, topic)
        else
          m.reply "There is no topic under discussion at the moment"
        end
      rescue Exception => e
        m.reply "Failed to retreive topic"
        bot.logger.debug e.message
      end

      private

      def reply_with_topic_link(m, topic)
        return unless Mendibot::Config::LOG_URL

        url = Mendibot::Config::LOG_URL
        url << "&channel=#{URI.encode(m.channel.name)}"
        url << "&topic=#{URI.encode(topic)}"
        url << "&full_log=true"

        m.reply "Transcript link: #{url}"
      rescue Exception => e
        m.reply "Failed to generate topic link"
        bot.logger.debug e.message
      end
    end

  end

end
