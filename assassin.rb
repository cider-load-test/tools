#!/usr/bin/env ruby
#
#  Signature Assassin 0.1 
#
#  (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
#  Licensed under the MIT/X11 License. See LICENSE file for license details.

MAIL = open(ARGV[0]).read
@mail = Array.new

MAIL.each_line do |line|
  break if line =~ />\s(__|--)^(PGP)/
  @mail << line
end

File.open(ARGV[0], 'w+') {|file| @mail.each {|line| file << line}}
