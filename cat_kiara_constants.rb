#! /usr/bin/env ruby1.9
## cat_kiara_constants.rb
## Login : <elthariel@rincevent>
## Started on  Sun Jul 11 17:08:34 2010 elthariel
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

require 'engine/kiara'

if ARGV[0]
  puts Kiara.const_get(ARGV[0].to_s).instance_methods.sort
else
  Kiara.constants.sort.each do |x|
    puts "#{x} :: #{Kiara.const_get x.to_s}"
  end
end

