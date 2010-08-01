##
## phrase.rb
## Login : <elthariel@rincevent>
## Started on  Sat Jul 17 18:50:12 2010 elthariel
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

class NoteBlockController
  attr_reader :block

  def initialize(controller, block)
    @controller = controller
    @roll = controller.pianoroll
    @block = block
    # @phrase = @pattern.get(track_id)
  end

  def alloc_event!
    e = Kiara::Memory.event.alloc
    e.reset!
    e
  end

  def dealloc_event!(e)
    if e
      e.reset!
      Kiara::Memory.event.dealloc(e)
    end
  end

  # Pos has the same syntax than cursor
  def occupied?(pos)
    @block.get_note_on_tick pos[0], @block.length, pos[1]
  end

  def get_note(pos)
    iter = @block.get(pos[0])
    while iter and iter.data1 != pos[1] do
      iter = iter.next
    end
    return iter if iter and iter.noteon?
    nil
  end

  def insert!(tick, event)
    return true if event and @block.insert!(tick, event)
    false
  end

  # pos = [tick, note]
  # returns true if the note has been moved at the request pos
  def move_note!(old_pos, new_pos)
    return true if old_pos == new_pos
    if old_pos[0] == new_pos[0] and (note = get_note old_pos)
      note.data1 = new_pos[1]
    elsif (note = delete_note_on_tick! old_pos[0], old_pos[1])
      note.data1 = new_pos[1]
      unless insert!(new_pos[0], note)
        dealloc_event note
        return false
      end
    else
      return false
    end
    true
  end

  # Resize the note at pos, by offset tick
  # returns true if successfull
  def resize_note!(pos, offset)
    if (note = get_note(pos))
      if note.duration + offset < 1
        @controller.pianoroll.note_duration = 1
        note.duration = 1
      else
        @controller.pianoroll.note_duration = note.duration + offset
        note.duration = note.duration + offset
      end
      true
    else
      false
    end
  end


  # Delete a note with data1=note starting precisely at tick=tick
  # Returns true if correctly deleted
  def delete_note_on_tick!(tick, note)
    iter = @block.get(tick)
    while iter and iter.data1 != note do
      iter = iter.next
    end
    return iter if iter and @block.remove!(tick, iter)
    nil
  end

  # Delete a note with data1=note starting at or overlapping tick=tick
  # Return true if the event was deleted
  def delete_note_on_tick_overlapping!(pos)
    event = occupied?(pos)
    #  if event
    if event and event.noteon?
      tick = nil
      each_pos do |t, e|
        if pos[0] >= t and pos[0] < t + event.duration and pos[1] == event.data1
          tick = t
        end
      end
      return event if tick and @block.remove!(tick, event)
      nil
    end
    nil
  end

  # phrase.each_pos { |event| ... } Iterates on all events of
  # the phrase, passing each event to the given block
  def each
    iter = 0
    while (iter = @block.next_used_tick iter) >= 0 do
      e = @block.get(iter)
      while e do
        yield e
        e = e.next
      end
      iter += 1
    end
  end

  # phrase.each_pos { |tick, event| ... } Iterates on all events of
  # the phrase, passing the tick of the current event and the event to
  # the block
  def each_pos
    iter = 0
    while (iter = @block.next_used_tick iter) >= 0 do
      e = @phrase.get(iter)
      while e do
        yield iter, e
        e = e.next
      end
      iter += 1
    end
  end

end

