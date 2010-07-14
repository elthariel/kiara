##
## keymap.rb
## Login : <elthariel@rincevent>
## Started on  Wed Jul 14 03:57:17 2010 elthariel
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

# module KeyMapGdkLinux
#   @@code = {}
#   @@name = {}

#   Gdk::Keyval.constants.each do |k|
#     keyname = k.to_s.gsub("GDK_", "K_")
#     kval = Gdk::Keyval.const_get(k.to_sym)
#     self.const_set keyname.to_sym, kval
#     @@code[keyname] = kval
#     @@name[kval] = keyname
#   end

# end

module KeyMapX86Linux
  @@const_name = {}
  @@name = {}
  @@code = {}
  @@namemap = {
    'Control_L' => "C",
    'Control_R' => "rC",
    'Shift_L' => "S",
    'Shift_R' => "rS",
    'Alt_L' => "M",
    'Alt_R' => "rM",
    'Super_L' => "L",
    'Super_R' => "rL",
  }

  modmap = `xmodmap -pk`.split "\n"
  modmap.each do |line|
    if line =~ /([\d]+)[\s]+0x([\dabcdef]+) \(([\w]+)\)/
      code = $1.to_i
      name = $3

      # Removing ugly X86 prefix
      name.gsub!("XF86", "")
      # Mapping ugly Shift_L to S and other stuff like that
      name = @@namemap[name] if @@namemap.has_key? name


      kconst = "K_" + name
      self.const_set(kconst.to_sym, code) unless @@code[kconst]
      @@const_name[code] = kconst
      @@name[code] = name
      @@code[kconst] = code
    end
  end

end

module KeyMap
  include KeyMapX86Linux

  def KeyMap.kcode
    @@code
  end

  def KeyMap.kname
    @@name
  end

  def KeyMap.kconst
    @@const_name
  end

end
