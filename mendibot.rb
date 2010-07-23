require 'rubygems'
require 'isaac'
require 'bot_config'

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
  msg channel, [nick, message, user, host, Time.now.to_s].inspect
end

on :private, /^site$/ do
  msg nick, "http://university.rubymendicant.com"
end
