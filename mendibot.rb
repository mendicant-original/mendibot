require 'rubygems'
require 'isaac'
require "#{File.dirname(__FILE__)}/bot_config"
require 'rest-client'
require 'json'
require 'date'
require 'time'

$topics = {}

on :channel, /^!site$/ do
  msg channel, "http://university.rubymendicant.com"
end

on :channel, /^!start_discussion (.*)/ do
  if $topics[channel]
    body = "Discussion has already been started. Please end current one before starting another."
  else
    $topics[channel] = match[0]
    body = "The topic under discussion is now: #{$topics[channel]}"
  end
  msg channel, body
end

on :channel, /^!topic$/ do
  topic = $topics[channel]
  if topic
    msg channel, "The topic under discussion is currently #{$topics[channel]}"
  else
    msg channel, "There is no topic under discussion at the moment"
  end
end

on :channel, /^!topic_site$/ do
  topic = $topics[channel]
  unless topic
    msg channel, "There is no topic under discussion at the moment"
  else
    begin
      resp = service["/chat/discussion/url.json"].get :params => {
        :channel => channel,
        :topic => topic
      }
      body = resp.body
    rescue RestClient::ResourceNotFound => e
      body = "Error: #{e.response.body}"
    rescue RestClient::InternalServerError => e
      body = "Internal Server Error returned from Rails app"
    end

    msg channel, body
  end
end

on :channel, /^!end_discussion$/ do
  old_topic = $topics[channel]
  unless old_topic
    msg channel, "There is no topic under discussion at the moment"
  else
    $topics[channel] = nil
    msg channel, "The discussion about #{old_topic} has now ended"
  end
end

on :channel, /^!time (.*)/ do
  a = match[0].split(" ").to_a

  time = Time.parse(a[0])
  from = a[1]
  to   = a[3]
  
  response = ""
  begin
    from = time + Time.zone_offset(from)
    to   = time + Time.zone_offset(to)
    
    puts response << "#{from.strftime("%a %b %d %H:%M")} -> #{to.strftime("%a %b %d %H:%M")}"
  rescue Exception => e
    puts e.message
  end
  
  response = "Invalid time zone or format." if response.empty?

  msg channel, response
end

on :channel do
  msg = { 
    :channel     => channel, 
    :handle      => nick, 
    :body        => message.encode("UTF-8", :invalid => :replace, :undef => :replace), 
    :recorded_at => DateTime.now,
    :topic       => $topics[channel]
  }.to_json
  
  service["/chat/messages.json"].post(:message => msg)
end
