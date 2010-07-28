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
  def add_color(name, value)
    if value.size == 8
      alpha = value[6, 2].to_i(16) / 255.0
    else
      alpha = 1.0
    end
    red = value[0, 2].to_i(16) / 255.0
    green = value[2, 2].to_i(16) / 255.0
    blue = value[4, 2].to_i(16) / 255.0
    eval "def self.#{name} (alpha_scale = 1.0, color_scale = 1.0)
      @mod.instance_variable_get(:@cairo).set_source_rgba(#{red} * color_scale,
                                                          #{green} * color_scale,
                                                          #{blue} * color_scale,
                                                          #{alpha} * alpha_scale)
    end"
  end

  def initialize(mod)
    @mod = mod

    ktheme = KIARA_THEME + Settings.i.theme + '.ktheme'
    if File.readable? ktheme and (parsed_theme = YAML.load_file ktheme) and parsed_theme['version'] == 0
      parsed_theme['colors'].each { |name, hexvalue| add_color name, hexvalue }
    end
  end

  def method_missing(sym, *args, &block)
    puts "Theme Error: Unknown color"
    @mod.instance_variable_get(:@cairo).set_source_rgba 1.0, 0.5, 0.5, 1
  end
end

end

