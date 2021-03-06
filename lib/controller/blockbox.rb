##
## blockbox.rb
## Login : <elthariel@rincevent>
## Started on  Mon Aug  2 01:02:47 2010 elthariel
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

require 'controller/blockbox_storage'
require 'controller/blockbox_indexer'

class BlockBoxController
  include WidgetAwareController

  attr_reader :storage, :index

  def initialize(controller)
    @controller = controller
    @storage = BlockBox::Storage.new
    @index = BlockBox::Index.new
  end

end

