##
## main_actions.rb
## Login : <elthariel@rincevent>
## Started on  Sun Jul 11 16:43:39 2010 elthariel
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

module MainActions

  def act_notimpl(w)
    puts "Not Implemented."
  end

  def act_about(w)
    @about.run
    @about.hide
  end

  def act_quit(w)
    quit
  end

  def act_play(w)
    @engine.transport.start
  end

  def act_pause(w)
    @engine.transport.pause
  end

  def act_stop(w)
    @engine.transport.stop
  end

  def act_loop(w)
    toogle = @builder.get_object('toolloop')
    @engine.transport.loop(toogle.active?)
  end

  def act_settings(w)
    @settings.run
  end

  def act_set_ok(w)
  end

  def act_set_cancel(w)
  end


  def act_(w)
  end


end

