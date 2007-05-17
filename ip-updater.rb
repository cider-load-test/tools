#!/usr/bin/env ruby
#
#  EveryDNS updater
#
#  Created by Ricardo Martins on 2007-02-06.
#  Copyright (c) 2007. All rights reserved.

require 'open-uri'
require 'net/http'
require 'uri'
require 'base64'

ip = open('http://www-i4.informatik.rwth-aachen.de/~lexi/whatsmyip.php').read.strip
username = 'user'
password = 'password'
domain = 'domain.org'
target = 'dyn.everydns.net'
version = '0.1'
pass = Base64.encode64("#{username}:#{password}")
url = "/index.php?ver=#{version}&ip=#{ip}&domain=#{domain}"

old_ip = begin; File.open('/root/.myip').read.strip; rescue; ""; end

if ip != old_ip
  # Update EveryDNS
  begin
    h = Net::HTTP.new(target, '80')
    h.get(url, {'Authorization' => "Basic #{pass}"})
  rescue # Don't die if this times out
  end

  # Update FreeDNS
  open('http://freedns.afraid.org/dynamic/update.php?zomgsupersecretlinkzor').read.strip

  # Update recorded ip
  File.open('/root/.myip', 'w+') {|f| f << ip}
end
