##
## mapping_context.rb
## Login : <elthariel@rincevent>
## Started on  Fri Jul 16 17:21:09 2010 elthariel
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

require 'controller/mapping_context_eval'
require 'controller/pattern_list'
require 'controller/playlist'
require 'controller/piano_roll'


class MappingContext
  include MappingContextEval

  attr_reader :ui, :engine

  def initialize(ui)
    # Reference to god objects
    @ui = ui
    @engine = ui.engine

    # internal state
    @focus_list = [:patterns, :playlist, :pianoroll]
    @controllers = [PatternListController.new(self),
                    PlaylistController.new(self),
                    PianoRollController.new(self)]
    @focus = 0
  end

  def next
    focused.controller_focus = false
    @focus = (@focus + 1) % @focus_list.length
    focused.controller_focus = true
  end

  def prev
    focused.controller_focus = false
    @focus = (@focus - 1) % @focus_list.length
    focused.controller_focus = true
  end

  def focus=(v)
    if v.class == Symbol
      new_focus = @focus_list.index(v) if @focus_list.index(v)
    else
      new_focus = v
    end
    if new_focus and new_focus != @focus
      focused.controller_focus = false
      @focus = new_focus
      focused.controller_focus = true
    end
  end

  def focus
    @focus_list[@focus]
  end

  def focused
    case @focus_list[@focus]
      when :patterns; @ui.patterns
      when :playlist; @ui.playlist
      when :pianoroll; @ui.roll
    end
  end

  def controller
    @controllers[@focus]
  end

  def patterns
    @controllers[0]
  end

  def playlist
    @controllers[1]
  end

  def pianoroll
    @controllers[2]
  end

end
