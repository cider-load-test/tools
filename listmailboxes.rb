#!/usr/bin/env ruby
# listmailboxes.rb
#
# Lists mailboxes in the $MAILDIR for use with mutt.
#
# (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
# Licensed under the MIT/X11 License.

require 'find'

# Where our mailboxes are located
MAILDIR = ENV['MAILDIR']

# List all mailboxes in the Maildir, prefixed with '='
# and separated with spaces
def listMailboxes
  dir = Array.new
  Find.find(MAILDIR) do |d|
    if File.directory?(d) and d =~ /INBOX/
      dir << "=" + d.split("/")[-1]
    end
    # We don't want to go deeper into any directory BUT we must enter
    # the Maildir directory
    # This is somewhat similar to "find $MAILDIR -maxdepth 1"
    Find.prune unless d == MAILDIR
  end
  return dir
end

puts listMailboxes.sort.join(" ")

# vim: et ts=2 sw=2 sts=2
