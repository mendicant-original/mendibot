require 'cinch'
require 'date'

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
        msg = {
          :channel => m.channel,
          :topic   => topic,
          :action  => 'start'
        }.to_json

        m.reply Mendibot::Config::SERVICE["/chat/meetings.json"].post(:message => msg)
      rescue Exception => e
        m.reply "Failed to start discussion"
        bot.logger.debug e.message
      end

      def end_discussion(m)
        msg = {
          :channel => m.channel,
          :action  => 'end'
        }.to_json

        m.reply Mendibot::Config::SERVICE["/chat/meetings.json"].post(:message => msg)
      rescue Exception => e
        m.reply "Failed to end discussion"
        bot.logger.debug e.message
      end

      def topic(m)
        msg = {
          :channel => m.channel,
          :action  => 'current'
        }.to_json

        m.reply topic = Mendibot::Config::SERVICE["/chat/meetings.json"].post(:message => msg)
      rescue Exception => e
        m.reply "Failed to retreive topic"
        bot.logger.debug e.message
      end

    end

  end

end
