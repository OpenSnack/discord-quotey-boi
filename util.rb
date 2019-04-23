def auth_user(boi, user, req_event)
    user_roles = user.on(req_event.server).roles.map {|role| role.name}
    (user_roles & boi.config['text_mod_roles']).any? && req_event.message.attachments.empty? ||
        (user_roles & boi.config['embed_mod_roles']).any? && req_event.message.attachments.any?
end

def extract_quote_parts(str)
    command, quote, *name = str.split(/\s(?=(?:[^"]|"[^"]*")*$)/)
    name = name.join(' ').sub(/^-/,'').strip
    quote = quote [1...-1]
    {command: command, name: name, quote: quote}
end

def full_quote(event)
    parts = extract_quote_parts(event.message.content)
    "\"#{parts[:quote]}\" - #{parts[:name]}"
end

def generate_id(len)
    possible_chars = [*?0..?9].concat([*?a..?z])
    len.times.map { possible_chars.sample }.join
end

def replace_users(str, mentions)
    str.scan(/<@\!?([0-9]+)>/).flat_map{|x|x}.each do |id|
        mention = mentions.find {|m| m.id.to_s == id}
        str.gsub!(/<@\!?#{Regexp.quote(mention.id.to_s)}>/, mention.distinct)
    end
    str
end
