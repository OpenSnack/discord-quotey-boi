require 'discordrb'
require 'json'
require_relative './commandboi'
Dir["./events/*.rb"].each {|file| require file }

config = JSON.parse(File.open('config.json').read)
boi = CommandBoi.new config: config, token: ENV['QUOTEYBOI_TOKEN'], application_id: 569282515978682398, prefix: config['prefix']

boi.command(:add) {|event| AddQuote.add(boi, event)}
boi.command(:quote) {|event| GetQuote.get(boi, event)}
boi.pm(start_with: "#{config['prefix']}approve") {|event| ApproveQuote.approve(boi, event)}
boi.pm(start_with: "#{config['prefix']}reject") {|event| RejectQuote.reject(boi, event)}
boi.pm(content: "#{config['prefix']}queue") {|event| QuoteQueue.respond(boi, event)}

boi.run
