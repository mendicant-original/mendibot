require 'cinch'
require 'time'

module Mendibot

  module Plugins

    class Timezone
      include Cinch::Plugin

      HELP_REGEX    = "help"
      CONVERT_REGEX = "(.*) (.*) to (.*)"

      match /time #{HELP_REGEX}/i,    method: :help
      match /time #{CONVERT_REGEX}/i, method: :convert
      match /time (.*)/,              method: :catch_invalid_syntax

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

      def catch_invalid_syntax(m, args)
        unless args =~ /(#{HELP_REGEX}|(#{CONVERT_REGEX}))/i
          m.reply "#{m.user.nick}: Invalid command syntax."
          help(m)
        end
      end

    end

  end

end
