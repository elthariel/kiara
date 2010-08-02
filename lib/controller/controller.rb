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

require 'controller/widget_controller'
require 'controller/piano_roll'
require 'controller/cluster'
require 'controller/device'
require 'controller/blockbox'
require 'controller/keymap'
require 'controller/mapping'
require 'controller/mapping_engine'
require 'controller/mapping_context'
require 'controller/save'
require 'controller/mapping_loader'

class Controller
  DEBUG = true

  attr_reader :engine, :context, :pianoroll, :device
  attr_reader :cluser, :blockbox

  def initialize(engine)
    @engine = engine

    @pianoroll = PianoRollController.new(self)
    @device = DeviceController.new(self)
    @cluster = ClusterController.new(self)
    @blockbox = BlockBoxController.new(self)

    @context = MappingContext.new(self)
    @map_engine = MappingEngine.new Mapping.get, self
    @km = KeyMap.new
  end

  # Here we convert Gdk::EventKey structure into our own simpler
  # representation
  def entry_point(native_event)
    @map_engine.event @km.map_key native_event
    true
  end

end
