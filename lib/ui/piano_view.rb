##
## piano_view.rb
## Login : <elthariel@rincevent>
## Started on  Sun Jul 25 18:45:11 2010 elthariel
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

require 'colors'


class PianoView < Gtk::DrawingArea
  include ColorMixin

  def initialize(ui, controller, roll)
    super()

    @ui = ui
    @controller = controller
    @roll = roll

    set_size_request @roll.pianow, @roll.blockh * 128
    self.signal_connect('expose-event') {|s, e| on_expose e}
  end

  def redraw!
    full_redraw!
   end

  def full_redraw!
    queue_draw if realized?
  end

  def x_to_tick(x)
    (x / tick_size).to_i
  end

  def on_expose(e)
    puts "Unable to create context" unless (@cairo = self.window.create_cairo_context)
    @cairo.rectangle e.area.x, e.area.y, e.area.width, e.area.height
    @cairo.clip

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

      @cairo.rectangle 0, (128 - i - 1) * @roll.blockh, @roll.pianow, @roll.blockh
      @cairo.fill
      @cairo.rectangle 0, (128 - i - 1) * @roll.blockh, @roll.pianow, @roll.blockh
      color.note_sharp
      @cairo.set_line_width 0.5
      @cairo.stroke

      if note_map[i%12] == 1
	color.text_sharp
      else
	color.text
      end
      @cairo.set_font_size 8
      @cairo.move_to 20, (128 - i - 1) * @roll.blockh + 12
      @cairo.text_path "#{note_text[i%12]} #{i/12 - 2}"
      @cairo.fill
    end
  end

end


