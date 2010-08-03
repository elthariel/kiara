##
## cluster_view.rb
## Login : <elthariel@rincevent>
## Started on  Mon Aug  2 14:24:17 2010 elthariel
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

class ClusterView < Gtk::DrawingArea
  include ColorMixin

  def initialize(ui, controller)
    super()

    @ui = ui
    @controller = controller
    @clusterc = controller.cluster
    @cluster = @clusterc.cluster

    # Graphical configuration
    @nblockh = 25
    @cblockh = 15
    @blockh = Kiara::CURVE_POLY * @cblockh + @nblockh
    @blockw = 60

    set_size_request @blockw * @cluster.length, @blockh * Kiara::CHANNELS

    @clusterc.widget = self

    self.signal_connect('expose-event') {|s, e| on_expose e}
  end

  def focus?
    @controller.context.focus? :cluster
  end

  def focus!
    @ui.focus! :cluster
  end

  def redraw!
    queue_draw if realized?
  end

  def on_expose(e)
    a = allocation
    puts "Unable to create context" unless (@cairo = self.window.create_cairo_context)
    @cairo.rectangle e.area.x, e.area.y, e.area.width, e.area.height
    @cairo.clip

    # FIXME
    # Optimize this ! Cache values or implement observer
    @cluster = @clusterc.cluster

    # Background
    color.background unless focus?
    color.background_focus if focus?
    @cairo.rectangle 0, 0, a.width, a.height
    @cairo.fill

    draw_grid
    draw_blocks
  end

  def draw_grid
    a = allocation

    (0...Kiara::CHANNELS).each do |chan|
      @cairo.move_to 0, chan * @blockh
      @cairo.line_to @blockw * @cluster.length, chan * @blockh
      @cairo.set_line_width 1
      color.hgrid
      @cairo.stroke
      (0...Kiara::CURVE_POLY).each do |curve|
        @cairo.move_to 0, chan * @blockh + @nblockh + curve * @cblockh
        @cairo.line_to(@blockw * @cluster.length,
                        chan * @blockh + @nblockh + curve * @cblockh)
        @cairo.set_line_width 0.5
        color.hgrid
        @cairo.stroke
      end
    end

    @cairo.set_line_width 0.5
    (0..@cluster.length).each do |bar|
      color.vgrid_high if bar % 4 == 0
      color.vgrid_low unless bar % 4 == 0

      @cairo.move_to bar * @blockw, 0
      @cairo.line_to bar * @blockw, a.height
      @cairo.stroke
    end
  end

  def draw_blocks
    (0..@cluster.length).each do |bar|
      sector = @cluster.get(bar)
      (0...Kiara::CHANNELS).each do |chan|
        if (block = sector.get_note_at(chan)).valid?
          draw_noteblock bar, chan, block.length
        end

        (0...Kiara::CURVE_POLY).each do |curve|
          if (block = sector.get_curve_at(chan, curve)).valid?
            draw_curveblock bar, chan, curve, block.length
          end
        end
      end
    end
  end

  def draw_noteblock(bar, chan, len)
    x = bar * @blockw
    y = chan * @blockh
    w = len * @blockw

    color.block
    @cairo.rectangle x, y, w, @nblockh
    @cairo.fill
    color.block_border
    @cairo.rectangle x, y, w, @nblockh
    @cairo.stroke
  end

  def draw_curveblock(bar, chan, curve_idx, len)
    puts "FXME Should draw CurveBlock"
  end

end


