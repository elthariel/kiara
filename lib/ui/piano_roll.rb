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

  attr_reader :selected, :cursor

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

  def cursor=(a)
    @cursor = a
    full_redraw
  end

  def update_label
    text = "Pattern #{@pattern}, Phrase #{@phrase}"
    @ui.builder.o('piano_roll_label').set_text text
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
      @cairo.move_to 20, (128 - i - 1) * blockh + 11
      @cairo.text_path "#{note_text[i%12]} #{i/12 - 2}"
      @cairo.fill
    end
  end

  def draw_notes(e)
    ticks = Kiara::KIARA_PPQ * 4 * pattern.get_size

    (0..ticks).each do |t|
      event = phrase.get(t)
      while event && event.is_noteon do
        draw_note(t, event)
        event = event.next
      end
    end
  end

  def draw_note(tick, note)
    pos_x = tick * tick_size + @pianow

    color.block

# try to do something like this :
#		1'	   2'
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
#<<<<<<< Updated upstream:lib/ui/piano_roll.rb
#    @cairo.stroke
#=======
    @cairo.stroke
#>>>>>>> Stashed changes:lib/ui/piano_roll.rb
#	@cairo.close_path();
  end

  def controller_focus?
    @controller_focus
  end

  def controller_focus=(focused)
    @controller_focus = focused
    full_redraw
  end

end


