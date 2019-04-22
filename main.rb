require 'discordrb'
require 'json'
require_relative 'events/add'
require_relative 'events/queue'

class Discordrb::Commands::CommandBot
    def config=(json)
        @config = json
    end

    def config
        @config
    end

    def requests=(hash)
        @requests = hash
    end

    def requests
        @requests
    end
end

requests = {}

config = JSON.parse(File.open('config.json').read)
boi = Discordrb::Commands::CommandBot.new token: ENV['QUOTEYBOI_TOKEN'], application_id: 569282515978682398, prefix: config['prefix']
boi.config = config
boi.requests = requests

boi.pm(content: "#{config['prefix']}queue") {|event| QuoteQueue.respond(boi, event)}

boi.command(:add) {|event| requests[AddQuote.add(boi, event)] = {event: event, timestamp: Time.now}}

boi.run
