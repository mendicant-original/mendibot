#!/usr/bin/env ruby

require 'daemons'
file = File.expand_path("../mendibot.rb", __FILE__)
Daemons.run(file, :monitor => true)
