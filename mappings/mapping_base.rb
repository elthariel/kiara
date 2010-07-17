##
## test_mapping.rb
## Login : <elthariel@rincevent>
## Started on  Wed Jul 14 16:46:40 2010 elthariel
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

require 'controller/mapping'

module BaseMapping
  include Mapping

  mapping do
    ########################
    #  GLOBAL
    ########################
    # Context/Focus Switching
    on_chain 'C-Tab' do
      action 'focus-next' do |context|
        context.next
      end
    end
    on_chain 'C-S-Tab' do
      action 'focus-prev' do |context|
        context.prev
      end
    end





    ########################
    #  Pattern list
    ########################

    # Current pattern selection
    on_chain 'Up' do
      if_context :is? => :patterns
      action 'prev-pattern' do |context|
        context.patterns.prev
      end
    end
    on_chain 'Down' do
      if_context :is? => :patterns
      action 'next-pattern' do |context|
        context.patterns.next
      end
    end
    on_chain 'S-Up' do
      if_context :is? => :patterns
      action 'prev-pattern-10' do |context|
        context.patterns.prev(10)
      end
    end
    on_chain 'S-Down' do
      if_context :is? => :patterns
      action 'next-pattern-10' do |context|
        context.patterns.next(10)
      end
    end



    # Pattern stacking
    @pattern_stack = []
    on_chain 'C-space' do
      if_context :is? => :patterns
      action 'reset-pattern-stack' do |c|
        @pattern_stack.clear
        puts "Reset pattern stack"
      end
    end
    on_chain 'space' do
      if_context :is? => :patterns
      action 'reset-pattern-stack' do |c|
        @pattern_stack.push c.controller.selected
        puts "I've stacked a new pattern : #{c.controller.selected}"
      end
    end







    ########################
    #  Playlist
    ########################

    # Playlist Cursor movement
    on_chain 'Left' do
      if_context :is? => :playlist
      action 'pls-cursor-move-left' do |context|
        cursor = context.playlist.cursor
        cursor[0] -= 1
        context.playlist.cursor = cursor
      end
    end
    on_chain 'Right' do
      if_context :is? => :playlist
      action 'pls-cursor-move-right' do |context|
        cursor = context.playlist.cursor
        cursor[0] += 1
        context.playlist.cursor = cursor
      end
    end
    on_chain 'Up' do
      if_context :is? => :playlist
      action 'pls-cursor-move-up' do |context|
        cursor = context.playlist.cursor
        cursor[1] -= 1
        context.playlist.cursor = cursor
      end
    end
    on_chain 'Down' do
      if_context :is? => :playlist
      action 'pls-cursor-move-down' do |context|
        cursor = context.playlist.cursor
        cursor[1] += 1
        context.playlist.cursor = cursor
      end
    end
    # Playlist fast Cursor movement
    on_chain 'C-Left' do
      if_context :is? => :playlist
      action 'pls-cursor-move-left-fast' do |context|
        cursor = context.playlist.cursor
        cursor[0] = cursor[0] - 4 + (cursor[0] - 4) % 4
        context.playlist.cursor = cursor
      end
    end
    on_chain 'C-Right' do
      if_context :is? => :playlist
      action 'pls-cursor-move-right-fast' do |context|
        cursor = context.playlist.cursor
        cursor[0] = cursor[0] + 4 - (cursor[0] + 4) % 4
        context.playlist.cursor = cursor
      end
    end
    on_chain 'C-Up' do
      if_context :is? => :playlist
      action 'pls-cursor-move-up-fast' do |context|
        cursor = context.playlist.cursor
        cursor[1] = cursor[1] - 4 + (cursor[1] - 4) % 4
        #cursor[1] = cursor[1] - 4 + (cursor[1] + 4) % 4
        context.playlist.cursor = cursor
      end
    end
    on_chain 'C-Down' do
      if_context :is? => :playlist
      action 'pls-cursor-move-down-fast' do |context|
        cursor = context.playlist.cursor
        cursor[1] = cursor[1] + 4 - (cursor[1] + 4) % 4
        context.playlist.cursor = cursor
      end
    end

    # Pattern add
    on_chain 'space' do
      if_context :is? => :playlist
      action 'playlist-add-pattern' do |c|
        if @pattern_stack.length > 0
          @pattern_stack.each do |id|
            c.playlist.add(id)
            cursor = c.playlist.cursor
            cursor[0] += c.patterns.size(id)
            c.playlist.cursor = cursor
          end
        else
          # Only add selected pattern
          c.playlist.add(c.patterns.selected)
          cursor = c.playlist.cursor
          cursor[0] += c.patterns.size(c.patterns.selected)
          c.playlist.cursor = cursor
        end
      end
    end
    on_chain 'C-space' do
      if_context :is? => :playlist
      action 'playlist-remove-pattern' do |c|
        c.playlist.remove
        cursor = c.playlist.cursor
        cursor[0] += 1
        c.playlist.cursor = cursor
      end
    end
    on_chain 'C-S-space' do
      if_context :is? => :playlist
      action 'playlist-remove-pattern-backward' do |c|
        c.playlist.remove
        cursor = c.playlist.cursor
        cursor[0] -= 1
        c.playlist.cursor = cursor
      end
    end







    ########################
    #  PianoRoll
    ########################

    # PianoRoll Cursor movement
    on_chain 'Up' do
      if_context :is? => :pianoroll
      action 'roll-cursor-up' do |c|
        cursor = c.pianoroll.cursor
        cursor[1] += 1
        c.pianoroll.cursor = cursor
      end
    end
    on_chain 'Down' do
      if_context :is? => :pianoroll
      action 'roll-cursor-down' do |c|
        cursor = c.pianoroll.cursor
        cursor[1] -= 1
        c.pianoroll.cursor = cursor
      end
    end
    on_chain 'Left' do
      if_context :is? => :pianoroll
      action 'roll-cursor-up' do |c|
        cursor = c.pianoroll.cursor
        cursor[0] -= Kiara::KIARA_PPQ / 4
        c.pianoroll.cursor = cursor
      end
    end
    on_chain 'Right' do
      if_context :is? => :pianoroll
      action 'roll-cursor-down' do |c|
        cursor = c.pianoroll.cursor
        cursor[0] += Kiara::KIARA_PPQ / 4
        c.pianoroll.cursor = cursor
      end
    end





  end
end

# module TestMapping
#   include Mapping

#   mapping do
#     on_chain 'C-x' do
#       on_chain 'C-f' do
#         if_context :is => :piano_roll
#         action 'action_name' do |context|
#           puts "super chain new file"
#         end
#       end
#       on_chain 'C-f' do
#         if_context :is_not => :piano_roll
#         action 'action_name' do |context|
#           puts "other super chain, Sens ton doigt!"
#         end
#       end
#     end
#     on_chain 'C-o' do
#       action 'action_name' do |context|
#         puts "chain test open"
#       end
#     end
#     on_chain 'C-s' do
#       action 'action_name' do |context|
#         puts "chain test save"
#       end
#     end
#   end
# end

