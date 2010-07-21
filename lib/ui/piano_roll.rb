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

class PianoRoll < Gtk::DrawingArea
  include ColorMixin
  include PianoRollAttributes

  def initialize(ui, controller)
    super()

    @ui = ui
    @controller = controller
    @roll = @controller.pianoroll
    @roll.widget = self
    @phrase = @roll.phrase

    @blockh = 18
    @blockw = 18
    @zoomh = 1.0
    @zoomw = 1.0
    @pianow = 50
    @old_cursor = [0, 0]
    zoom_changed

    self.signal_connect('expose-event') {|s, e| on_expose e}
    self.signal_connect('realize') { scroll }
  end

  def focus?
    @controller.context.focus? :pianoroll
  end

  def scroll
    cursor = @roll.cursor
    unless cursor == @old_cursor
      @old_cursor = cursor.clone
      hadj = parent.hadjustment
      vadj = parent.vadjustment

      # Compute position of the cursor in pixel
      cursor_xpos = cursor[0] * tick_size
      cursor_ypos = (127 - cursor[1]) * blockh

      # Limit scroll down to scrollwindow_size - viewport / 2
      # because gtk allows us to scroll below the widget :-/
      if cursor_ypos > vadj.upper - parent.allocation.height / 2
        vadj.value = vadj.upper - parent.allocation.height
      else
        vadj.value = cursor_ypos - parent.allocation.height / 2
      end
    end
  end

  def update_label
    text = "Pattern #{@controller.patterns.selected}, Track #{@roll.track + 1}"
    @ui.builder.o('piano_roll_label').set_text text
  end

  def redraw
    update_label
    full_redraw
    scroll
  end

  def full_redraw
    queue_draw if realized?
  end

  def zoom_changed
    psize = @phrase.pattern.get_size
    set_size_request(blockw * 16 * psize + @pianow, blockh * 128)
  end

  def x_to_tick(x)
    (x / tick_size).to_i
  end

  def on_expose(e)
    #Profiler__.start_profile
    # Initialization
    a = allocation
    puts "Unable to create context" unless (@cairo = self.window.create_cairo_context)
    @cairo.rectangle e.area.x, e.area.y, e.area.width, e.area.height
    @cairo.clip

    # FIXME
    # Optimize this ! Cache values or implement observer
    @phrase = @roll.phrase

    # Background
    color.background unless focus?
    color.background_focus if focus?
    @cairo.rectangle 0, 0, a.width, a.height
    @cairo.fill

    draw_piano(e)
    draw_grid(e)
    draw_notes(e)
    draw_cursor(e)

    @cairo = nil
    #Profiler__.stop_profile
  end

  def draw_grid(e)
    a = allocation

    @cairo.set_line_width(0.5)
    bars = @phrase.pattern.get_size
    (0..bars * 16).each do |x|
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
    (0..128).each do |y|
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
    @phrase.each_pos do |t, event|
      #puts "draw_notes #{t}, #{event}"
      draw_note t, event if event.noteon?
    end
  end

  def draw_note(tick, note)
    # Position of the note in pixels
    x = tick * tick_size + @pianow
    y = (127 - note.data1) * blockh
    # Width and Height of the note in pixels
    w = note.duration * tick_size
    h = blockh

    # FIXME Too much rounded !
    if @roll.selected.include? [tick, note.data1]
      #puts "selected note"
      color.block_selected
    else
      color.block
    end
    @cairo.move_to x + w / 2, y
    @cairo.curve_to x + w, y, x + w, y, x + w, y + h / 2
    @cairo.curve_to x + w, y + h, x + w, y + h, x + w / 2, y + h
    @cairo.curve_to x, y + h, x, y + h, x, y + h / 2
    @cairo.curve_to x, y, x, y, x + w / 2, y
    path = @cairo.copy_path
    @cairo.fill
    @cairo.append_path path
    color.block_border
    @cairo.set_line_width(1)
    @cairo.stroke
  end

  def draw_cursor(e)
    if focus?
      # If there is a mark set, we draw selection region
      # FIXME selection region sometimes misses a line
      if @roll.mark
        color.cursor
        x = @roll.mark[0] * tick_size + @pianow
        y = (127 - @roll.mark[1]) * blockh
        w = @roll.cursor[0] * tick_size - @roll.mark[0] * tick_size
        h = (127 - @roll.cursor[1]) * blockh - (127 - @roll.mark[1]) * blockh + blockh
        @cairo.rectangle x, y, w, h
        @cairo.fill
        color.note_sharp
        @cairo.rectangle x, y, w, h
        @cairo.set_line_width(0.5)
        @cairo.stroke
      end
      color.cursor
      @cairo.rectangle(@roll.cursor[0] * tick_size + @pianow, 0,
                       blockw, allocation.height)
      @cairo.fill
      @cairo.rectangle(0 + @pianow,
                       (127 - @roll.cursor[1]) * blockh,
                       allocation.width, blockh)
      @cairo.fill
      color.note_sharp
      @cairo.move_to(@roll.cursor[0] * tick_size + @pianow,
                     (127 - @roll.cursor[1]) * blockh)
      @cairo.line_to(@roll.cursor[0] * tick_size + @pianow,
                     (127 - @roll.cursor[1] + 1) * blockh)
      @cairo.set_line_width(0.8)
      @cairo.stroke
    end
  end
end


