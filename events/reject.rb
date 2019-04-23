require 'discordrb'
require_relative '../util'

module RejectQuote
    def RejectQuote.reject(boi, event)
        quote_id = event.message.content.split[1]
        if (boi.requests.key? quote_id)
            req = boi.requests[quote_id]
            if auth_user(boi, event.user, req[:event])
                boi.requests.delete(quote_id)
                event.respond("\u274C Quote **#{quote_id}** rejected")
            else
                event.respond("Quote **#{quote_id}** doesn't exist")
            end
        else
            event.respond("Quote **#{quote_id}** doesn't exist")
        end
    end
end
