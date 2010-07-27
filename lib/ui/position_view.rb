##
## position_view.rb
## Login : <elthariel@rincevent>
## Started on  Sun Jul 25 18:46:08 2010 elthariel
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


class PositionView < Gtk::DrawingArea
  include ColorMixin

  def initialize(ui, controller, roll)
    super()

    @ui = ui
    @controller = controller
    @roll = roll
    @phrase = @controller.pianoroll.phrase

    psize = @phrase.pattern.get_size
    set_size_request(@roll.blockw * 16 * psize, @roll.headh)

    self.signal_connect('expose-event') {|s, e| on_expose e}
  end

  def redraw
    @phrase = @controller.pianoroll.phrase

    psize = @phrase.pattern.get_size
    set_size_request(@roll.blockw * 16 * psize, @roll.headh)
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
    @cairo.set_line_width(0.7)
    (0..(@phrase.pattern.get_size * 4)).each do |beat|
      @cairo.move_to beat * @roll.blockw * 4, 0
      @cairo.line_to beat * @roll.blockw * 4, a.height
      if beat % 4 == 0
        color.vgrid_high
      else
        color.vgrid_low unless beat % 4 == 0
      end
      @cairo.stroke

      if beat % 4 == 0
        @cairo.move_to beat * @roll.blockw * 4 + 4, a.height - 4
        @cairo.text_path "#{beat / 4 + 1}"
        color.text
        @cairo.fill
      end
    end

    @cairo.set_line_width(2)
    @cairo.move_to 0, a.height
    @cairo.line_to a.width, a.height
    color.separator
    @cairo.stroke
  end

end

