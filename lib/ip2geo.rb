require 'rest_client'
require 'rexml/document'

module IP2GEO
  def self.retreive(ip)
    xml = RestClient.get("ipinfodb.com/ip_query.php?ip=#{ip}&timezone=false")
    doc = REXML::Document.new(xml)
    lat = doc.elements.to_a('/Response/Latitude').first.text
    lng = doc.elements.to_a('/Response/Longitude').first.text

    info = doc.elements.to_a('/Response/*').map{|e| "#{e.name}: #{e.text}" }
    info << "map: http://maps.google.com/maps?q=#{lat},+#{lng}+(#{ip})&iwloc=A&hl=en"
    info
  end
end
