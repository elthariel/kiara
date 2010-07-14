##
## event.rb
## Login : <elthariel@rincevent>
## Started on  Wed Jul 14 02:55:21 2010 elthariel
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

require 'controller/keymap'

class Event
  @@event_prototype = {
    :type => nil,
    :key => nil,
  }

  KEY_PRESS = 0
  KEY_RELEASE = 1
  MIDI = 2 # Unused

  def initialize(params = {})
    @data = params.merge(@@event_prototype)
  end

  def has_key? key
    @data.has_key? key
  end

  def method_missing(sym, *args, &block)
    var_name = sym.to_s.gsub('=','').to_sym
    if @data.has_key? var_name
      if sym.to_s =~ /=\Z/
          @data[var_name] = args[0]
      else
        @data[sym]
      end
    else
      raise NoMethodError
    end
  end

  def to_s
    tmap = ["KEY_PRESS", "KEY_RELEASE", "MIDI"]
    etype = tmap[type]
    str = "Event(#{etype}): "
    str += KeyMap.kconst[key]
    str
  end

  def name
    KeyMap.name[key]
  end

  def ==(other)
    key == other.key
  end

  def ===(other)
    type == other.type and key == other.key
  end
end

class Gdk::EventKey
  def to_e
    e = Event.new
    if event_type == KEY_RELEASE
      e.type = ::Event::KEY_RELEASE
    else
      e.type = ::Event::KEY_PRESS
    end
    e.key = hardware_keycode
    e
  end
end

class EventChain
end

