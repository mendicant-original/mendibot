require 'cinch'
require 'hunspell-ffi'

module Mendibot

  module Plugins

    class Spell
      include Cinch::Plugin

      match /spell (\S+)/, method: :suggest

      def initialize(*args)
        @hunspell = Hunspell.new("#{Mendibot::Config::HUNSPELL_DICT}.aff",
                                 "#{Mendibot::Config::HUNSPELL_DICT}.dic")
        super
      end

      def suggest(m, word)
        suggestions = @hunspell.suggest(word)
        if suggestions.first != word
          suggestions = suggestions.join(', ')
          m.reply "#{m.user.nick}: #{word} -> #{suggestions}"
        else
          suggestions = suggestions[1..-1].join(', ')
          m.reply "#{m.user.nick}:Looks like you spelled it right!  
                    Some other ideas for you just in case: #{suggestions}"
        end
      rescue Exception => e
        m.reply "Failed to spell #{word}"
        bot.logger.debug e.message
      end

    end

  end

end