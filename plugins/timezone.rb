require 'cinch'
require 'time'

module Mendibot

  module Plugins

    class Timezone
      include Cinch::Plugin

      match /time help/,               method: :help
      match /time (.*) (.*) to (.*)/i, method: :convert

      def help(m)
        m.reply "#{m.user.nick}: <!time (time) (from) to (to)> converts the time from one timezone to another"
      end

      def convert(m, time, from, to)
        time = Time.parse("#{time} #{from}").utc
        from = time + Time.zone_offset(from)
        to   = time + Time.zone_offset(to)

        m.reply "#{m.user.nick}: #{format(from)} -> #{format(to)}"
      rescue Exception => e
        m.reply "#{m.user.nick}: invalid timezone or format"
        bot.logger.debug e.message
      end

      def format(t)
        t.strftime("%a %b %d %H:%M")
      end

    end

  end

end
