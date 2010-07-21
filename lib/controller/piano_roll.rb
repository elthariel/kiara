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
  include WidgetAwareController

  attr_reader :track, :mark, :selected

  def initialize(controller)
    @controller = controller

    # [x, y], i.e. [tick, note]
    @cursor = [0, 63]
    @selected = []
    # same as cursor
    @track = 0
    @mark = nil
  end

  def cursor=(a)
    a[0] = 0 if a[0] < 0
    a[1] = 0 if a[1] < 0
    if a[0] >= @controller.patterns.selected_size * Kiara::KIARA_PPQ * 4
    a[0] = @controller.patterns.selected_size * Kiara::KIARA_PPQ * 4 - 1
    end
    a[1] = 127 if a[1] > 127
    @cursor = a
    redraw
    #_update_selection
  end

  def cursor
    @cursor.clone
  end

  def mark_set
    @mark = self.cursor
    redraw
  end

  def mark_reset
    @mark = nil
    redraw
  end

  def track=(id)
    id = 0 if id < 0
    id = Kiara::KIARA_TRACKS - 1 if id >= Kiara::KIARA_TRACKS
    @track = id
    redraw
  end

  # Create and return a phrase controller for the specified phrase and pattern
  # When a parameter is nil, the current selected item is used
  def phrase(pattern = nil, phrase_id = nil)
    pattern = @controller.patterns.selected unless pattern
    phrase_id = track unless phrase_id
    PhraseController.new(@controller, pattern, phrase_id)
  end

  protected
  def selected_update
    p = self.phrase

    p.each_pos do |tick, event|

    end
  end
end

