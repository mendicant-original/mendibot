require_relative '../plugins/default'
require_relative '../plugins/timezone'
require_relative '../plugins/ip2geo'

module Mendibot

  class DummyService
    def post(options = {})
      warn options[:message]
    end
  end

  module Config

    SERVER   = "irc.freenode.net"
    PORT     = 6667
    NICK     = "mendibot"
    PASSWORD = nil
    CHANNELS = ["#rmu"]
    PLUGINS  = [ Mendibot::Plugins::Default,
                 Mendibot::Plugins::Timezone,
                 Mendibot::Plugins::IP2Geo,
               ]

    SERVICE = Hash.new{|h,k| h[k] = DummyService.new}

    IP2GEO_API_KEY = nil

  end

end
