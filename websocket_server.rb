require 'faye/websocket'
require 'eventmachine'
require 'em-websocket'


class ChatServer
    def initialize(path)
        @log_file_path = path
        @clients = []
        @file = File.open(path, 'a')
    end

    def start
        EM.run do
            EM::WebSocket.run(host: '0.0.0.0', port: '8080') do |ws|
                ws.onopen do
                    puts "Client Connected.... and client is : #{ws}"
                    @clients << ws
                end

                ws.onmessage do |event|
                    puts "PT: Message Received: #{event}"
                    log_insert(event)
                    broadcast(event)
                end

                ws.onclose do
                    puts "PT: Client Disconnected. Client was: #{ws}"
                    @clients.delete(ws)
                end
            end
        end
    end

    def log_insert(event)
        @file << "Message Received: #{event}"
    end

    def broadcast(event)
        @clients.each do |client|
            client.send "Message aaya : #{event}"
        end
    end
end

cp = ChatServer.new('/home/lalitmali/Desktop/rails7/SocketPro/chat_with_socket/logfile.log')
cp.start