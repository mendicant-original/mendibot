require 'time'

module Timely
  def self.syntax_error
    "Unknown syntax: <time> <from timezone> to <to timezone>"
  end

  def self.parse(input)
    msg = input.split(" ")

    return syntax_error if msg.size < 4

    time = Time.parse(msg[0])
    from = msg[1]
    to   = msg[3]
    
    response = ""
    begin
      from = time + Time.zone_offset(from)
      to   = time + Time.zone_offset(to)
      
      response << "#{from.strftime("%a %b %d %H:%M")} -> #{to.strftime("%a %b %d %H:%M")}"
    rescue Exception => e
      puts e.message
    end
    
    response.empty? ? "Invalid time zone or format." : response
  end
end
