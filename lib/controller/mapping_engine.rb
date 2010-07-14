##
## mapping_engine.rb
## Login : <elthariel@rincevent>
## Started on  Wed Jul 14 19:25:40 2010 elthariel
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

class MappingEngine

  def initialize(mappings)
    @map = mappings.reverse
    @chain = []
    chain_filter_init
    puts @map
  end

  def chain_filter_init
    @chain_filter = []
    tmp_filter = %w{C rC S rS M rM L rL}
    tmp_filter.each do |x|
      @chain_filter.push x
      tmp_filter.each do |y|
        @chain_filter.push "#{x}-#{y}"
      end
    end
  end

  def current_chain
    iter = @map[0]
    @chain.each { |x| iter = iter[x] }
    iter
  end

  def event(chain)
    return false if @chain_filter.include?(chain)

    c = current_chain
    puts @chain.join ' '
    puts chain
    if c.has_key? chain
      if c[chain].has_key? :action
        c[chain][:action].call
        @chain = []
      else
        @chain.push chain
      end
    else
      puts "Unknown chain"
      @chain = []
    end
  end
end

