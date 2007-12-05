#!/usr/bin/env ruby
#
#  EveryDNS and FreeDNS updater
#
#  Created by Ricardo Martins <ricardo at scarybox dot net>
#  Copyright (c) 2007. Licensed under the MIT/X11 license.

%w[open-uri net/http uri base64].each {|x| require x}

# Which service do you want to update?
everydns = false
freedns = true

# EveryDNS login details
username = 'user'
password = 'password'
domain = 'domain.org'
target = 'dyn.everydns.net'
version = '0.1'
pass = Base64.encode64("#{username}:#{password}")
url = "/index.php?ver=#{version}&ip=#{ip}&domain=#{domain}"

# FreeDNS url update link
fdns = 'http://freedns.afraid.org/dynamic/update.php?supermegaspecialsecretlinkzor'

ip = open('http://www-i4.informatik.rwth-aachen.de/~lexi/whatsmyip.php').read.strip
old_ip = begin; File.open(ENV['HOME'] + '/.myip').read.strip; rescue; ""; end

if ip != old_ip
  # Update EveryDNS
  if everydns
    h = Net::HTTP.new(target, '80')
    h.get(url, {'Authorization' => "Basic #{pass}"})
  end

  # Update FreeDNS
  open(fdns).read.strip if freedns

  # Update recorded ip
  File.open(ENV['HOME'] + '/.myip', 'w+') {|f| f << ip}
end
