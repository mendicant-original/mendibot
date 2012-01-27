module Mendibot

  class DummyService
    def post(options = {})
      warn options[:message]
    end
  end

  module Config
    extend self

    SERVER   = "irc.freenode.net"
    PORT     = 6667
    NICK     = "mendibot"
    PASSWORD = nil
    CHANNELS = ["#rmu"]

    SERVICE = Hash.new{|h,k| h[k] = DummyService.new}

    IP2GEO_API_KEY = nil
    NEW_ROOMS = nil
    HUNSPELL_DICT = '/usr/share/hunspell/en_US'

    NEW_ROOMS = {}

    OPERATORS = %w{ USERNAME_1 USERNAME_2 USERNAME_3 }

    # Set to print the log URL when ending discussions
    # Example: "http://mylogz.com/messages?"
    #
    def log_url
      nil
    end

  end

end
