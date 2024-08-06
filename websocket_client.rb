require 'faye/websocket'
require 'eventmachine'
require 'em-websocket'

class ChatClient
    def initialize(url)
        @url = url      
    end

    def start
        EM.run do
            ws = Faye::WebSocket::Client.new(@url)

            ws.on :open do
                puts "PT: Connected to server..."
                listen_client_input_msg(ws)
            end

            ws.on :message do |event|
                puts "PT: Received Msg Client Side: #{event.data}"
            end

            ws.on :close do
                puts "PT: Server got disconnected...."
                EM.stop
            end

            ws.on :error do |event|
                puts "PT: Error occurred: #{event.message}"
            end
        end
    end

    def listen_client_input_msg(ws)
        Thread.new do
            loop do
                puts "Enter your msg..."
                msg = gets.chomp
                ws.send(msg) unless msg.empty?
            end
        end
    end
end

cc = ChatClient.new('ws://0.0.0.0:8080')
cc.start