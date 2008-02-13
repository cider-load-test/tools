#!/usr/bin/env ruby
#
# Signature Assassin 0.1
#
# Script for ripping out email signatures when replying. Intended to use
# with mutt(-ng). It rips both people's and MLs' signatures, leading to
# much more elegant emails.
#
# == Usage ==
#
# Add something like the following to your muttrc:
# set editor = "ruby $HOME/Code/tools/assassin.rb %s; /usr/bin/vim %s"
#
# (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
# Licensed under the MIT/X11 License. See LICENSE file for license details.

MAIL = open(ARGV[0]).read
@mail = Array.new

MAIL.each_line do |line|
  break if line =~ />\s(__|--)^(PGP)/
  @mail << line
end

File.open(ARGV[0], 'w+') {|file| @mail.each {|line| file << line}}
