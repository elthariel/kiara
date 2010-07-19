##
## piano_roll_events.rb
## Login : <elthariel@rincevent>
## Started on  Tue Jul 13 00:03:49 2010 elthariel
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

require 'gtk2'

module PianoRollEvents

  def event_initialize
    add_events Gdk::Event::BUTTON_PRESS_MASK
    add_events Gdk::Event::BUTTON_RELEASE_MASK
    add_events Gdk::Event::SCROLL_MASK
    self.signal_connect('button-press-event') {|s, e| on_clicked e}
    self.signal_connect('scroll-event') {|s, e| on_scroll e}

  end

  def get_note(e)
    tick = self.x_to_tick e.x - @pianow
    note = 127 - (e.y / self.blockh).to_i

    bars = Kiara::Memory.pattern.get(@pattern).get_size
    Kiara::Memory.pattern.get(@pattern).get(@phrase).get_note_on_tick(tick, bars, note)
  end

  def on_clicked(e)
    bars = Kiara::Memory.pattern.get(@pattern).get_size
    tick = (x_to_tick e.x - @pianow)
    tick -= tick % 12
    note = 127 - (e.y / blockh).to_i

    # puts "x#{e.x},y#{e.y}"
    # puts "Note: #{note}, tick: #{tick}"

    if e.x > @pianow and e.x < bars * 16 * blockw + @pianow
      if e.button == 1
        if !get_note e
          return true unless (event = Kiara::Memory.event.alloc)
          event.reset!
          event.noteon!
          event.data1 = note
          event.data2 = 100
          event.duration = Kiara::KIARA_PPQ / 4
          Kiara::Memory.event.dealloc(event) unless Kiara::Memory.pattern.get(@pattern).get(@phrase).insert!(tick, event)
          full_redraw
        end
      elsif e.button == 3
        puts "should delete"
      end

    end
    true
  end

  def on_scroll(e)

    if e.direction == Gdk::EventScroll::UP
      if e.state & Gdk::Window::CONTROL_MASK != 0
        self.zoomh = @zoomh * 2
       elsif e.state & Gdk::Window::MOD1_MASK != 0
        self.zoomw = @zoomw * 2
       else
         return false
      end
    elsif e.direction == Gdk::EventScroll::DOWN
      if e.state & Gdk::Window::CONTROL_MASK != 0
        self.zoomh = @zoomh / 2
      elsif e.state & Gdk::Window::MOD1_MASK != 0
        self.zoomw = @zoomw / 2
      else
        return false
      end
    else
      return false
    end

    full_redraw
    true
  end

end

