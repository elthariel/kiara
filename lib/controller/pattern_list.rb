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
  def initialize(context)
    @context = context
  end

  def next(i = 1)
    if @context.ui.patterns.selected + i >= Kiara::KIARA_MAXPATTERNS
      @context.ui.patterns.selected = Kiara::KIARA_MAXPATTERNS
    else
      @context.ui.patterns.selected = @context.ui.patterns.selected + i
    end
    @context.ui.roll.pattern = @context.ui.patterns.selected
  end

  def prev(i = 1)
    if @context.ui.patterns.selected - i < 1
      @context.ui.patterns.selected = 1
    else
      @context.ui.patterns.selected = @context.ui.patterns.selected - i
    end
    @context.ui.roll.pattern = @context.ui.patterns.selected
  end
end
