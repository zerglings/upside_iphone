#!/usr/bin/env ruby
#
#  ZNFileFprintTest.rb
#  ZergSupport
#
#  Created by Victor Costan on 4/27/09.
#  Copyright Zergling.Net. Licensed under the MIT license.
#

# Prduces golden values for file fingerprinting test.

require 'digest'
require 'openssl'

key = [0xE8, 0xE9, 0xEA, 0xEB, 0xED, 0xEE, 0xEF, 0xF0, 0xF2,
       0xF3, 0xF4, 0xF5, 0xF7, 0xF8, 0xF9, 0xFA].pack('C*')
iv = [0xeb, 0x16, 0xba, 0xbb, 0x43, 0x13, 0xa8, 0xd1, 0x60,
      0x97, 0xc4, 0x70, 0x1c, 0x20, 0xb5, 0x68].pack('C*')

plain = File.read 'ZNFileFprintTest.data'
plain += "\0" * (16 - plain.length % 16) if plain.length % 16 != 0

cipher = OpenSSL::Cipher::Cipher.new 'aes-128-cbc'
cipher.encrypt
cipher.key = key
cipher.iv = iv
encrypted = cipher.update plain

print "Fprint: #{Digest::MD5.hexdigest encrypted}\n"
