##
## test_mapping.rb
## Login : <elthariel@rincevent>
## Started on  Wed Jul 14 16:46:40 2010 elthariel
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

require 'zlib'

########################
#  GLOBAL
########################
# Context/Focus Switching
on_chain 'C-Tab' do
  action 'focus-next' do |controller|
    controller.context.next
  end
end
on_chain 'C-S-Tab' do
  action 'focus-prev' do |controller|
    controller.context.prev
  end
end
on_chain 'L-Up' do
  action 'prev-pattern' do |c|
    c.patterns.prev
  end
end
on_chain 'L-Down' do
  action 'next-pattern' do |c|
    c.patterns.next
  end
end

# File Management and stuff like that
on_chain 'C-x' do
  on_chain 'C-s' do
    action 'save' do |c|
      dialog = Gtk::FileChooserDialog.new("Open Kiara Project...", @mw,
                                          Gtk::FileChooser::ACTION_SAVE, nil,
                                          [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
                                          [Gtk::Stock::SAVE, Gtk::Dialog::RESPONSE_ACCEPT])
      filter = Gtk::FileFilter.new
      filter.name = "Kiara Projects"
      filter.add_pattern("*.kseq")
      dialog.add_filter filter
      if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
        filename = dialog.filename
        filename += ".kseq" unless filename =~ /.kseq\Z/

        File.open(filename, "w") do |f|
          puts "Saving to #{filename}"
          zf = Zlib::GzipWriter.new(f, 3, 0)
          zf << c.engine.to_yaml
          zf.close
        end
      end
      dialog.destroy
    end
  end
  on_chain 'C-f' do
    action 'open' do |c|
      dialog = Gtk::FileChooserDialog.new("Open Kiara Project...", @mw,
                                          Gtk::FileChooser::ACTION_OPEN, nil,
                                          [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
                                          [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT])
      filter = Gtk::FileFilter.new
      filter.name = "Kiara Projects"
      filter.add_pattern("*.kseq")
      dialog.add_filter filter
      if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
        filename = dialog.filename
        puts "filename = #{filename}"
        Zlib::GzipReader.open(filename) do |zf|
          puts "Saving to #{filename}"
          c.engine.from_yaml zf
          c.pianoroll.redraw
          c.playlist.redraw
        end
      end
      dialog.destroy
    end
  end
end


