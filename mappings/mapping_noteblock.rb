##
## mapping_noteblock.rb
## Login : <elthariel@rincevent>
## Started on  Thu Jul 22 06:37:14 2010 elthariel
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

# Note add
on_chain 'space' do
  if_context :is? => :pianoroll
  action 'node-add' do |c|
    p = c.pianoroll.noteblock
    pos = c.pianoroll.cursor
    unless p.occupied? (pos)
      e = p.alloc_event!
      e.noteon!
      e.chan = p.track_id
      e.data1 = pos[1]
      e.data2 = c.pianoroll.note_velocity
      e.duration = c.pianoroll.note_duration
      if p.insert! pos[0], e
        c.pianoroll.cursor=[pos[0] + e.duration, pos[1]]
      else
        p.dealloc_event! e
      end
    end
  end
end




# Note remove on cursor
on_chain 'C-space' do
  if_context :is? => :pianoroll
  action 'note-del-at-cursor' do |c|
    p = c.pianoroll.noteblock
    pos = c.pianoroll.cursor
    e = p.delete_note_on_tick_overlapping!(pos)
    if e
      c.pianoroll.cursor=[pos[0] + e.duration, pos[1]]
      p.dealloc_event! e
    end
  end
end

on_chain 'Delete' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'roll-delete-selected' do |c|
    p = c.pianoroll.noteblock
    c.pianoroll.selected.each do |item|
      p.delete_note_on_tick! item[0], item[1]
    end
    c.pianoroll.redraw
  end
end





# Step edition
[[0, '1'], [1, 'q'], [2, '2'], [3, 'w'], [4, '3'], [5, 'e'], [6, '4'], [7, 'r'],
 [8, '5'], [9, 't'], [10, '6'], [11, 'y'], [12, '7'], [13, 'u'], [14, '8'], [15, 'i']].each do |x|
  [[42, 'M-'], [84, ''], [127, 'S-']].each do |power|
    on_chain "#{power[1]}#{x[1]}" do
      if_context :is? => :pianoroll
      action "tr-edit-#{x[0]}-vel#{power[0]}" do |c|
        p = c.pianoroll.noteblock
        cursor = c.pianoroll.cursor
        bar = (cursor[0] / (Kiara::PPQ * 4)) * Kiara::PPQ * 4
        pos = [bar + x[0] * (Kiara::PPQ / 4), cursor[1]]
        # This checks is there's a note on the "step"
        if (p.occupied? pos)
          e = p.delete_note_on_tick_overlapping! pos
          p.dealloc_event! e
          c.pianoroll.redraw
        else
          e = p.alloc_event!
          e.noteon!
          e.chan = p.track_id
          e.data1 = pos[1]
          e.data2 = power[0]
          e.duration = Kiara::PPQ / 4
          p.dealloc_event! e unless p.insert! pos[0], e
          c.pianoroll.redraw
        end
      end
    end
  end
end





# Move Note
on_chain 'C-Up' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'move-note-up' do |c|
    c.pianoroll.move [0, 1]
  end
end

on_chain 'C-Down' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'move-note-down' do |c|
    c.pianoroll.move [0, -1]
  end
end

on_chain 'C-Left' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'move-note-left' do |c|
    c.pianoroll.move [-Kiara::PPQ / 4, 0]
  end
end

on_chain 'C-Right' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'move-note-right' do |c|
    c.pianoroll.move [Kiara::PPQ / 4, 0]
  end
end





# Move note FAST
on_chain 'C-S-Up' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'move-note-up' do |c|
    c.pianoroll.move [0, 12]
  end
end

on_chain 'C-S-Down' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'move-note-down' do |c|
    c.pianoroll.move [0, -12]
  end
end

on_chain 'C-S-Left' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'move-note-left' do |c|
    c.pianoroll.move [-Kiara::PPQ, 0]
  end
end

on_chain 'C-S-Right' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'move-note-right' do |c|
    c.pianoroll.move [Kiara::PPQ, 0]
  end
end





# Resize notes
on_chain 'C-L-Up' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'resize-note-left-small' do |c|
    c.pianoroll.resize 1
  end
end

on_chain 'C-L-Down' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'resize-note-right-small' do |c|
    c.pianoroll.resize -1
  end
end

on_chain 'C-L-Left' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'resize-note-left' do |c|
    c.pianoroll.resize -Kiara::PPQ / 4
  end
end

on_chain 'C-L-Right' do
  if_context :is? => :pianoroll
  if_context :has_selection? => true
  action 'resize-note-right' do |c|
    c.pianoroll.resize Kiara::PPQ / 4
  end
end

# Velocity edition

[[0, 'KP_0'], [14, 'KP_1'], [28, 'KP_2'], [42, 'KP_3'], [56, 'KP_4'],
 [70, 'KP_5'], [84, 'KP_6'], [98, 'KP_7'], [112, 'KP_8'], [127, 'KP_9']].each do |k|
  # If the piano roll has selected notes, we set all the note velocity to
  ## k[0] value
  on_chain k[1] do
    if_context :is? => :pianoroll
    if_context :has_selection? => true
    action "set-velocity-#{k[0]}" do |c|
      p = c.pianoroll.noteblock
      c.pianoroll.selected.each do |pos|
        note = p.get_note pos
        note.data2 = k[0]
      end
    end
  end
  # If there's no selection we set the default velocity for futures notes
  on_chain k[1] do
    if_context :is? => :pianoroll
    if_context :has_selection? => false
    action "set-current-velocity-#{k[0]}" do |c|
      c.pianoroll.note_velocity = k[0]
    end
  end
end

