require 'rubygems'
require 'isaac'
require "#{File.dirname(__FILE__)}/bot_config"
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
  msg = { 
    :channel     => channel, 
    :handle      => nick, 
    :body        => message, 
    :recorded_at => DateTime.now
  }.to_json
  
  service["/chat/messages.json"].post(:message => msg)
end

on :private, /^site$/ do
  msg nick, "http://university.rubymendicant.com"
end
