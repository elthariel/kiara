##
## velocity_view.rb
## Login : <elthariel@rincevent>
## Started on  Sun Jul 25 18:47:34 2010 elthariel
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


class VelocityView < Gtk::DrawingArea
  include ColorMixin

  def initialize(ui, controller, roll)
    super()

    @ui = ui
    @controller = controller
    @roll = roll
    @phrase = @controller.pianoroll.phrase

    psize = @phrase.pattern.get_size
    set_size_request(@roll.blockw * 16 * psize, @roll.velh)

    self.signal_connect('expose-event') {|s, e| on_expose e}
  end

  def redraw
    @phrase = @controller.pianoroll.phrase

    psize = @phrase.pattern.get_size
    set_size_request(@roll.blockw * 16 * psize, @roll.velh)
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
    @phrase = @controller.pianoroll.phrase

    # Background
    color.background unless @roll.focus?
    color.background_focus if @roll.focus?
    @cairo.rectangle 0, 0, a.width, a.height
    @cairo.fill

    # Grid
    @cairo.set_line_width(0.5)
    (0..(@phrase.pattern.get_size * 4)).each do |beat|
      @cairo.move_to beat * @roll.blockw * 4, 0
      @cairo.line_to beat * @roll.blockw * 4, a.height
      if beat % 4 == 0
        color.vgrid_high
      else
        color.vgrid_low unless beat % 4 == 0
      end
      @cairo.stroke
    end

    @cairo.set_line_width(2)
    @cairo.move_to 0, 0
    @cairo.line_to a.width, 0
    color.separator
    @cairo.stroke

    @phrase.each_pos do |tick, event|
      draw_velocity_bar(a, tick, event)
    end
  end

  def draw_velocity_bar(a, tick, event)
    if event.noteon?
      @cairo.set_line_width 0.8
      @cairo.move_to tick * @roll.tick_size, a.height
      @cairo.line_to tick * @roll.tick_size, a.height - a.height * (event.data2 / 127.0)
      color.block
      @cairo.stroke
    end
  end

end

