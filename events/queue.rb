require 'discordrb'
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
                embed.description = full_quote(req[1][:event])
                if attach.any? && attach[0].image?
                    embed.image = Discordrb::Webhooks::EmbedImage.new(url: attach[0].url)
                end
            end
        end
    end

    def QuoteQueue.requests_for_mod(boi, user)
        mod_reqs = []
        boi.requests.to_a.select do |req|
            if auth_user(boi, user, req[1][:event])
                mod_reqs.push(req)
            end
        end
        mod_reqs
    end
end
