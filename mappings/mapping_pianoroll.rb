##
## mapping_pianoroll.rb
## Login : <elthariel@rincevent>
## Started on  Thu Jul 22 06:35:42 2010 elthariel
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

# PianoRoll Reset
on_chain 'C-g' do
  if_context :is? => :pianoroll
  action 'roll-reset' do |c|
    c.pianoroll.mark_reset
  end
end

# PianoRoll Mark and selection
on_chain 'C-s' do
  if_context :is? => :pianoroll
  action 'roll-set-mark' do |c|
    c.pianoroll.mark_set
  end
end

on_chain 'C-a' do
  if_context :is? => :pianoroll
  action 'roll-select-all' do |c|
    c.pianoroll.select_all
  end
end





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

# PianoRoll PRECISE Cursor movement
on_chain 'M-Left' do
  if_context :is? => :pianoroll
  action 'roll-cursor-up' do |c|
    cursor = c.pianoroll.cursor
    cursor[0] -= 1
    c.pianoroll.cursor = cursor
  end
end

on_chain 'M-Right' do
  if_context :is? => :pianoroll
  action 'roll-cursor-down' do |c|
    cursor = c.pianoroll.cursor
    cursor[0] += 1
    c.pianoroll.cursor = cursor
  end
end




# PianoRoll FAST Cursor movement
on_chain 'S-Up' do
  if_context :is? => :pianoroll
  action 'roll-cursor-up' do |c|
    cursor = c.pianoroll.cursor
    cursor[1] += 12
    c.pianoroll.cursor = cursor
  end
end

on_chain 'S-Down' do
  if_context :is? => :pianoroll
  action 'roll-cursor-down' do |c|
    cursor = c.pianoroll.cursor
    cursor[1] -= 12
    c.pianoroll.cursor = cursor
  end
end

on_chain 'S-Left' do
  if_context :is? => :pianoroll
  action 'roll-cursor-up' do |c|
    cursor = c.pianoroll.cursor
    if cursor[0] % Kiara::KIARA_PPQ == 0
      cursor[0] -= Kiara::KIARA_PPQ
    else
      cursor[0] -= cursor[0] % Kiara::KIARA_PPQ
    end
    c.pianoroll.cursor = cursor
  end
end

on_chain 'S-Right' do
  if_context :is? => :pianoroll
  action 'roll-cursor-down' do |c|
    cursor = c.pianoroll.cursor
    cursor[0] += Kiara::KIARA_PPQ
    cursor[0] -= cursor[0] % Kiara::KIARA_PPQ
    c.pianoroll.cursor = cursor
  end
end




# PianoRoll Phrase Switch
on_chain 'Page_Up' do
  if_context :is? => :pianoroll
  action 'phrase-prev' do |c|
    c.pianoroll.track = c.pianoroll.track - 1
  end
end

on_chain 'Page_Down' do
  if_context :is? => :pianoroll
  action 'phrase-prev' do |c|
    c.pianoroll.track = c.pianoroll.track + 1
  end
end

on_chain 'L-Left' do
  if_context :is? => :pianoroll
  action 'phrase-prev' do |c|
    c.pianoroll.track = c.pianoroll.track - 1
  end
end

on_chain 'L-Right' do
  if_context :is? => :pianoroll
  action 'phrase-prev' do |c|
    c.pianoroll.track = c.pianoroll.track + 1
  end
end

on_chain 'S-Page_Up' do
  if_context :is? => :pianoroll
  action 'phrase-prev' do |c|
    c.pianoroll.track = c.pianoroll.track - 4
  end
end

on_chain 'S-Page_Down' do
  if_context :is? => :pianoroll
  action 'phrase-prev' do |c|
    c.pianoroll.track = c.pianoroll.track + 4
  end
end

