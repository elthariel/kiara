##
## mapping.rb
## Login : <elthariel@rincevent>
## Started on  Wed Jul 14 16:43:01 2010 elthariel
## $Id$
##
## Author(s):
##  - elthariel <elthariel@gmail.com>
##
## Copyright (C) 2010 elthariel
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
##

module Mapping
  puts "Mapping test"
  @@mappings = []

  def self.included(mod)
    puts "A new mapping is defined"
    @@mappings.push mod
    mod.extend(ClassMethods)
  end

  def self.get
    @@mappings.map do |mod|
       mod.__mapping
    end
  end

  module ClassMethods
    # Get the result mapping
    def __mapping
      @@mapping
    end

    # "Dsl root"
    def mapping
      puts "mapping in #{self}"
      @@mapping = {}
      @@chain = []
      yield
    end

    def current_chain
      puts @@mapping
      iter = @@mapping
      @@chain.each { |x| iter = iter[x] }
      iter
    end

    def chain(name, &block)
      current_chain[name] = {}
      @@chain.push name
      yield
      @@chain.pop
    end

    def action(&block)
      current_chain[:action] = block
    end
  end





  # module Keyword
  #   class Map
  #     attr_reader :chains
  #     def initialize
  #       @chains = {}
  #     end

  #     def chain(name, &block)
  #       @chains[name] = {}
  #       yield Chain.new(self, name)
  #     end
  #   end

  #   class Chain
  #     attr_reader :name, :_action
  #     def initialize(map, name)
  #       @map = map
  #       @name = name
  #     end

  #     def action(&block)
  #       @map.chains[name][:action] = block
  #     end
  #   end
  # end

end

