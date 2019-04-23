require 'discordrb'
require_relative '../util'

module AddQuote
    def AddQuote.add(boi, event)
        quote_id = generate_id(10)
        attach = event.message.attachments

        mod_role_names = boi.config['text_mod_roles']
        if attach.any? && attach[0].image?
            mod_role_names = boi.config['embed_mod_roles']
        end

        mod_roles = event.server.roles.find_all {|role| mod_role_names.include? role.name}
        mod_roles.flat_map {|role| role.members}.uniq.each do |user|
            AddQuote.approve_request_embed(user, event, quote_id)
        end

        boi.requests[quote_id] = {event: event, timestamp: Time.now}
    end

    def AddQuote.approve_request_embed(mod, event, quote_id)
        parts = extract_quote_parts(event.message.content)
        author = AddQuote.get_author(parts[:name], event.message.mentions)
        attach = event.message.attachments

        mod.pm.send_embed do |embed|
            embed.title = "Quote submitted in #{event.server.name}"
            embed.color = '#ffdf00'
            embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: author.avatar_url)
            embed.description = "ID: #{quote_id}"
            if attach.any? && attach[0].image?
                embed.image = Discordrb::Webhooks::EmbedImage.new(url: attach[0].url)
            end

            name_str = "- #{replace_users(parts[:name], event.message.mentions)}"
            quote_str = "\"#{replace_users(parts[:quote], event.message.mentions)}\""
            embed.add_field(name: quote_str, value: name_str)
        end
    end

    def AddQuote.get_author(str, mentions)
        mentions.find{|m| m.id.to_s == str.scan(/<@\!?([0-9]+)>/)[0][0]}
    end
end
