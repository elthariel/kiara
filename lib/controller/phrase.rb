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

class PhraseController
  attr_reader :pattern, :track

  def initialize(context, pattern_id, track_id)
    @context = context
    @roll_ui = context.ui.roll
    @pattern_id = pattern_id
    @track = track_id
    @pattern = Kiara::Memory.pattern.get(@pattern_id)
    @phrase = @pattern.get(track_id)
  end

  def alloc_event!
    Kiara::Memory.event.alloc
  end

  def dealloc_event!(e)
    Kiara::Memory.event.dealloc(e)
  end

  # Pos has the same syntax than cursor
  def occupied?(pos)
    @phrase.get_note_on_tick pos[0], @pattern.get_size, pos[1]
  end

  def insert!(tick, event)
    @phrase.insert!(tick, event) if event
  end

  # Delete a note with data1=note starting precisely at tick=tick
  # Returns true if correctly deleted
  def delete_note_on_tick!(tick, note)
    iter = @phrase.get(tick)
    while iter and iter.data1 != note do
      iter = iter.next
    end
    if iter
      res = @phrase.remove!(tick, iter)
      iter if res
    else
      nil
    end
  end

  # Delete a note with data1=note starting at or overlapping tick=tick
  # Return true if the event was deleted
  def delete_note_on_tick_overlapping!(pos)
    event = occupied?(pos)
    @phrase.remove!(pos[0], event) if event
    event
  end

  # phrase.each_pos { |event| ... } Iterates on all events of
  # the phrase, passing each event to the given block
  def each
    iter = 0
    while (iter = next_used_tick iter) >= 0 do
      e = get(iter)
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
    while (iter = next_used_tick iter) >= 0 do
      e = get(iter)
      while e do
        yield iter, e
        e = e.next
      end
      iter += 1
    end
  end

end

