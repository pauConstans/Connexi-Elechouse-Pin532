require 'serialport'
class PN532Reader
  def initialize(port = '/dev/serial0', baud_rate = 115200)
    @serial = SerialPort.new(port, baud_rate, 8, 1, SerialPort::NONE)
    @serial.read_timeout = 1000
  end
  def poll_for_card
    command = [0x00, 0x00, 0xFF, 0x04, 0xFC, 0xD4, 0x4A, 0x01, 0x00, 0xE1].pack('C*')
    @serial.write(command)
    response = @serial.read(24)
    return nil unless response && response.length >= 24
    uid = response[14, 7].unpack('H*').first.upcase
    uid
  end
end
sleep 1
reader = PN532Reader.new

loop do
  uid = reader.poll_for_card
  if uid
    puts "UID de la tarjeta: #{uid}"
    break # Sortir del bucle quan es detecti la targeta
  else
    puts "Esperant targeta..."
  end
  sleep 1 # Espera 1 segon abans de tornar a intentar
end
