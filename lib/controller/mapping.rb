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

# This file defines a small DSL dedicated to the definition of mappings
# allowing the user to easily extend or customize Kiara.
#
# Mapping DSL example (this is what this is supposed to look like when finished)
#
# mapping do
#   on_chain 'C-x' do
#     # Apply to subchains
#     when if_context :is => :piano_roll
#     on_chain 'C-f' do
#       if_context :playing => false
#       # You can give an arbitrary name to your action (debug and info)
#       # context allows you to interact with the engine and ui
#       action 'load_midi_into_piano_roll' do |context|
#         puts "Loading midi and stuff"
#       end
#     end
#     on_chain 'C-f' do
#       when if_context :playing => true
#       action 'load_midi_into_piano_roll_error' do |context|
#         puts "Display somewhere that you can't load a midi file when playing"
#       end
#     end
#     on_chain 'C-s' do
#       action 'save_midi' do |context|
#         puts "Saving midi ..."
#       end
#     end
#   end
#   on_chain 'S-Right' do
#     when if_context :is => :piano_roll
#     when if_context :selected => true
#     action 'move-right' do |context|
#       puts "Should move the selected event(s) to the right"
#       puts context
#       # context.selection.each do |e|
#       #   puts
#       # end
#     end
# end

# This should gives us
a_block=nil
test_mapping = {
  'C-x' => [{ :context => { :is => :piano_roll },
              'C-f' => [ # Opening a chain block
                        # First item on this chain block
                        {:context => { :playing => false },
                          :action => a_block },
                        # Second item on this chain block
                        {:context => { :playing => true },
                          :action => a_block }
                       ],
              'C-s' => [{:action => a_block}]
            },
            {:test => nil}],
  'S-Right' => [{ :context => { :is => :piano_roll },
                  :action => a_block }]
}





module Mapping
  DEBUG = false
  @@mappings = []

  def self.included(mod)
    puts "A new mapping is defined"
    @@mappings.push mod
    mod.extend(ClassMethods)
  end

  def self.get
    result = {}
    @@mappings.each do |mod|
      # FIXME implement deep merge
      result = mod.__mapping.merge result
    end
    result
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
      @@chainstack = [@@mapping]
      @@chain = {}
      yield
    end

    def on_chain(key, &block)
      c = current_chain # The topmost chain block on the chain stack

      # Easy way to know if they are subchain and browse them
      c[:subchains] = [] unless c.has_key? :subchains
      c[:subchains].push key
      # When chain block is new, creating it
      c[key] = [] unless c.has_key? key
      chain_block_pos = c[key].length
      new_chain = {}  # The chain being created
      c[key].push new_chain
      puts "Pushing #{key} on the chain stack" if DEBUG
      @@chainstack.push new_chain
      yield
      @@chainstack.pop
      puts "Popping #{key}" if DEBUG
    end

    def action(name, &block)
      puts "Defining action: #{name}" if DEBUG
      c = current_chain
      c[:action_name] = name
      c[:action] = block
    end

    def if_context(opt_h)
      c = current_chain
      c[:context] = {} unless c.has_key? :context
      c[:context].merge! opt_h
    end

    private
    # Get the current chain regarding the current chain stack.
    def current_chain
      puts "Current chain stack, length:#{@@chainstack.length}" if DEBUG
      puts @@chainstack if DEBUG
      @@chainstack[@@chainstack.length - 1]
    end
  end



end

