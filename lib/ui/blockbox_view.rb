##
## blockbox_view.rb
## Login : <elthariel@rincevent>
## Started on  Mon Aug  2 19:45:00 2010 elthariel
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

class BlockBoxView

  def initialize(ui, controller)
    @ui = ui
    @controller = controller
    @blockbox = controller.blockbox
    @blockbox.widget = self

    build
  end

  def build
    @hbox = @ui.builder.o 'hb_blockbox'
    @vbox = Gtk::VBox.new
    @entry = Gtk::Entry.new

    build_tagview
    build_blockview

    @hbox.pack_start @tag_view, false
    @hbox.pack_start @vbox
    @vbox.pack_start @entry, false
    @vbox.pack_start @block_view
  end

  def build_tagview
    @tag_store = Gtk::ListStore.new(String, Integer, String)
    @tag_view = Gtk::TreeView.new(@tag_store)
    r = Gtk::CellRendererText.new
    c = Gtk::TreeViewColumn.new("Tag name", r, :text => 0)
    @tag_view.append_column c
    r = Gtk::CellRendererText.new
    c = Gtk::TreeViewColumn.new("Blocks", r, :text => 1)
    @tag_view.append_column c
  end

  def build_blockview
    @block_store = Gtk::ListStore.new(String, String)
    @block_view = Gtk::TreeView.new(@block_store)
    r = Gtk::CellRendererText.new
    c = Gtk::TreeViewColumn.new("Block uuid", r, :text => 0)
    @block_view.append_column c
    r = Gtk::CellRendererText.new
    c = Gtk::TreeViewColumn.new("Tags and name", r, :text => 1)
    @block_view.append_column c
  end

  def update_tags
    @tag_store.clear
    #iter = @tag_store.append(nil)
    @blockbox.index.tags.each do |tag|
      iter = @tag_store.append
      iter[0] = tag[0]
      iter[1] = tag[1]
      iter[2] = tag[2]
    end
  end

  def focus?
    @controller.context.focus? :blockbox
  end

  def focus!
    @ui.focus! :blockbox
    update_tags
    @entry.grab_focus
  end

  def redraw!
    queue_draw if realized?
  end

end

