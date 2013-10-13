rubenstein
==========

A modular IRC bot written in Ruby.

### Usage

Edit the `config.yml` and fire the `bin/rubenstein` executable.

All fields in `config.yml` are in the `IRC#settings` hash.

### Plugin

To add your own plugin add a file into the `src/plugins` directory with following structure:

    module Ping

        def trigger
            /#{@irc.nick}\W? ping/i
        end

        def response(str)
            args = IRC.filter(str)
            @irc.say "#{args[:nick]}: pong"
        end

        def help
            @irc.say "ping - pong"
        end

    end

[More info of IRC commands](http://en.wikipedia.org/wiki/List_of_Internet_Relay_Chat_commands).
