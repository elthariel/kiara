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

module ColorMixin

def initialize(*args)
  def color
    @__color
  end

  @__color = Color.new(self)
  super
end

class Color
  def initialize(mod)
    @mod = mod
  end

  def context
    # FIXME this break encapsulation
    @mod.instance_variable_get :@cairo
  end

  def method_missing(sym, *args, &block)
    if Settings.i.colors.has_key? sym.to_s
      color Settings.i.colors[sym.to_s]
    else
      raise "Colors: Method (or color) missing"
    end
  end

  def color(a_color)
    if a_color.size == 8
      alpha = a_color[6, 2].to_i(16) / 255.0
    else
      alpha = 1.0
    end
    red = a_color[0, 2].to_i(16) / 255.0
    green = a_color[2, 2].to_i(16) / 255.0
    blue = a_color[4, 2].to_i(16) / 255.0

    #puts "Color on #{context} ## #{red}:#{green}:#{blue}:#{alpha}"
    context.set_source_rgba red, green, blue, alpha
  end
end

end

