#!/usr/bin/env ruby
# (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
# Licensed under the MIT/X11 License.
# See LICENSE file for license details.
#
# Inspired by Miguel Santinho's Net::SMS::MyTMN perl module

require 'mechanize'

class MyTMN

  def initialize(username, password)
    @username = username
    @password = password
  end

  def send(target, message)
    agent = WWW::Mechanize.new
    page  = agent.get('http://www.tmn.pt/portal/site/tmn')
    form  = page.forms.name('frmLogin').first
    form.usr = @username
    form.pwd = @password
    agent.submit(form)
    r = agent.get('http://my.tmn.pt/web/easysms/EasySms.po').body
    idsessao = r.match(/\.*tmnsessionid\%3D(\w{32})\.*/)[0].sub('tmnsessionid%3D', '')
    page  = agent.get("http://my.tmn.pt/web/easysms/EasySms.po?silentauthdone=1&tmnsessionid=#{idsessao}")
    form  = page.forms.name('easySmsForm').first
    form.message = message
    form.phoneNumber1 = target
    a = agent.submit(form)
    agent.submit(a.forms[0])
  end
end

if ARGV.length != 0
  username = ARGV[0]
  password = ARGV[1]
  target   = ARGV[2]
  message  = ARGV[3..-1].join(" ")
else
  puts "Username: "; username = gets
  puts "Password: "; password = gets
  puts "Target:   "; target   = gets
  puts "Message:  "; message  = gets
end

mytmn = MyTMN.new(username, password)
mytmn.send(target, message)
puts "Message sent"

# vim: et ts=2 sw=2 sts=2
