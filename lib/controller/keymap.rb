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

module KeyMapUSLinux
  def initialize()
    @map = {
      'exclam' => '1',
      'at' => '2',
      'numbersign' => '3',
      'dollar' => '4',
      'percent' => '5',
      'asciicircum' => '6',
      'ampersand' => '7',
      'asterisk' => '8',
      'parenleft' => '9',
      'parenright' => '0',
      'underscore' => 'minus',
      'plus' => 'equal',
      'bar' => 'backslash',
      'braceleft' => 'bracketleft',
      'braceright' => 'bracketright',
      'colon' => 'semicolon',
      'quotedbl' => 'apostrophe',
      'question' => 'slash',
      'greater' => 'period',
      'less' => 'comma',
      'asciitilde' => 'grave',
      'ISO_Left_Tab' => 'Tab'
    }
    @skip = {
      'Control_L' => "C",
      'Control_R' => "rC",
      'Shift_L' => "S",
      'Shift_R' => "rS",
      'Alt_L' => "M",
      'Alt_R' => "rM",
      'Super_L' => "L",
      'Super_R' => "rL"
    }
  end

  def _map(ne)
    kname = Gdk::Keyval.to_name Gdk::Keyval.to_lower ne.keyval
    kname = @map[kname] if @map.has_key? kname
    return "" if @skip.has_key? kname

    kname = "S-" + kname if ne.state & Gdk::Window::SHIFT_MASK != 0
    kname = "L-" + kname if ne.state & Gdk::Window::SUPER_MASK != 0
    kname = "M-" + kname if ne.state & Gdk::Window::MOD1_MASK != 0
    kname = "C-" + kname if ne.state & Gdk::Window::CONTROL_MASK != 0

    kname
  end

end

class KeyMap
  include KeyMapUSLinux

  # This method should return for any key, the lower key that has the
  # same position on an US keyboard.
  def map_key(native_event)
    self._map(native_event)
  end
end
