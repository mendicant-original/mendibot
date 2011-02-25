require 'rubygems'
require 'bundler/setup'
require 'isaac'
require 'rest-client'
require 'json'

#require "#{File.dirname(__FILE__)}/bot_config"
require_relative 'bot_config'

["ip2geo","timely"].each do |plugs|
  require_relative "lib/#{plugs}"
end

$topics = {}

on :channel, /^!site$/ do
  msg channel, "http://university.rubymendicant.com"
end

on :channel, /^!start_discussion (.*)/ do
  $topics[channel] = match[0]
  msg channel, "The topic under discussion is now: #{$topics[channel]}"
end

on :channel, /^!topic$/ do
  topic = $topics[channel]
  if topic
    msg channel, "The topic under discussion is currently #{$topics[channel]}"
  else
    msg channel, "There is no topic under discussion at the moment"
  end
end

on :channel, /^!end_discussion$/ do
  old_topic = $topics[channel]
  $topics[channel] = nil
  msg channel, "The discussion about #{old_topic} has now ended"
end

# Shifts timezones
#
# Example:
#   !time 17h UTC to EST
on :channel, /^!time (.*)/ do
  msg channel, Timely.parse(match[0])
end

on :channel, /^!ip2geo help$/ do
  msg channel, "#{nick}: <!ip2geo (ip address)> gives a list of geographic attributes associated with the ip address"
end

on :channel, /^!ip2geo (\d{1,3}\.\d{1,3}\.\d{1,3}.\d{1,3})$/ do
  msg channel, "#{nick}: #{IP2GEO.retreive(match[0]).join(', ')}"
end

# Sends message to logging web service
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
