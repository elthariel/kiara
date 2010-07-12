##
## ui_settings.rb
## Login : <elthariel@rincevent>
## Started on  Mon Jul 12 01:24:13 2010 elthariel
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
require 'settings'

class UiSettings
  attr_reader :dialog

  def initialize(ui, dialog)
    @ui = ui
    @dialog = dialog
    @midi_out = Gtk::ComboBox.new

    box = @ui.builder.o('set_midi_out_box')
    box.pack_start @midi_out

    widgets_init
  end

  def widgets_init
    i = 0

    while (info = Kiara.Pm_GetDeviceInfo i)
      if info.output == 1
        puts "#{i}:#{info.interf} #{info.name}"
        @midi_out.append_text "#{i}:#{info.interf} #{info.name}"
      end
      i += 1
    end
  end

  def run
    load
    @dialog.show_all
    @dialog.run do |response|
      case response
      when 1
        save
      end
      @dialog.hide
    end
  end

  def load
    @midi_out.active = find_midi_out
  end

  def save
    Settings.i.midi_out = @midi_out.active_text.to_i
    Settings.i.save
  end

  def find_midi_out
    i = 0
    @midi_out.model.each do |x, y, z|
      break if z[0].to_i == Settings.i.midi_out
      i += 1
    end
    i
  end

end

