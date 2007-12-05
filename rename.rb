#!/usr/bin/env ruby
#
#  Simple renamer. Removes peer name from files downloaded through
#  IRC with weechat.
#
#  (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
#  Licensed under the MIT/X11 License. See LICENSE file for license details.

require 'ftools'

files = ARGV
peers = %w{ HardGay Mirrors Neverwhere [UR]DAN Nippon|zongzing Lancre Gawers|xdcc}

files.each do |file|
  name = (file.split('.') - peers).join('.')
  File.mv(file, name)
end
