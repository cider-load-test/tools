#!/usr/bin/env ruby
#
#  (C)opyright 2007 Ricardo Martins <ricardo at scarybox dot net>
#  Licensed under the MIT/X11 License. See LICENSE file for license details.

class Sieve

  def self.Eratosthenes(max)
    list = (2..max).to_a.reverse
    primes = Array.new
    while not list.empty?
      p = list.pop
      primes << p
      list.each do |number|
        if number%p == 0
          list.delete(number)
        end
      end
    end
    return primes
  end

end
