#!/usr/bin/env ruby
#
#  (C)opyright 2007 Ricardo Martins <meqif at scarybox dot net>
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

  def self.Eratosthenes2(max)
    primes = Array.new
    (2..max).to_a.reverse.each do |number|
      primes.each do |p|
        primes << number unless number%p == 0
      end
    end
    return primes
  end
end
