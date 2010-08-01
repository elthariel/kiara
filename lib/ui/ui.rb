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
require 'ui_settings'
require 'piano_roll'

class Ui
  include MainActions

  attr_reader :status, :about, :tools, :playlist
  attr_reader :patterns, :builder, :controller, :roll

  def initialize(controller)
    @controller = controller

    build
    connect
  end

  def build

    unless RUBY_PLATFORM =~ /mingw|win32/
      Gtk::RC.parse "#{KIARA_ROOT}/gtk-theme/gtk-2.0/gtkrc"
    end
    Gtk.init

    @builder = Gtk::Builder.new
    @builder.class.instance_eval "alias_method :o, :get_object"
    @builder << KIARA_ROOT + '/lib/ui/ui.glade'

    @mw = @builder.o('mainw')
    @about = @builder.o 'aboutdialog'
    @tools = @builder.o 'maintoolbar'
    @settings = UiSettings.new(self, @builder.o('settings'))
    @roll = PianoRollView.new(self, @controller)

    @builder.o('spin_bpm').adjustment = @builder.o('adj_bpm')
    @builder.o('adj_bpm').value = 140
  end

  def run
    @mw.show_all
    Gtk.main
  end

  def connect
    @mw.signal_connect('key-press-event') { |w, e| @controller.entry_point e }
    @mw.signal_connect("destroy") {quit}
    @builder.o('adj_bpm').signal_connect('value-changed') { |w, bpm| act_bpm_changed w}

    @builder.objects.each do |x|
      if x.respond_to? :name and x.name[0, 4] =~ /act_/
        x.signal_connect('activate') { |w| self.send(x.name.to_s, w) }
      end
    end
  end

  def quit
    @controller.engine.stop
    Gtk.main_quit
  end

end



