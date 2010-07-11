##
## ui.rb
## Login : <elthariel@rincevent>
## Started on  Sun Jul 11 15:21:29 2010 elthariel
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

class Ui
  def initialize(engine)
    @engine = engine
    @builder = Gtk::Builder.new
    @builder << 'ui.glade'

    @mw = @builder.get_object('maiw')
    # @playlist = UiPlaylist.new(@builder)
    # @settings = UiSettings.new(@builder)

    connect_signals
  end

  def run
    @mw.show_all
    Gtk.main
  end

  def connect_signals
    @mw.signal_connect("destroy") do
      @engine.stop
      Gtk.main_quit
    end
    # @builder.get_object('settings_button').signal_connect('clicked') {@settings.run}
    @builder.get_object('about_button').signal_connect('clicked') do
      @builder.get_object('about').run
      @builder.get_object('about').hide
    end
  end
end



