require 'discordrb'
require_relative '../util'

module GetQuote
    def GetQuote.get(boi, event)
        parts = event.message.content.split

        event.respond(boi.all_quotes[event.server.id].sample.content)
    end
end
