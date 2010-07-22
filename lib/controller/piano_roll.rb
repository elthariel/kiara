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

require 'controller/phrase'

class PianoRollController
  include WidgetAwareController

  attr_reader :track, :mark, :selected, :pattern

  def initialize(controller)
    @controller = controller

    # [x, y], i.e. [tick, note]
    @cursor = [0, 63]
    @selected = []
    # same as cursor
    @track = 0
    @pattern = 1
    @mark = nil
  end

  def cursor=(a)
    a[0] = 0 if a[0] < 0
    a[1] = 0 if a[1] < 0
    if a[0] >= @controller.patterns.selected_size * Kiara::KIARA_PPQ * 4
    a[0] = @controller.patterns.selected_size * Kiara::KIARA_PPQ * 4 - 1
    end
    a[1] = 127 if a[1] > 127
    @cursor = a
    selected_update
    redraw
  end

  def cursor
    @cursor.clone
  end

  def mark_set
    @mark = self.cursor
    redraw
  end

  def mark_reset
    @mark = nil
    redraw
  end

  def track=(id)
    id = 0 if id < 0
    id = Kiara::KIARA_TRACKS - 1 if id >= Kiara::KIARA_TRACKS
    @track = id
    selected_update
    redraw
  end

  def pattern=(id)
    unless id == @pattern
      id = 1 if id < 1
      id = Kiara::KIARA_MAXPATTERNS if id > Kiara::KIARA_MAXPATTERNS
      @pattern = id
      selected_update
      redraw
    end
  end

  # Create and return a phrase controller for the specified phrase and pattern
  # When a parameter is nil, the current selected item is used
  def phrase(pattern = nil, phrase_id = nil)
    pattern = @pattern unless pattern
    phrase_id = track unless phrase_id
    PhraseController.new(@controller, pattern, phrase_id)
  end

  def select_all
    @selected = []
    phrase.each_pos do |tick, event|
      @selected.push [tick, event.data1] if event.noteon?
    end
    redraw
  end

  # offset = [tick_offset, note offset]
  def move(offset)
    p = self.phrase
    @selected.each do |pos|
      npos = [pos[0] + offset[0], pos[1] + offset[1]]
      npos[0] = 0 if npos[0] < 0
      npos[1] = 0 if npos[1] < 0
      npos[1] = 127 if npos[1] > 128
      if npos[0] >= Kiara::KIARA_MAXBARS * 4 * Kiara::KIARA_PPQ
        npos[0] = Kiara::KIARA_MAXBARS * 4 * Kiara::KIARA_PPQ - 1
      end
      if p.move_note! pos, npos
        pos[0] = npos[0]
        pos[1] = npos[1]
      end
    end
    @cursor = [@cursor[0] + offset[0], @cursor[1] + offset[1]]
    @mark = [@mark[0] + offset[0], @mark[1] + offset[1]] if @mark
    redraw
  end

  # Changes notes duration by offset ticks
  def resize(offset)
    p = self.phrase
    @selected.each do |pos|
      p.resize_note! pos, offset
    end
    redraw
  end

  protected
  def selected_update
    p = self.phrase

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

