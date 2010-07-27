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
require 'piano_view'
require 'position_view'
require 'phrase_view'
require 'velocity_view'


class Filler < Gtk::DrawingArea
  def initialize(ui, controller, roll, w, h)
    super()

    @ui = ui
    @controller = controller
    @roll = roll

    set_size_request w, h
  end
end


class PianoRollView
  include PianoRollAttributes

  # Sub-widgets accessors
  attr_reader :piano, :position, :phrase, :velocity
  # Drawing configuration variables, also c.f. PianoRollAttributes
  attr_reader :pianow, :velh, :headh

  def initialize(ui, controller)
    @ui = ui
    @controller = controller

    # Connect to piano roll controller.
    @controller.pianoroll.widget = self
    @rollc = @controller.pianoroll

    # Appearence related variables
    @blockh = 18
    @blockw = 18
    @zoomh = 1.0
    @zoomw = 1.0
    @pianow = 50
    @headh = 15
    @velh = 50

    # Creating all widgets
    @piano = PianoView.new(ui, controller, self)
    @position = PositionView.new(ui, controller, self)
    @phrase = PhraseView.new(ui, controller, self)
    @velocity = VelocityView.new(ui, controller, self)
    @fillers = [Filler.new(ui, controller, self, @pianow, @headh),
                Filler.new(ui, controller, self, @pianow, @velh)]

    # Scroll management
    @old_cursor = [0, 0]

    # Pack everything
    pack_widgets
  end

  def pack_widgets
    # Left part of the piano roll, the piano and the top and bottom fillers
    @ui.builder.o('vbox_piano').pack_start @fillers[0], false
    @ui.builder.o('vbox_piano').pack_start @fillers[1], false
    @ui.builder.o('vp_piano').add @piano
    @ui.builder.o('vbox_piano').reorder_child @ui.builder.o('vp_piano'), 1

    # Right part of the piano roll, the phrase, the velocity view and
    # the header with the positions
    @ui.builder.o('vbox_phrase').pack_start @position, false
    @ui.builder.o('vbox_phrase').pack_start @velocity, false
    @ui.builder.o('vp_phrase').add @phrase
    @ui.builder.o('vbox_phrase').reorder_child @ui.builder.o('vp_phrase'), 1

  end

  def scroll
    cursor = @rollc.cursor
    unless cursor == @old_cursor
      @old_cursor = cursor.clone
      hadj = @ui.builder.o('vp_roll').hadjustment
      vadj = @ui.builder.o('vp_phrase').vadjustment
      vadj_piano = @ui.builder.o('vp_piano').vadjustment

      # Used as reference for horizontal scroll
      allocation_roll = @ui.builder.o('vp_roll').allocation
      # Used as reference for vertical scroll
      allocation_piano = @ui.builder.o('vp_piano').allocation

      # puts "hadj: #{hadj.lower}/#{hadj.value}/#{hadj.upper}"
      # puts "vadj: #{vadj.lower}/#{vadj.value}/#{vadj.upper}"
      # puts "vadj_piano: #{vadj_piano.lower}/#{vadj_piano.value}/#{vadj_piano.upper}"

      # Compute position of the cursor in pixel
      cursor_xpos = cursor[0] * tick_size
      cursor_ypos = (127 - cursor[1]) * blockh

      # puts "scroll #{cursor[0]}, #{cursor[1]} || #{cursor_xpos}, #{cursor_ypos}"
      # puts "alloc_roll: #{allocation_roll.width}x#{allocation_roll.height}"
      # puts "alloc_piano: #{allocation_piano.width}x#{allocation_piano.height}"

      # Limit scroll down to scrollwindow_size - viewport / 2
      # because gtk allows us to scroll below the widget :-/
      if cursor_ypos > vadj.upper - allocation_piano.height / 2
        vadj.value = vadj.upper - allocation_piano.height
        vadj_piano.value = vadj.upper - allocation_piano.height
      else
        vadj.value = cursor_ypos - allocation_piano.height / 2
        vadj_piano.value = cursor_ypos - allocation_piano.height / 2
      end
      if cursor_xpos > hadj.upper - allocation_roll.width / 2
        hadj.value = hadj.upper - allocation_roll.width
      else
        hadj.value = cursor_xpos - allocation_roll.width / 2
      end
    end
  end

  def update_label
    text = "Pattern #{@controller.patterns.selected}, Track #{@roll.track + 1}"
    @ui.builder.o('piano_roll_label').set_text text
  end

  def redraw
    @piano.redraw
    @position.redraw
    @velocity.redraw
    @phrase.redraw
  end

  def focus?
    @controller.context.focus? :pianoroll
  end

end

