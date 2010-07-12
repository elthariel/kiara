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

class PianoRoll < Gtk::DrawingArea
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

    add_events Gdk::Event::BUTTON_PRESS_MASK
    add_events Gdk::Event::BUTTON_RELEASE_MASK
    self.signal_connect('expose-event') {|s, e| on_expose e}
    self.signal_connect('button-press-event') {|s, e| on_clicked e}
  end

  def pattern=(p)
    if p < Kiara::KIARA_MAXPATTERNS
      @pattern = p
      full_redraw
    end
  end

  def phrase=(p)
    if p < Kiara::KIARA_TRACKS
      @phrase = p
      full_redraw
    end
  end

  def phrase
    Kiara::Memory.pattern.get(@pattern).get(@phrase)
  end

  def pattern
    Kiara::Memory.pattern.get(@pattern)
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

  def blockh
    (@blockh * @zoomh).to_i
  end

  def blockw
    (@blockw * @zoomw).to_i
  end

  def zoomh=(z)
    @zoomh = z
    full_redraw
  end

  def zoomw=(z)
    @zoomw = z
    full_redraw
  end

  def tick_size
    block_ticks = Kiara::KIARA_PPQ / 4
    #puts "Block = #{block_ticks} ticks = #{blockw} pixels"
    blockw / block_ticks.to_f
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
    Color.background @cairo
    @cairo.rectangle 0, 0, a.width, a.height
    @cairo.fill

    draw_piano(e)
    draw_grid(e)
    draw_notes(e)
  end

  def draw_grid(e)
    a = allocation

    @cairo.set_line_width(0.7)
    Color.hgrid @cairo
    (1..128).each do |y|
      @cairo.move_to @pianow, y * blockh
      @cairo.line_to a.width, y * blockh
      @cairo.stroke
    end

    @cairo.set_line_width(1)
    bars = Kiara::Memory.pattern.get(@pattern).get_size
    (1.. bars * 16).each do |x|
      if x % 4 == 0
        Color.vgrid_high @cairo
      else
        Color.vgrid_low @cairo
      end
      @cairo.move_to x * blockw + @pianow, 0
      @cairo.line_to x * blockw + @pianow, a.height
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
        Color.note_sharp @cairo
      else
        Color.note @cairo
      end

      @cairo.rectangle 0, (128 - i - 1) * blockh, @pianow, blockh
      @cairo.fill
      @cairo.rectangle 0, (128 - i - 1) * blockh, @pianow, blockh
      Color.note_sharp @cairo
      @cairo.set_line_width 0.5
      @cairo.stroke

      Color.text @cairo
      @cairo.set_font_size 10
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

    Color.block @cairo
    @cairo.rectangle pos_x, (127 - note.data1) * blockw, blockh, note.duration * tick_size
    @cairo.fill
    Color.block_border @cairo
    @cairo.rectangle pos_x, (127 - note.data1) * blockw, blockh, note.duration * tick_size
    @cairo.stroke
  end

  def get_note(e)
    tick = x_to_tick e.x - @pianow
    note = 127 - (e.y / blockh).to_i

    bars = Kiara::Memory.pattern.get(@pattern).get_size
    p = Kiara::Memory.pattern.get(@pattern).get(@phrase)
    p.get_note_on_tick(tick, bars, note)
  end

  def on_clicked(e)
    bars = Kiara::Memory.pattern.get(@pattern).get_size
    tick = (x_to_tick e.x - @pianow)
    tick -= tick % 12
    note = 127 - (e.y / blockh).to_i

    puts "x#{e.x},y#{e.y}"
    puts "Note: #{note}, tick: #{tick}"

    if e.x > @pianow and e.x < bars * 16 * blockw + @pianow
      if e.button == 1
        if !get_note e
          return true unless (event = Kiara::Memory.event.alloc)
          event.reset!
          event.noteon!
          event.data1 = note
          event.data2 = 100
          event.duration = Kiara::KIARA_PPQ / 4
          Kiara::Memory.event.dealloc(event) unless phrase.insert!(tick, event)
          full_redraw
        end
      elsif e.button == 3
        puts "should delete"
      end

    end
    true
  end
end


