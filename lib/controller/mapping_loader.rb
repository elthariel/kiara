##
## mapping_loader.rb
## Login : <elthariel@rincevent>
## Started on  Thu Jul 22 06:06:17 2010 elthariel
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

#
# This is kind of a temporary solution waiting for a proper
# implementation of a deep merge algorithm for 'ASTs' of
# different mapping module
#

module MappingLoader
  include Mapping

  puts "Will load mappings"
  mapping do
    Dir.glob("#{KIARA_ROOT}/mappings/*.rb").each do |file|
      puts "Loading a mapping: #{file} ..."
      File.open(file, 'r') do |fh|
        lines = fh.readlines
        module_eval lines.join, file
      end
    end
  end
end


