##
## colors.rb
## Login : <elthariel@rincevent>
## Started on  Sun Jul 11 19:50:18 2010 elthariel
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

class Color
  def self.background(context)
    self.color context, "1a1a2e"
  end

  def self.header(context)
    self.color context, "494863"
  end

  def self.separator(context)
    self.color context, "6d3811"
  end

  def self.header_grid_high(context)
    self.color context, "d2691b90"
  end

  def self.header_grid_low(context)
    self.color context, "9b4f1890"
  end

  def self.vgrid_high(context)
    self.color context, "d2691b90"
  end

  def self.vgrid_low(context)
    self.color context, "9b4f1890"
  end

  def self.hgrid(context)
    self.color context, "554b44"
  end

  def self.separator(context)
    self.color context, "6d3811"
  end

  def self.playbar(context)
    self.color context, "cb0000"
  end

  def self.text(context)
    self.color context, "a6a6a6"
  end

  def self.block(context)
    self.color context, "940374"
  end

  def self.block_border(context)
    self.color context, "720c5b"
  end

  def self.color(context, color)
    if color.size == 8
      alpha = color[6, 2].to_i(16) / 255.0
    else
      alpha = 1.0
    end
    red = color[0, 2].to_i(16) / 255.0
    green = color[2, 2].to_i(16) / 255.0
    blue = color[4, 2].to_i(16) / 255.0

    #puts "Color is #{red}:#{green}:#{blue}:#{alpha}"
    context.set_source_rgba red, green, blue, alpha
  end
end
