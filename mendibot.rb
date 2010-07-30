require 'rubygems'
require 'isaac'
require 'bot_config'
require 'rest-client'
require 'json'
require 'date'

on :connect do
  join "#rmu-general #{RMU_SEEKRIT}"
end

on :channel, /^!site$/ do
  msg channel, "http://university.rubymendicant.com"
end

on :channel, /^!topic (.*)/ do
  $topic = match[0]
  msg channel, "The topic is now #$topic"
end

on :channel, /^!topic$/ do
  msg channel, "The topic is currently #$topic"
end

on :channel do
  message = { 
    :channel     => channel, 
    :handle      => user, 
    :body        => message, 
    :recorded_at => DateTime.now}.to_json
  }
  
  RestClient.post("http://rmu.heroku.com/chat/messages/", 
    :message => message )
  
  puts message
end

on :private, /^site$/ do
  msg nick, "http://university.rubymendicant.com"
end