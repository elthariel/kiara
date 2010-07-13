##
## playlist.rb
## Login : <elthariel@rincevent>
## Started on  Sun Jul 11 18:49:10 2010 elthariel
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

class PlaylistView < Gtk::DrawingArea
  include ColorMixin

  def initialize(ui, engine)
    super()

    @engine = engine
    @ui = ui
    @playbar_lastpos = 0
    @selected = []
    @head_size = 22

    add_events Gdk::Event::BUTTON_PRESS_MASK
    add_events Gdk::Event::BUTTON_RELEASE_MASK
    self.signal_connect('expose-event') {|s, e| on_expose e}
    self.signal_connect('button-press-event') {|s, e| on_click e}
    Gtk.timeout_add(100) {draw_playing_bar}
  end

  def blockw
    a = allocation
    a.width / Kiara::KIARA_PLSLEN.to_f
  end

  def blockh
    a = allocation
    (a.height - @head_size) / Kiara::KIARA_PLSTRACKS.to_f
  end

  def on_expose(e)
    # Initialization
    a = allocation
    @cairo = self.window.create_cairo_context
    @cairo.rectangle e.area.x, e.area.y, e.area.width, e.area.height
    @cairo.clip

    # Background
    color.background
    @cairo.rectangle 0, 0, a.width, a.height
    @cairo.fill

    # Draw Header
    draw_header a
    # Draw Grid
    draw_grid a
    # Draw Patterns
    draw_patterns a

    # Or we won't get called again iirc.
    true
  end

  def draw_header(a)
    color.header
    @cairo.rectangle(0, 0, a.width, 20)
    @cairo.fill

    color.separator
    @cairo.move_to 0, 21
    @cairo.line_to a.width, 21
    @cairo.stroke

    (1..Kiara::KIARA_PLSLEN).each do |i|
      @cairo.move_to i * blockw, 0
      @cairo.line_to i * blockw, 20
      if i % 4 == 0
        color.header_grid_high
      else
        color.header_grid_low
      end
      @cairo.stroke
    end
  end

  def draw_grid(a)
    (1..Kiara::KIARA_PLSLEN).each do |i|
      @cairo.move_to i * blockw, @head_size
      @cairo.line_to i * blockw, a.height
      if i % 4 == 0
        color.vgrid_high
      else
        color.vgrid_low
      end
      @cairo.stroke
    end

    (1..Kiara::KIARA_PLSTRACKS).each do |i|
      @cairo.move_to 0, i * blockh + @head_size
      @cairo.line_to a.width, i * blockh + @head_size
      color.hgrid
      @cairo.stroke
    end
  end

  def draw_patterns(a)
    (0..Kiara::KIARA_PLSTRACKS).each do |t|
      (0..Kiara::KIARA_PLSLEN).each do |b|
        if (pattern_id = @engine.playlist.get_pos(t, b)) > 0
          pattern = Kiara::Memory.pattern.get(pattern_id)
          @cairo.rectangle(b * blockw, t * blockh + @head_size, pattern.get_size * blockw, blockh)
          color.block
          @cairo.fill
          color.block_border
          @cairo.stroke

          color.text
          @cairo.move_to b * blockw + 3, (t + 1) * blockh + @head_size - 3
          @cairo.set_font_size(11)
          @cairo.text_path "#{pattern_id}"
          @cairo.fill
        end
      end
    end
  end

  def draw_playing_bar
    # Erase the last playbar
    self.window.invalidate(Gdk::Rectangle.new(@playbar_lastpos -5 , 0, 10, self.window.size[1]), true)
    self.window.process_updates(true)

    @cairo = self.window.create_cairo_context
    @cairo.set_antialias Cairo::ANTIALIAS_SUBPIXEL
    pos = @engine.transport.get_position
    max_ticks = Kiara::KIARA_PLSLEN * 4 * Kiara::KIARA_PPQ
    pos_tick = pos.bar * 4 * Kiara::KIARA_PPQ + pos.beat * Kiara::KIARA_PPQ + pos.tick
    pos_x = (pos_tick.to_f / max_ticks) * self.window.size[0]

    color.playbar
    @cairo.move_to pos_x, 0
    @cairo.line_to pos_x, self.window.size[1]
    @cairo.stroke

    @playbar_lastpos = pos_x
    true
  end

  def get_block(e)
    track = ((e.y - @head_size) / blockh).to_i
    bar = (e.x / blockw).to_i

    [track, bar]
  end

  def on_click(e)
    if e.y <= @head_size
      # Clicking on the head bar
      puts "Head bar."
    else
      block = get_block e

      if @engine.playlist.get_pos(block[0], block[1]) == 0 and e.button == 1
        @engine.playlist.set_pos(block[0], block[1], @ui.patterns.selected)
      elsif @engine.playlist.get_pos(block[0], block[1]) > 0 and e.button == 3
        @engine.playlist.set_pos(block[0], block[1], 0)
      end
      # FIXME Handle pattern with more than one bar
      a = Gdk::Rectangle.new 0, 0, allocation.width, allocation.height
      window.invalidate a, false
    end
  end

end

