##
## mapping_context_eval.rb
## Login : <elthariel@rincevent>
## Started on  Fri Jul 16 17:22:16 2010 elthariel
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

module MappingContextEval
  def valid_context?(node)
    puts "#{self} valid_context?"
    if node.has_key? :context
      # FIXME should truly validate_context
      puts "not evaluating existing context"
      true
    else
      true
    end
  end
end

