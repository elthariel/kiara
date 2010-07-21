#! /usr/bin/env ruby1.9
## kiara.rb
## Login : <elthariel@rincevent>
## Started on  Sun Jul 11 15:06:33 2010 elthariel
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

KIARA_ROOT = File.dirname(File.expand_path(__FILE__))
$:.unshift KIARA_ROOT + '/lib'
$:.unshift KIARA_ROOT + '/lib/ui'
# This is where you'll find the keyboards mappings
$:.unshift KIARA_ROOT + '/mappings'

puts KIARA_ROOT

require 'logger'

require 'settings'
require 'engine/kiara'
require 'controller/controller'
require 'ui'

Settings.i
$log = Logger.new(STDOUT)
$log.progname = 'kiara'
# FIXME $log.level = Logger.const_get Settings.i.loglevel.to_s
$log.level = Logger::DEBUG

engine = Kiara::Engine.new
controller = Controller.new(engine)
ui = Ui.new(controller)

Signal.trap('SIGINT') do
  engine.stop
  exit 0
end

# FIXME REFACTOR
Settings.i.init(ui, controller, engine)

engine.start
ui.run

