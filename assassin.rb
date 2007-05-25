#!/usr/bin/env ruby
#
#  Signature Assassin 0.1 
#
#  (C)opyright 2007 Ricardo Martins <meqif at scarybox dot net>
#  Licensed under the MIT/X11 License. See LICENSE file for license details.

MAIL = open(ARGV[0]).read
@mail = Array.new
@sig_found = nil
@blank = false

MAIL.each_line do |line|
  unless @sig_found
    if not line =~ /^>\s\s*(--(\s*|\w*)$|__)/
      if line =~ /^>\s$/
        @mail << line unless @blank
        @blank = true
      else
        @mail << line
        @blank = false
      end
    else
      @sig_found = true
    end
  end
end

# Add signature file, if found
if File.exists?(ENV['HOME'] + '/.signature') and not @mail.last == open(ENV['HOME'] + '/.signature').read
  @mail << "\n--\n" + open(ENV['HOME'] + '/.signature').read
end

File.open(ARGV[0], 'w+') {|file| @mail.each {|line| file << line}}
