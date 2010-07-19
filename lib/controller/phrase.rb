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

  def each
    (0..(Kiara::KIARA_PPQ * 4 * @pattern.get_size)).each do |i|
      iter = @phrase.get(i)
      while iter
        yield iter
        iter = iter.next
      end
    end
  end

  def each_pos
    (0..(Kiara::KIARA_PPQ * 4 * @pattern.get_size)).each do |i|
      iter = @phrase.get(i)
      while iter
        yield i, iter
        iter = iter.next
      end
    end
  end

end

