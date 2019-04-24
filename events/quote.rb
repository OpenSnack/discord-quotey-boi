require_relative '../util'

module GetQuote
    def GetQuote.get(boi, event)
        parts = event.message.content.split

        if (parts.size > 1)
            quotes_by_user = boi.all_quotes[event.server.id].select do |quote|
                if !quote.content || quote.content == ''
                    false
                else
                    quote_parts = extract_quote_parts(quote.content)
                    
                    req_id = parts[1][/<@\!?([0-9]+)>/]
                    quote_id = quote_parts[:name][/<@\!?([0-9]+)>/]
                    req_id && req_id == quote_id
                end
            end
            event.respond(quotes_by_user.sample)
        else
            event.respond(boi.all_quotes[event.server.id].sample.content)
        end
    end
end
