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
  def initialize(context)
    @context = context
    @roll_ui = context.ui.roll
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

end

