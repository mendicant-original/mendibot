#!/usr/bin/env ruby

begin
  require_relative '../config/environment'
rescue LoadError
  require_relative '../config/default_environment'
end

require_relative '../lib/mendibot'

Mendibot.run
