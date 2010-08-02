##
## piano_roll.rb
## Login : <elthariel@rincevent>
## Started on  Sat Jul 17 18:49:03 2010 elthariel
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

require 'controller/note_block'

class PianoRollController
  include WidgetAwareController

  attr_reader :mark, :selected, :clipboard
  attr_accessor :note_duration, :note_velocity

  def initialize(controller)
    @controller = controller

    # [x, y], i.e. [tick, note]
    @cursor = [0, 63]
    # Selection is an array of cursor
    @selected = []
    # Clipboard is a serialization of a selection. The format is the following:
    #  [[tick, [status, data1, data2, ...],
    #          [status, data1, data2, ...]],
    #  [tick2, ...],
    #  ...]
    # The serialized note is altered to have some of its informations (tick and note)
    # being sotred as a relative position from cursor position
    # When deserialized the cursor position, which could have been moved, is added back.
    @clipboard = []
    @mark = nil
    # The currently edited noteblock. It doesn't stay nil for long.
    # See ClusterController::_create_first_block
    @noteblock = nil

    # Some states used by mapping
    @note_duration = Kiara::PPQ / 4
    @note_velocity = 98
  end

  def cursor=(a)
    a[0] = 0 if a[0] < 0
    a[1] = 0 if a[1] < 0
    if a[0] >= @noteblock.length * Kiara::PPQ * 4
    a[0] = @noteblock.length * Kiara::PPQ * 4 - 1
    end
    a[1] = 127 if a[1] > 127
    @cursor = a
    selected_update
    @widget.scroll
    redraw!
  end

  def cursor
    @cursor.clone
  end

  def mark_set
    @mark = self.cursor
    redraw!
  end

  def mark_reset
    @mark = nil
    redraw!
  end

  # Create a NoteBlockController for the current NoteBlock
  def noteblock()
    # FIXME initialize PianoRollController with a noteblock
    #NoteBlockController.new(@controller, @noteblock)
    NoteBlockController.new(@controller, Kiara::NoteBlock.new)
  end

  def noteblock=(block)
    @noteblock = block
    redraw!
  end

  def select_all
    @selected = []
    noteblock.each_pos do |tick, event|
      @selected.push [tick, event.data1] if event.noteon?
    end
    redraw!
  end

  # Serialize selection to clipboard for later use
  def to_clipboard
    @clipboard = []
    p = self.noteblock
    last_tick = nil
    current_list = []
    @selected.each do |cursor|
      unless cursor[0] == last_tick
        @clipboard.push current_list unless last_tick == nil
        last_tick = cursor[0]
        current_list = [cursor[0] - @cursor[0]] # relative positioning
      end
      note = p.get_note cursor
      serialized_note = note.to_a
      serialized_note[1] -= @cursor[1] # relative positioning
      current_list.push serialized_note
    end
    @clipboard.push current_list if last_tick
  end

  def from_clipboard
    p = noteblock
    @selected = []
    @clipboard.each do |tick|
      t = tick[0]
      #puts "tick #{t}"
      tick[1, tick.length - 1].each do |snote|
        #puts "\tnote #{snote}"
        note = p.alloc_event!
        serialized_note = snote.clone
        serialized_note[1] += @cursor[1]
        note.from_a serialized_note
        if p.insert! t + @cursor[0], note
          @selected.push [t + @cursor[0], serialized_note[1]]
        else
          p.dealloc_event! note
        end
      end
    end
  end

  # offset = [tick_offset, note offset]
  def move(offset)
    p = self.noteblock
    @selected.each do |pos|
      npos = [pos[0] + offset[0], pos[1] + offset[1]]
      npos[0] = 0 if npos[0] < 0
      npos[1] = 0 if npos[1] < 0
      npos[1] = 127 if npos[1] > 128
      if npos[0] >= Kiara::MAX_BARS * 4 * Kiara::PPQ
        npos[0] = Kiara::MAX_BARS * 4 * Kiara::PPQ - 1
      end
      if p.move_note! pos, npos
        pos[0] = npos[0]
        pos[1] = npos[1]
      end
    end
    @cursor = [@cursor[0] + offset[0], @cursor[1] + offset[1]]
    @mark = [@mark[0] + offset[0], @mark[1] + offset[1]] if @mark
    redraw!
  end

  # Changes notes duration by offset ticks
  def resize(offset)
    p = self.noteblock
    @selected.each do |pos|
      p.resize_note! pos, offset
    end
    redraw!
  end

  protected
  def selected_update
    p = self.noteblock

    if @mark
      @selected = []
      lt = @cursor[0] <= @mark[0] ? @cursor[0] : @mark[0]
      ht = @cursor[0] > @mark[0] ? @cursor[0] : @mark[0]
      ln = @cursor[1] <= @mark[1] ? @cursor[1] : @mark[1]
      hn = @cursor[1] > @mark[1] ? @cursor[1] : @mark[1]
      puts "Selection square lt #{lt}, ht #{ht}, ln #{ln}, hn #{hn}"
      p.each_pos do |tick, event|
        if event.noteon?
          if event.data1 >= ln and event.data1 <= hn
            # FIXME, should we select overlapped notes ?
            if (tick >= lt and tick <= ht) or (tick + event.duration >= lt and tick + event.duration <= ht)
              #puts "controller: i selected a note"
              @selected.push [tick, event.data1]
            end
          end
        end
      end
    else
      if (e = p.occupied? @cursor)
        p.each_pos do |tick, note|
          if note.noteon? and note.data1 == @cursor[1] and @cursor[0] >= tick and @cursor[0] < tick + note.duration
            @selected = [[tick, note.data1]]
          end
        end
      else
        @selected = []
      end
    end
  end

end

