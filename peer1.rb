require 'socket'
t1 = Thread.new {
peers = File.foreach('peers') 
for peer in peers
s = TCPSocket.open(peer, 2001)
while line = s.gets
    puts "received : #{line.chop}"
end
s.close
end
}

t2 = Thread.new {
server = TCPServer.open(2001)
file = File.new('a')
fileContent = file.read
loop do
    Thread.fork(server.accept) do |client|
        client.puts("Hello, I'm Ruby TCP server", "I'm disconnecting, bye :*")
        client.print fileContent
        client.close
    end
end
}
t1.join
t2.join
#loop do
#for peer in peers
#port = 6000
#@sock = TCPServer.open(peer, 2000)
#@con = @sock.accept
#msg = @con.read
#destFile = File.new('file-received.txt', 'w')
#destFile.print msg
#destFile.close
#end
#@sock = TCPServer.open(@peer, 2000)
#@con = @sock.accept
#msg = @con.read
#destFile = File.new('file-received.txt', 'w')
#destFile.print msg
#destFile.close
#end
