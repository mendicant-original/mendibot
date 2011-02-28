require 'cinch'
require 'rest_client'
require 'rexml/document'

module Mendibot

  module Plugins

    class IP2Geo
      include Cinch::Plugin

      class << self
        def retreive(ip)
          xml = RestClient.get("api.ipinfodb.com/v2/ip_query.php?key=#{Mendibot::Config::IP2GEO_API_KEY}&ip=#{ip}&timezone=false")
          doc = REXML::Document.new(xml)
          lat = doc.elements.to_a('/Response/Latitude').first.text
          lng = doc.elements.to_a('/Response/Longitude').first.text

          info = doc.elements.to_a('/Response/*').map{|e| "#{e.name}: #{e.text}" }
          info << "map: http://maps.google.com/maps?q=#{lat},+#{lng}+(#{ip})&iwloc=A&hl=en"
          info
        end
      end

      match /ip2geo help/,                                 method: :help
      match /ip2geo (\d{1,3}\.\d{1,3}\.\d{1,3}.\d{1,3})$/, method: :fetch

      def help(m)
        m.reply "#{m.user.nick}: <!ip2geo (ip address)> gives a list of geographic attributes associated with the ip address"
      rescue Exception => e
        bot.logger.debug e.message
      end

      def fetch(m, ip)
        m.reply "#{m.user.nick}: #{IP2Geo.retreive(ip).join(", ")}"
      rescue Exception => e
        m.reply "#{m.user.nick}: invalid ip"
        bot.logger.debug e.message
      end

    end

  end

end
