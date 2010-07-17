##
## pattern_list.rb
## Login : <elthariel@rincevent>
## Started on  Sun Jul 11 23:42:04 2010 elthariel
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

class PatternList < Gtk::DrawingArea
  include ColorMixin

  attr_reader :height, :width
  attr_accessor :selected

  def initialize(ui, engine)
    super()
    @engine = engine
    @ui = ui

    add_events Gdk::Event::BUTTON_PRESS_MASK
    self.signal_connect('expose-event') {|s, e| on_expose e}
    self.signal_connect('button-press-event') {|s, e| on_click e}
    @selected = 1
    @controller_focus = true

    @height = 24
    @width = 100

    set_size_request(@width, Kiara::KIARA_MAXPATTERNS * @height)
  end

  def selected=(i)
    @selected = i
    full_redraw
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

    @cairo.set_font_size(15)
    @cairo.set_line_width(1)
    (0..Kiara::KIARA_MAXPATTERNS).each do |i|
      color.separator
      if @selected - 1 == i
        @cairo.rectangle(0, i * @height, @width, @height)
        @cairo.fill
      end
      @cairo.move_to 0, i * @height
      @cairo.line_to @width, i * @height
      @cairo.stroke

      color.text
      @cairo.move_to 4, i * @height - 5
      @cairo.text_path "Pattern #{i}"
      @cairo.fill
    end
  end

  def on_click(e)
    selection = (e.y / @height).to_i + 1

    if selection != @selected
      @selected = selection

      a = Gdk::Rectangle.new 0, 0, allocation.width, allocation.height
      window.invalidate a, false
    end

    true
  end

  def full_redraw
    if realized?
      a = Gdk::Rectangle.new 0, 0, allocation.width, allocation.height
      window.invalidate a, false
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

