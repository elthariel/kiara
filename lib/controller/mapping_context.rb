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

class MappingContext
  include MappingContextEval

  attr_reader :controller

  def initialize(controller)
    # Reference to Controllers container
    @controller = controller

    # internal state
    @focus_list = [:pianoroll, :cluster, :blockbox]
    @focus = 0
  end

  alias :c :controller

  def next
    self.focus = (@focus + 1) % @focus_list.length
  end

  def prev
    self.focus = (@focus - 1) % @focus_list.length
  end

  def focus=(v)
    if v.class == Symbol
      new_focus = @focus_list.index(v) if @focus_list.include? v
    else
      new_focus = v
    end
    if new_focus and new_focus != @focus
      old_focused = focused
      @focus = new_focus
      #old_focused.redraw!
      #focused.redraw!
      focused.focus!
    end
  end

  def focus
    @focus_list[@focus]
  end

  def focus?(sym)
    sym == focus
  end

  def focused
    case @focus_list[@focus]
      when :pianoroll; @controller.pianoroll
      when :cluster; @controller.cluster
      when :blockbox; @controller.blockbox
    end
  end

end
