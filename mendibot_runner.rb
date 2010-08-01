require 'rubygems'
require 'daemons'

Daemons.run('mendibot.rb', :monitor => true)


