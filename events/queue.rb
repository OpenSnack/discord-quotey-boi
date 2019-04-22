require_relative '../util'

module QuoteQueue
    def QuoteQueue.respond(boi, event)
        event.respond('Pending quote requests:')
        reqs_for_this_mod = QuoteQueue.requests_for_mod(boi, event.user)
        reqs_for_this_mod.sort {|r1, r2| r1[1][:timestamp] - r2[1][:timestamp]}.each do |req|
            attach = req[1][:event].message.attachments
            event.send_embed do |embed|
                embed.title = "#{req[1][:event].server.name} -- #{req[0]}"
                embed.color = '#ffdf00'
                embed.description = QuoteQueue.full_quote(req[1][:event])
                if attach.any? && attach[0].image?
                    embed.image = Discordrb::Webhooks::EmbedImage.new(url: attach[0].url)
                end
            end
        end
    end

    def QuoteQueue.requests_for_mod(boi, user)
        mod_reqs = []
        boi.requests.to_a.select do |req|
            user_roles = user.on(req[1][:event].server).roles.map {|role| role.name}
            if (user_roles & boi.config['text_mod_roles']).any? && req[1][:event].message.attachments.empty?
                mod_reqs.push(req)
            elsif (user_roles & boi.config['embed_mod_roles']).any? && req[1][:event].message.attachments.any?
                mod_reqs.push(req)
            end
        end
        mod_reqs
    end

    def QuoteQueue.full_quote(event)
        parts = extract_quote_parts(event.message.content)
        "\"#{parts[:quote]}\" - #{parts[:name]}"
    end
end
