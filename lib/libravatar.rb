# enable compatibility between Vishnu and Libravatar and allow require 'libravatar' to work

require_relative 'vishnu'

class Libravatar < Vishnu; end
