#!/usr/bin/env ruby
# 
# Simple but effective password generator. If you don't specify how
# long you want the password, it will be 10 characters long by default.
#
# (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
# Licensed under the MIT/X11 License. See LICENSE file for license details.

pool = ("A".."Z").to_a + ("a".."z").to_a + (0..9).to_a + %w[# ! $ % & _ -]
@password = ""
times = ARGV[0]||10

times.to_i.times { @password << pool[rand(pool.length - 1)].to_s }

puts @password
