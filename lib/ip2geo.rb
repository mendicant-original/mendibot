require 'rest_client'
require 'rexml/document'

module IP2GEO
  def self.retreive(ip)
    xml = RestClient.get("api.ipinfodb.com/v2/ip_query.php?key=e91ab06882367de54fd7e394c04f3292d3d50761c78e8691c03909ddad2e8391&ip=#{ip}&timezone=false")
    doc = REXML::Document.new(xml)
    lat = doc.elements.to_a('/Response/Latitude').first.text
    lng = doc.elements.to_a('/Response/Longitude').first.text

    info = doc.elements.to_a('/Response/*').map{|e| "#{e.name}: #{e.text}" }
    info << "map: http://maps.google.com/maps?q=#{lat},+#{lng}+(#{ip})&iwloc=A&hl=en"
    info
  end
end
