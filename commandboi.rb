require 'discordrb'

class CommandBoi < Discordrb::Commands::CommandBot
    attr_reader :config, :requests, :all_quotes

    def initialize(attributes = {})
        super(attributes)

        @config = attributes[:config]
        @requests = {}
        @all_quotes = {}
        @all_quotes_by_user = {}

        self.ready { load_channels }
    end

    def load_channels
        self.servers.to_a.each do |id, server|
            channel = server.channels.find {|channel| channel.name == @config['post_channel']}
            pages = []
            page = channel.history(100)
            pages.concat(page)
            while page.size == 100
                page = channel.history(100, page[-1].id)
                pages.concat(page)
            end
            @all_quotes[server.id] = pages
        end
    end
end
