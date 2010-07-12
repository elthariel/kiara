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

require 'gtk2'
require 'main_actions'
require 'playlist'
require 'pattern_list'
require 'ui_settings'

class Ui
  include MainActions

  attr_reader :engine, :status, :about, :tools, :playlist
  attr_reader :patterns, :builder

  def initialize(engine)
    @engine = engine
    @builder = Gtk::Builder.new
    # FIXME small hack to shorten code
    @builder.class.instance_eval "alias_method :o, :get_object"
    @builder << 'ui.glade'

    @mw = @builder.o('mainw')
    @status = @builder.o 'statusbar'
    @about = @builder.o 'aboutdialog'
    @tools = @builder.o 'maintoolbar'
    @settings = UiSettings.new(self, @builder.o('settings'))
    @playlist = PlaylistView.new(self, engine)
    @builder.o('vbx_edit').pack_start @playlist
    @builder.o('vbx_edit').reorder_child @playlist, 0
    @patterns = PatternList.new(self, engine)
    @builder.o('scroll_pattern').add_with_viewport @patterns

    Settings.i.init(@ui, @engine)

    connect_signals
  end

  def run
    @mw.show_all
    @status.push 0, "Kiara started !"
    Gtk.main
  end

  def connect_signals
    @mw.signal_connect("destroy") {quit}
    # @builder.o('act_quit').signal_connect('activate') {act_quit}
    # @builder.o('act_about').signal_connect('activate') {act_about}

    @builder.objects.each do |x|
      if x.name[0, 4] == "act_"
        x.signal_connect('activate') { |w| self.send(x.name.to_s, w) }
      end
    end
  end

  def quit
    @engine.stop
    Gtk.main_quit
  end

end



