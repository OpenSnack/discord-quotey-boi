require 'discordrb'
require_relative '../util'

module ApproveQuote
    def ApproveQuote.approve(boi, event)
        quote_id = event.message.content.split[1]
        if (boi.requests.key? quote_id)
            req = boi.requests[quote_id]
            if auth_user(boi, event.user, req[:event])
                ApproveQuote.post_quote(req[:event], boi.config['post_channel'])
                boi.requests.delete(quote_id)
                event.respond("\u2705 Request **#{quote_id}** approved")
            end
        else
            event.respond("Request **#{quote_id}** doesn't exist")
        end
    end

    def ApproveQuote.post_quote(event, channel_name)
        channel = event.server.channels.find {|channel| channel.name == channel_name}
        channel.send_message(full_quote(event))
    end
end
