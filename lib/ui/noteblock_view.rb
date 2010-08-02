##
## noteblock_view.rb
## Login : <elthariel@rincevent>
## Started on  Sun Jul 25 18:46:31 2010 elthariel
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

class NoteBlockView < Gtk::DrawingArea
  include ColorMixin

  def initialize(ui, controller, roll)
    super()

    @ui = ui
    @controller = controller
    @roll = roll
    @rollc = controller.pianoroll
    @noteblock = @controller.pianoroll.noteblock

    psize = @noteblock.length
    set_size_request(@roll.blockw * 16 * psize, @roll.blockh * 128)

    self.signal_connect('expose-event') {|s, e| on_expose e}
    self.signal_connect('realize') {|s, e| roll.scroll}
  end

  def redraw
    @noteblock = @controller.pianoroll.noteblock

    psize = @noteblock.length
    set_size_request(@roll.blockw * 16 * psize, @roll.blockh * 128)

    full_redraw
  end

  def full_redraw
    queue_draw if realized?
  end

  def on_expose(e)
    a = allocation
    puts "Unable to create context" unless (@cairo = self.window.create_cairo_context)
    @cairo.rectangle e.area.x, e.area.y, e.area.width, e.area.height
    @cairo.clip

    # FIXME
    # Optimize this ! Cache values or implement observer
    @noteblock = @controller.pianoroll.noteblock

    # Background
    color.background unless @roll.focus?
    color.background_focus if @roll.focus?
    @cairo.rectangle 0, 0, a.width, a.height
    @cairo.fill

    draw_grid(e)
    draw_notes(e)
    draw_cursor(e)

    @cairo = nil
  end

  def draw_grid(e)
    a = allocation

    @cairo.set_line_width(0.5)
    bars = @noteblock.length
    (0..bars * 16).each do |x|
      if x % 4 == 0
        color.vgrid_high
      else
        color.vgrid_low
      end
      @cairo.move_to x * @roll.blockw, 0
      @cairo.line_to x * @roll.blockw, a.height
      @cairo.stroke
    end

    @cairo.set_line_width(0.5)
    color.hgrid
    (0..128).each do |y|
      @cairo.move_to 0, y * @roll.blockh
      @cairo.line_to a.width, y * @roll.blockh
      @cairo.stroke
    end
  end

  def draw_notes(e)
    @noteblock.each_pos do |t, event|
      #puts "draw_notes #{t}, #{event}"
      draw_note t, event if event.noteon?
    end
  end

  def draw_note(tick, note)
    # Position of the note in pixels
    x = tick * @roll.tick_size
    y = (127 - note.data1) * @roll.blockh
    # Width and Height of the note in pixels
    w = note.duration * @roll.tick_size
    h = @roll.blockh
    velocity_scale = note.data2 / 127.0

    # FIXME Too much rounded !
    if @rollc.selected.include? [tick, note.data1]
      #puts "selected note"
      color.block_selected velocity_scale
    else
      color.block velocity_scale
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
    if @roll.focus?
      # If there is a mark set, we draw selection region
      # FIXME selection region sometimes misses a line
      if @rollc.mark
        color.cursor
        x = @rollc.mark[0] * @roll.tick_size
        y = (127 - @rollc.mark[1]) * @roll.blockh
        w = @rollc.cursor[0] * @roll.tick_size - @rollc.mark[0] * @roll.tick_size
        h = (127 - @rollc.cursor[1]) * @roll.blockh - (127 - @rollc.mark[1]) * @roll.blockh + @roll.blockh
        @cairo.rectangle x, y, w, h
        @cairo.fill
        color.note_sharp
        @cairo.rectangle x, y, w, h
        @cairo.set_line_width(0.5)
        @cairo.stroke
      end
      color.cursor
      @cairo.rectangle(@rollc.cursor[0] * @roll.tick_size, 0,
                       @roll.blockw, allocation.height)
      @cairo.fill
      @cairo.rectangle(0, (127 - @rollc.cursor[1]) * @roll.blockh,
                       allocation.width, @roll.blockh)
      @cairo.fill
      color.note_sharp
      @cairo.move_to(@rollc.cursor[0] * @roll.tick_size,
                     (127 - @rollc.cursor[1]) * @roll.blockh)
      @cairo.line_to(@rollc.cursor[0] * @roll.tick_size,
                     (127 - @rollc.cursor[1] + 1) * @roll.blockh)
      @cairo.set_line_width(0.8)
      @cairo.stroke
    end
  end

end

