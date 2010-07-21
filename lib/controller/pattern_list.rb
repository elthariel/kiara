##
## pattern_list.rb
## Login : <elthariel@rincevent>
## Started on  Fri Jul 16 23:33:38 2010 elthariel
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

class PatternListController
  include WidgetAwareController

  attr_reader :selected

  def initialize(controller)
    @controller = controller
    @selected = 1
  end

  def next(i = 1)
    self.selected = self.selected + i
  end

  def prev(i = 1)
    self.selected = self.selected - i
  end

  def size(pattern_id)
    Kiara::Memory.pattern.get(pattern_id).get_size
  end

  def selected_size
    self.size(@selected)
  end

  def set_size(pattern_id, new_size)
    Kiara::Memory.pattern.get(pattern_id).set_size(new_size)
  end

  def selected_size=(new_size)
    self.set_size(@selected, new_size)
  end


  def selected=(pattern_id)
    unless pattern_id == @selected
      pattern_id = Kiara::KIARA_MAXPATTERNS if pattern_id >= Kiara::KIARA_MAXPATTERNS
      pattern_id = 1 if pattern_id < 1
      puts pattern_id
      @selected = pattern_id
      @controller.pianoroll.pattern = @selected
      @controller.pianoroll.redraw
      redraw
    end
  end
end
