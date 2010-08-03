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

class MappingEngineError < StandardError
end

class MappingEngine
  DEBUG = false

  CHAIN_NOT_HANDLED = 0
  CHAIN_HANDLED = 1
  CHAIN_WAITING = 2

  def initialize(mappings, controller)
    @controller = controller
    @map = mappings
    @chain = [@map]
    @keychain = []
    chain_filter_init
    puts @map if DEBUG


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
    puts "resetting chain #{@keychain.join ' '}" if DEBUG
    @keychain = []
    @chain = [@map]
  end

  # Recursively browse the mapping tree trying to find a corresponding mapping
  # Return WAITING if a mapping still could be find (unexplored nodes) should not reset_chain
  # Return HANDLED if an action was executed
  # Return NOT_HANDLED of there is no mapping (the branch doesn't exist)
  def rec_eval(chain, node)
    # found!, chain.len == 0, and has_key? :action and valid_context
    # continue!, chain.len == 0 and node.has_key? :subchains
    # elsif chain.len == 0, you lose
    # if chain.len > 0 and node.has_key? chain[0] -> :rec_eval
    # else loose return false
    if @controller.context.valid_context? node
      puts "Valid context #{chain}" if DEBUG
      if chain.length == 0 and node.has_key? :action
        puts "[CHAIN_HANDLED] Calling action" if DEBUG
        node[:action].call @controller
        reset_chain
        #true
        CHAIN_HANDLED
      elsif chain.length == 0 and node.has_key? :subchains
        puts "[CHAIN_WAITING] Still having unexplored subkeys" if DEBUG
        #true
        CHAIN_WAITING
      elsif chain.length == 0
        puts "[CHAIN_NOT_HANDLED] Not any subchains to explore" if DEBUG
        #false
        CHAIN_NOT_HANDLED
      elsif chain.length > 0 and node.has_key? chain[0]
        puts "find the current chain #{chain[0]}, iterating child" if DEBUG
        node[chain[0]].each do |o|
          res = rec_eval chain[1..-1], o
          # return if res
          return res if res > CHAIN_NOT_HANDLED
        end
        #false
        CHAIN_NOT_HANDLED
      else
        puts "[CHAIN_NOT_HANDLED] The chain we are looking for doesn't exists" if DEBUG
        #false
        CHAIN_NOT_HANDLED
      end
    else
      puts "[CHAIN_NOT_HANDLED] Invalid context #{chain}" if DEBUG
      #false
      CHAIN_NOT_HANDLED
    end
  end

  def event(chain)
    return false if @chain_filter.include?(chain)

    @keychain.push chain

    begin
      puts chain if DEBUG
      result = rec_eval(@keychain, @map)
      reset_chain unless result == CHAIN_WAITING
      if result == CHAIN_NOT_HANDLED
        # if the chain is not handled by the mapping engine
        # tell gtk it can forward it normally.
        false
      else
        # Don't transmit the chain to gtk subsystem since we either
        # handled it or stored it waiting for the next event.
        true
      end
    rescue => e
      reset_chain
      puts e
      puts e.backtrace
      # If we raised an exception this is probably due to an event handler
      # So we kind of "handled" the event ==> don't forward it to gtk
      true
    end
  end
end

