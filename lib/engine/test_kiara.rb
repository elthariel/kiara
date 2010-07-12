#! /usr/bin/env ruby1.9
## test_kiara.rb
## Login : <elthariel@rincevent>
## Started on  Thu Jul  8 00:31:57 2010 elthariel
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

require 'kiara'

#puts Kiara.constants
#puts Kiara::Engine.class

engine = Kiara::Engine.new
#gets
engine.start

Signal.trap('SIGINT') do
  engine.stop
  exit 0
end

puts engine.scheduler.methods.sort;
#puts engine.methods.sort
#puts engine.playlist.connect

i = 0
while (d = Kiara::Pm_GetDeviceInfo(i))
  puts "#{d.interf}: #{d.name}"
  puts " => in(#{d.input}),out(#{d.output})"
  i += 1
end

while (true) do
  sleep 10
end

