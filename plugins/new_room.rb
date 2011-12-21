require 'cinch'

module Mendibot

  module Plugins

    class NewRoom
      include Cinch::Plugin

      attr_reader :channels, :notified_users

      listen_to :channel

      def initialize(*args)
        @channels       = Mendibot::Config::NEW_ROOMS || {}
        @notified_users = Hash.new {|hash, key| hash[key] = Array.new }

        super
      end

      def listen(m)
        channel = m.channel.name

        puts channel
        puts notified_users[channel]

        return if notified_users[channel].include?(m.user.nick)

        if new_channel = channels[channel]
          m.reply ["Hi #{m.user.nick}, did you know we moved? ",
                   "Please join us in #{new_channel} (/join #{new_channel})"].join
          notified_users[channel] << m.user.nick
          puts notified_users[channel]
        end
      end

    end

  end

end
