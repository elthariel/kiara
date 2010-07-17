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
  DEBUG = true

  def initialize(mappings, context)
    @context = context
    @map = mappings
    @chain = [@map]
    @keychain = []
    chain_filter_init
    puts @map


    @valid = true
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
    @chain[@chain.length - 1]
  end

  def reset_chain
    puts "resetting chain #{@keychain.join ' '}"
    @keychain = []
    @chain = [@map]
  end

  # Recursively browse the mapping tree trying to find a corresponding mapping
  # Return true if a mapping still could be find (unexplored nodes) should not reset_chain
  # Return false if an action was executed or of there is no mapping (the branch doesn't exist)
  def rec_eval(chain, node)
    # found!, chain.len == 0, and has_key? :action and valid_context
    # continue!, chain.len == 0 and node.has_key? :subchains
    # elsif chain.len == 0, you lose
    # if chain.len > 0 and node.has_key? chain[0] -> :rec_eval
    # else loose return false
    if @context.valid_context? node
      puts "Valid context #{chain}" if DEBUG
      if chain.length == 0 and node.has_key? :action
        puts "Calling action" if DEBUG
        node[:action].call @context
        reset_chain
        true
      elsif chain.length == 0 and node.has_key? :subchains
        puts "Still having unexplored subkeys" if DEBUG
        true
      elsif chain.length == 0
        puts "Not any subchains to explore" if DEBUG
        false
      elsif chain.length > 0 and node.has_key? chain[0]
        puts "find the current chain #{chain[0]}, iterating child" if DEBUG
        node[chain[0]].each do |o|
          return true if rec_eval chain[1..-1], o
        end
        false
      else
        puts "The chain we are looking for doesn't exists" if DEBUG
        false
      end
    else
      puts "Invalid context #{chain}" if DEBUG
      false
    end
  end

  def event(chain)
    return false if @chain_filter.include?(chain)

    @keychain.push chain

    # keychain should be reversed if we want to pop the first element
    puts "-------------" if DEBUG
    result = !rec_eval(@keychain, @map)
    reset_chain if result
    result

  end
end

