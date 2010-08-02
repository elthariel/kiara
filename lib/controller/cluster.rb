##
## cluster.rb
## Login : <elthariel@rincevent>
## Started on  Mon Aug  2 01:01:04 2010 elthariel
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

class ClusterController
  include WidgetAwareController

  def initialize(controller)
    @controller = controller

    @focus_list = [:loop, :break, :interrupt]
    @focus = 0

    _create_first_block
  end

  def focus
    return @focus_list[@focus]
  end

  def focus=(name_or_id)
    if name_or_id.class == Symbol
      @focus = @focus_list.index(name_or_id)
    else
      @focus = name_or_id % @focus_list.length
    end
    redraw
  end

  def prev
    @focus = (@focus - 1) % @focus_list.length
  end

  def next
    @focus = (@focus + 1) % @focus_list.length
  end

  def cluster
    case @focus_list[@focus]
      when :loop; @controller.engine.loop
      when :break; @controller.engine.dabreak
      when :interrupt; @controller.engine.interrupt
    end
  end


  protected
  def _create_first_block
    s = self.cluster.get(0)
    b = Kiara::NoteBlock::create
    s.set_note_at(0, b)
    @controller.pianoroll.noteblock = b
  end
end

