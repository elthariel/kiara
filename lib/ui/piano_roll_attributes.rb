##
## piano_roll_attributes.rb
## Login : <elthariel@rincevent>
## Started on  Tue Jul 13 00:05:26 2010 elthariel
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

module PianoRollAttributes

  attr_reader :zoomh, :zoomw

  def phrase
    Kiara::Memory.pattern.get(@pattern).get(@phrase)
  end

  def pattern
    Kiara::Memory.pattern.get(@pattern)
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

end


