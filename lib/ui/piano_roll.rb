##
## piano_roll.rb
## Login : <elthariel@rincevent>
## Started on  Mon Jul 12 13:43:38 2010 elthariel
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
require 'colors'
require 'piano_roll_attributes'
require 'piano_roll_events'

class PianoRoll < Gtk::DrawingArea
  include ColorMixin
  include PianoRollEvents
  include PianoRollAttributes

  attr_reader :selected, :cursor, :mark, :phrase

  def initialize(ui, engine)
    super()
    @ui = ui
    @engine = engine
    @pattern = 1
    @phrase = 0
    @blockh = 18
    @blockw = 18
    @zoomh = 1.0
    @zoomw = 1.0
    @pianow = 50
    zoom_changed

    # ?? Selected is an array of Event *
    @selected = []
    # Cursor is [tick, note]
    @cursor = [0, 127]
    @mark = nil
    @controller_focus = false

    self.signal_connect('expose-event') {|s, e| on_expose e}
    event_initialize
  end

  def pattern=(p)
    if p < Kiara::KIARA_MAXPATTERNS
      @pattern = p
      full_redraw
      update_label
    end
  end

  def phrase=(p)
    if p < Kiara::KIARA_TRACKS
      @phrase = p
      full_redraw
      update_label
    end
  end

  def selected=(a)
    @selected = a
    full_redraw
  end

  def mark=(m)
    puts "Set mark, #{m[0]}:#{m[1]}" if m
    @mark = m
    full_redraw
  end

  def cursor=(a)
    puts "Roll: cursor moved to tick #{a[0]}, note #{a[1]}"
    hadj = parent.hadjustment
    vadj = parent.vadjustment
    @cursor = a
    full_redraw

    # Compute position of the cursor in pixel
    cursor_xpos = a[0] * tick_size
    cursor_ypos = (127 - a[1]) * blockh

    # Limit scroll down to scrollwindow_size - viewport / 2
    # because gtk allows us to scroll below the widget :-/
    if cursor_ypos > vadj.upper - parent.allocation.height / 2
      vadj.value = vadj.upper - parent.allocation.height
    else
      vadj.value = cursor_ypos - parent.allocation.height / 2
    end
  end

  def update_label
    text = "Pattern #{@pattern}, Track #{@phrase + 1}"
    @ui.builder.o('piano_roll_label').set_text text
  end

  def redraw
    full_redraw
  end

  def full_redraw
    if realized?
      a = Gdk::Rectangle.new 0, 0, allocation.width, allocation.height
      window.invalidate a, false
    end
  end

  def zoom_changed
    psize = Kiara::Memory.pattern.get(@pattern).get_size
    set_size_request(blockw * 16 * psize + @pianow, blockh * 128)
    full_redraw
  end

  def x_to_tick(x)
    (x / tick_size).to_i
  end

  def on_expose(e)
    # Initialization
    a = allocation
    @cairo = self.window.create_cairo_context
    @cairo.rectangle e.area.x, e.area.y, e.area.width, e.area.height
    @cairo.clip

    # Background
    color.background unless controller_focus?
    color.background_focus if controller_focus?
    @cairo.rectangle 0, 0, a.width, a.height
    @cairo.fill

    draw_piano(e)
    draw_grid(e)
    draw_notes(e)
    draw_cursor(e)
  end

  def draw_grid(e)
    a = allocation

    @cairo.set_line_width(0.5)
    bars = Kiara::Memory.pattern.get(@pattern).get_size
    (1.. bars * 16).each do |x|
      if x % 4 == 0
        color.vgrid_high
      else
        color.vgrid_low
      end
      @cairo.move_to x * self.blockw + @pianow, 0
      @cairo.line_to x * self.blockw + @pianow, a.height
      @cairo.stroke
    end

    @cairo.set_line_width(0.5)
    color.hgrid
    (1..128).each do |y|
      @cairo.move_to @pianow, y * self.blockh
      @cairo.line_to a.width, y * self.blockh
      @cairo.stroke
    end


  end

  def draw_piano(e)
    a = allocation
    # Which keys are black ?
    note_map = [0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0]
    note_text = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

    (0..128).each do |i|
      if note_map[i%12] == 1
        color.note_sharp
      else
        color.note
      end

      @cairo.rectangle 0, (128 - i - 1) * blockh, @pianow, blockh
      @cairo.fill
      @cairo.rectangle 0, (128 - i - 1) * blockh, @pianow, blockh
      color.note_sharp
      @cairo.set_line_width 0.5
      @cairo.stroke

      if note_map[i%12] == 1
	color.text_sharp
      else
	color.text
      end
      @cairo.set_font_size 8
      @cairo.move_to 20, (128 - i - 1) * blockh + 12
      @cairo.text_path "#{note_text[i%12]} #{i/12 - 2}"
      @cairo.fill
    end
  end

  def draw_notes(e)
    ticks = Kiara::KIARA_PPQ * 4 * current_pattern.get_size

    (0..ticks).each do |t|
      event = current_phrase.get(t)
      while event && event.is_noteon do
        draw_note(t, event)
        event = event.next
      end
    end
  end

  def draw_note(tick, note)
    # Position of the note in pixels
    pos_x = tick * tick_size + @pianow
    # Width of the note in pixels
    w = note.duration * tick_size

    color.block
    # Rounded cube 2.0
    # _ -> move_to and line_to
    # / or \ -> rel_curve
    #		1'	   2'
    #            ______
    #	1	/      \	2
    #		\______/
    #		1''	  2''

    #set the current point to 1'
    @cairo.move_to pos_x + blockh / 2, (127 - note.data1) * blockw
    #TODO draw the line between 1' & 2'
    #	@cairo.rel_line_to blockh, 0
    #draw the line from 2' to 2
    @cairo.rel_curve_to blockh / 2, 0, blockh / 2, 0, blockh / 2 , blockh / 2
    #draw the line from 2 to 2''
    @cairo.rel_curve_to 0, blockh / 2, 0, blockh / 2, -blockh / 2, blockh / 2
    #TODO draw the line between 2'' & 1''
    #	@cairo.rel_line_to -blockh, 0
    #draw the line from 1'' to 1
    @cairo.rel_curve_to -blockh / 2, 0, -blockh / 2, 0, -blockh / 2 , -blockh / 2
    #draw the line from 1 to 1'
    @cairo.rel_curve_to 0, -blockh / 2, 0, -blockh / 2,  blockh / 2, -blockh / 2

    @cairo.rel_line_to 0, (note.duration * tick_size)
    #	@cairo.rel_line_to -blockh, 0
    #	@cairo.rel_line_to 0, -(note.duration * tick_size)

    @cairo.fill
    color.block_border
    @cairo.stroke
  end

  def draw_cursor(e)
    if @controller_focus
      if @mark
        color.cursor
        x = @mark[0] * tick_size + @pianow
        y = (127 - @mark[1]) * blockh
        w = @cursor[0] * tick_size - @mark[0] * tick_size
        h = (127 - @cursor[1]) * blockh - (127 - @mark[1]) * blockh
        puts "Trying to draw selection #{x}:#{y}:#{w}:#{h}"
        @cairo.rectangle x, y, w, h
        @cairo.fill
        color.note_sharp
        @cairo.rectangle x, y, w, h
        @cairo.set_line_width(0.5)
        @cairo.stroke
      end
      color.cursor
      @cairo.rectangle(@cursor[0] * tick_size + @pianow, 0,
                       blockw, allocation.height)
      @cairo.fill
      @cairo.rectangle(0 + @pianow,
                       (127 - @cursor[1]) * blockh,
                       allocation.width, blockh)
      @cairo.fill
      color.note_sharp
      @cairo.move_to(@cursor[0] * tick_size + @pianow,
                     (127 - @cursor[1]) * blockh)
      @cairo.line_to(@cursor[0] * tick_size + @pianow,
                     (127 - @cursor[1] + 1) * blockh)
      @cairo.set_line_width(0.8)
      @cairo.stroke
    end
  end

  def controller_focus?
    @controller_focus
  end

  def controller_focus=(focused)
    @controller_focus = focused
    full_redraw
  end

end


