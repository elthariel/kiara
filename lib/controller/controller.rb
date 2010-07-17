##
## controller.rb
## Login : <elthariel@rincevent>
## Started on  Wed Jul 14 00:49:38 2010 elthariel
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

require 'controller/event'
require 'controller/mapping'
require 'controller/mapping_engine'
require 'controller/mapping_context'
require 'mapping_base'

class Controller
  DEBUG = true

  def initialize(ui)
    @engine = ui.engine
    @ui = ui
    @chain = []

    @context = MappingContext.new(ui)
    @map_engine = MappingEngine.new Mapping.get, @context
  end

  def chain
    str = ""
    @chain.each {|k| str += "#{KeyMap.kname[k.key]}-"}
    str.chop
  end

  def entry_point(native_event)
    e = native_event.to_e
    if e.type == Event::KEY_PRESS
      @chain << e
    elsif e.type == Event::KEY_RELEASE
      @map_engine.event(chain)
      @chain.delete(e)
    end
    true
  end

  def focus_change(e)
    @chain = []
  end

end
