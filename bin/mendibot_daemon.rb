#!/usr/bin/env ruby

require 'daemons'
require 'fileutils'

file = File.expand_path("../mendibot.rb", __FILE__)

FileUtils.mkdir_p File.expand_path("../../tmp/pids", __FILE__)

Daemons.run(file, :dir => "../tmp/pids")
