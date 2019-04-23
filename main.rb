require 'discordrb'
require 'json'
Dir["./events/*.rb"].each {|file| require file }

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

boi.command(:add) {|event| AddQuote.add(boi, event)}
boi.pm(start_with: "#{config['prefix']}approve") {|event| ApproveQuote.approve(boi, event)}
boi.pm(start_with: "#{config['prefix']}reject") {|event| RejectQuote.reject(boi, event)}
boi.pm(content: "#{config['prefix']}queue") {|event| QuoteQueue.respond(boi, event)}

boi.run
