Mendibot
========

IRC bot which, among other things, posts chat transcripts to university-web

Prerequisites
============
- Ruby 1.9.2

Running your own Mendibot
=========================
0. Clone the repository and run `bundle install`
1. Create a channel where you can test and not bother anyone
2. Copy `config/environment.rb.example` to `config/environment.rb`
3. Set CHANNELS in `config/environment.rb` to the test channel you created
4. From your local command line, run `ruby bin/mendibot.rb`
