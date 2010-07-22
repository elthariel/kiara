##
## mapping_playlist.rb
## Login : <elthariel@rincevent>
## Started on  Thu Jul 22 06:33:38 2010 elthariel
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

# Playlist Cursor movement
on_chain 'Left' do
  if_context :is? => :playlist
  action 'pls-cursor-move-left' do |controller|
    cursor = controller.playlist.cursor
    cursor[0] -= 1
    controller.playlist.cursor = cursor
  end
end

on_chain 'Right' do
  if_context :is? => :playlist
  action 'pls-cursor-move-right' do |controller|
    cursor = controller.playlist.cursor
    cursor[0] += 1
    controller.playlist.cursor = cursor
  end
end

on_chain 'Up' do
  if_context :is? => :playlist
  action 'pls-cursor-move-up' do |controller|
    cursor = controller.playlist.cursor
    cursor[1] -= 1
    controller.playlist.cursor = cursor
  end
end

on_chain 'Down' do
  if_context :is? => :playlist
  action 'pls-cursor-move-down' do |controller|
    cursor = controller.playlist.cursor
    cursor[1] += 1
    controller.playlist.cursor = cursor
  end
end



# Playlist fast Cursor movement
on_chain 'S-Left' do
  if_context :is? => :playlist
  action 'pls-cursor-move-left-fast' do |controller|
    cursor = controller.playlist.cursor
    cursor[0] = cursor[0] - 4 + (cursor[0] - 4) % 4
    controller.playlist.cursor = cursor
  end
end

on_chain 'S-Right' do
  if_context :is? => :playlist
  action 'pls-cursor-move-right-fast' do |controller|
    cursor = controller.playlist.cursor
    cursor[0] = cursor[0] + 4 - (cursor[0] + 4) % 4
    controller.playlist.cursor = cursor
  end
end

on_chain 'S-Up' do
  if_context :is? => :playlist
  action 'pls-cursor-move-up-fast' do |controller|
    cursor = controller.playlist.cursor
    cursor[1] = cursor[1] - 4 + (cursor[1] - 4) % 4
    #cursor[1] = cursor[1] - 4 + (cursor[1] + 4) % 4
    controller.playlist.cursor = cursor
  end
end

on_chain 'S-Down' do
  if_context :is? => :playlist
  action 'pls-cursor-move-down-fast' do |controller|
    cursor = controller.playlist.cursor
    cursor[1] = cursor[1] + 4 - (cursor[1] + 4) % 4
    controller.playlist.cursor = cursor
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

