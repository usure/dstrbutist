require 'socket'
require 'openssl'
require 'digest/sha2'

#payload = "Hi"
#sha256 = Digest::SHA2.new(256)
#aes = OpenSSL::Cipher.new("AES-256-CFB")
#iv = rand.to_s
#key = sha256.digest("Bond, James Bond")
#aes.encrypt
#aes.key = key
#aes.iv = iv
#encrypted_data = aes.update(payload) + aes.final


peers = File.foreach('peers')
for peer in peers

remote_host = ARGV.first

# Punches hole in firewall
punch = UDPSocket.new
punch.bind('', 6311)
punch.send('', 0, remote_host, 6311)
punch.close

# Bind for receiving
udp_in = UDPSocket.new
udp_in.bind('0.0.0.0', 6311)
puts "Binding to local port 6311"

loop do
  # Receive data or time out after 5 seconds
  if IO.select([udp_in], nil, nil, rand(4))
        data = udp_in.recvfrom(1024)
        remote_port = data[1][1]
        remote_addr = data[1][3]
        puts "#{data[0]}"
  else
#        puts "Sending a little something.."
        udp_in.send("*thump*", 0, remote_host, 6311)
#        udp_in.send(Time.now.to_s, 0, remote_host, 6311)
  end
end
end
