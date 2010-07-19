##
## piano_roll.rb
## Login : <elthariel@rincevent>
## Started on  Sat Jul 17 18:49:03 2010 elthariel
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

require 'controller/phrase'

class PianoRollController
  attr_reader :mark

  def initialize(context)
    @context = context
    @roll_ui = context.ui.roll
    @mark = cursor
  end

  def redraw
    @roll_ui.redraw
  end

  def cursor
    @roll_ui.cursor
  end

  def cursor=(a)
    a[0] = 0 if a[0] < 0
    a[1] = 0 if a[1] < 0
    if a[0] >= Kiara::Memory.pattern.get(@context.patterns.selected).get_size * Kiara::KIARA_PPQ * 4
    a[0] = Kiara::Memory.pattern.get(@context.patterns.selected).get_size * Kiara::KIARA_PPQ * 4 - 1
    end
    a[1] = 127 if a[1] > 127
    @roll_ui.cursor = a
  end

  def selected_phrase
    @roll_ui.phrase
  end

  def selected_phrase=(id)
    id = 0 if id < 0
    id = Kiara::KIARA_TRACKS - 1 if id >= Kiara::KIARA_TRACKS
    @roll_ui.phrase = id
  end

  # Create and return a phrase controller for the specified phrase and pattern
  # When a parameter is nil, the current selected item is used
  def phrase(pattern = nil, phrase_id = nil)
    pattern = @context.patterns.selected unless pattern
    phrase_id = selected_phrase unless phrase_id
    PhraseController.new(@context, pattern, phrase_id)
  end

end

