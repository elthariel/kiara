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

require 'controller/mapping'
require 'zlib'

module BaseMapping
  include Mapping

  mapping do
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





    ########################
    #  Pattern list
    ########################

    # Current pattern selection
    on_chain 'Up' do
      if_context :is? => :patterns
      action 'prev-pattern' do |controller|
        controller.patterns.prev
      end
    end
    on_chain 'Down' do
      if_context :is? => :patterns
      action 'next-pattern' do |controller|
        controller.patterns.next
      end
    end
    on_chain 'S-Up' do
      if_context :is? => :patterns
      action 'prev-pattern-10' do |controller|
        controller.patterns.prev(10)
      end
    end
    on_chain 'S-Down' do
      if_context :is? => :patterns
      action 'next-pattern-10' do |controller|
        controller.patterns.next(10)
      end
    end



    # Pattern stacking
    @pattern_stack = []
    on_chain 'C-space' do
      if_context :is? => :patterns
      action 'reset-pattern-stack' do |c|
        @pattern_stack.clear
        puts "Reset pattern stack"
      end
    end
    on_chain 'space' do
      if_context :is? => :patterns
      action 'reset-pattern-stack' do |c|
        @pattern_stack.push c.patterns.selected
        puts "I've stacked a new pattern : #{c.patterns.selected}"
      end
    end







    ########################
    #  Playlist
    ########################

    # Playlist Cursor movement
    on_chain 'Left' do
      if_context :is? => :playlist
      action 'pls-cursor-move-left' do |controller|
        cursor = controller.playlist.cursor
        cursor[0] -= 1
        controller.playlist.cursor = cursor
      end
    end
    on_chain 'Right' do
      if_context :is? => :playlist
      action 'pls-cursor-move-right' do |controller|
        cursor = controller.playlist.cursor
        cursor[0] += 1
        controller.playlist.cursor = cursor
      end
    end
    on_chain 'Up' do
      if_context :is? => :playlist
      action 'pls-cursor-move-up' do |controller|
        cursor = controller.playlist.cursor
        cursor[1] -= 1
        controller.playlist.cursor = cursor
      end
    end
    on_chain 'Down' do
      if_context :is? => :playlist
      action 'pls-cursor-move-down' do |controller|
        cursor = controller.playlist.cursor
        cursor[1] += 1
        controller.playlist.cursor = cursor
      end
    end
    # Playlist fast Cursor movement
    on_chain 'S-Left' do
      if_context :is? => :playlist
      action 'pls-cursor-move-left-fast' do |controller|
        cursor = controller.playlist.cursor
        cursor[0] = cursor[0] - 4 + (cursor[0] - 4) % 4
        controller.playlist.cursor = cursor
      end
    end
    on_chain 'S-Right' do
      if_context :is? => :playlist
      action 'pls-cursor-move-right-fast' do |controller|
        cursor = controller.playlist.cursor
        cursor[0] = cursor[0] + 4 - (cursor[0] + 4) % 4
        controller.playlist.cursor = cursor
      end
    end
    on_chain 'S-Up' do
      if_context :is? => :playlist
      action 'pls-cursor-move-up-fast' do |controller|
        cursor = controller.playlist.cursor
        cursor[1] = cursor[1] - 4 + (cursor[1] - 4) % 4
        #cursor[1] = cursor[1] - 4 + (cursor[1] + 4) % 4
        controller.playlist.cursor = cursor
      end
    end
    on_chain 'S-Down' do
      if_context :is? => :playlist
      action 'pls-cursor-move-down-fast' do |controller|
        cursor = controller.playlist.cursor
        cursor[1] = cursor[1] + 4 - (cursor[1] + 4) % 4
        controller.playlist.cursor = cursor
      end
    end

    # Pattern add
    on_chain 'space' do
      if_context :is? => :playlist
      action 'playlist-add-pattern' do |c|
        if @pattern_stack.length > 0
          @pattern_stack.each do |id|
            c.playlist.add(id)
            cursor = c.playlist.cursor
            cursor[0] += c.patterns.size(id)
            c.playlist.cursor = cursor
          end
        else
          # Only add selected pattern
          c.playlist.add(c.patterns.selected)
          cursor = c.playlist.cursor
          cursor[0] += c.patterns.size(c.patterns.selected)
          c.playlist.cursor = cursor
        end
      end
    end
    on_chain 'C-space' do
      if_context :is? => :playlist
      action 'playlist-remove-pattern' do |c|
        c.playlist.remove
        cursor = c.playlist.cursor
        cursor[0] += 1
        c.playlist.cursor = cursor
      end
    end
    on_chain 'C-S-space' do
      if_context :is? => :playlist
      action 'playlist-remove-pattern-backward' do |c|
        c.playlist.remove
        cursor = c.playlist.cursor
        cursor[0] -= 1
        c.playlist.cursor = cursor
      end
    end







    ########################
    #  PianoRoll
    ########################

    # PianoRoll Reset
    on_chain 'C-g' do
      if_context :is? => :pianoroll
      action 'roll-reset' do |c|
        c.pianoroll.mark_reset
      end
    end
    # PianoRoll Mark set
    on_chain 'C-s' do
      if_context :is? => :pianoroll
      action 'roll-set-mark' do |c|
        c.pianoroll.mark_set
      end
    end
    on_chain 'C-a' do
      if_context :is? => :pianoroll
      action 'roll-select-all' do |c|
        c.pianoroll.select_all
      end
    end
    # PianoRoll Cursor movement
    on_chain 'Up' do
      if_context :is? => :pianoroll
      action 'roll-cursor-up' do |c|
        cursor = c.pianoroll.cursor
        cursor[1] += 1
        c.pianoroll.cursor = cursor
      end
    end
    on_chain 'Down' do
      if_context :is? => :pianoroll
      action 'roll-cursor-down' do |c|
        cursor = c.pianoroll.cursor
        cursor[1] -= 1
        c.pianoroll.cursor = cursor
      end
    end
    on_chain 'Left' do
      if_context :is? => :pianoroll
      action 'roll-cursor-up' do |c|
        cursor = c.pianoroll.cursor
        cursor[0] -= Kiara::KIARA_PPQ / 4
        c.pianoroll.cursor = cursor
      end
    end
    on_chain 'Right' do
      if_context :is? => :pianoroll
      action 'roll-cursor-down' do |c|
        cursor = c.pianoroll.cursor
        cursor[0] += Kiara::KIARA_PPQ / 4
        c.pianoroll.cursor = cursor
      end
    end
    # PianoRoll PRECISE Cursor movement
    on_chain 'M-Left' do
      if_context :is? => :pianoroll
      action 'roll-cursor-up' do |c|
        cursor = c.pianoroll.cursor
        cursor[0] -= 1
        c.pianoroll.cursor = cursor
      end
    end
    on_chain 'M-Right' do
      if_context :is? => :pianoroll
      action 'roll-cursor-down' do |c|
        cursor = c.pianoroll.cursor
        cursor[0] += 1
        c.pianoroll.cursor = cursor
      end
    end
    # PianoRoll FAST Cursor movement
    on_chain 'S-Up' do
      if_context :is? => :pianoroll
      action 'roll-cursor-up' do |c|
        cursor = c.pianoroll.cursor
        cursor[1] += 12
        c.pianoroll.cursor = cursor
      end
    end
    on_chain 'S-Down' do
      if_context :is? => :pianoroll
      action 'roll-cursor-down' do |c|
        cursor = c.pianoroll.cursor
        cursor[1] -= 12
        c.pianoroll.cursor = cursor
      end
    end
    on_chain 'S-Left' do
      if_context :is? => :pianoroll
      action 'roll-cursor-up' do |c|
        cursor = c.pianoroll.cursor
        if cursor[0] % Kiara::KIARA_PPQ == 0
          cursor[0] -= Kiara::KIARA_PPQ
        else
          cursor[0] -= cursor[0] % Kiara::KIARA_PPQ
        end
        c.pianoroll.cursor = cursor
      end
    end
    on_chain 'S-Right' do
      if_context :is? => :pianoroll
      action 'roll-cursor-down' do |c|
        cursor = c.pianoroll.cursor
        cursor[0] += Kiara::KIARA_PPQ
        cursor[0] -= cursor[0] % Kiara::KIARA_PPQ
        c.pianoroll.cursor = cursor
      end
    end
    # PianoRoll Phrase Switch
    on_chain 'Page_Up' do
      if_context :is? => :pianoroll
      action 'phrase-prev' do |c|
        c.pianoroll.track = c.pianoroll.track - 1
      end
    end
    on_chain 'Page_Down' do
      if_context :is? => :pianoroll
      action 'phrase-prev' do |c|
        c.pianoroll.track = c.pianoroll.track + 1
      end
    end
    on_chain 'L-Left' do
      if_context :is? => :pianoroll
      action 'phrase-prev' do |c|
        c.pianoroll.track = c.pianoroll.track - 1
      end
    end
    on_chain 'L-Right' do
      if_context :is? => :pianoroll
      action 'phrase-prev' do |c|
        c.pianoroll.track = c.pianoroll.track + 1
      end
    end
    on_chain 'S-Page_Up' do
      if_context :is? => :pianoroll
      action 'phrase-prev' do |c|
        c.pianoroll.track = c.pianoroll.track - 4
      end
    end
    on_chain 'S-Page_Down' do
      if_context :is? => :pianoroll
      action 'phrase-prev' do |c|
        c.pianoroll.track = c.pianoroll.track + 4
      end
    end





    ########################
    #  Phrase
    ########################
    # Note add
    @@last_note_duration = Kiara::KIARA_PPQ
    @@last_note_velocity = 100
    on_chain 'space' do
      if_context :is? => :pianoroll
      action 'node-add' do |c|
        p = c.pianoroll.phrase
        pos = c.pianoroll.cursor
        unless p.occupied? (pos)
          e = p.alloc_event!
          e.noteon!
          e.chan = p.track_id
          e.data1 = pos[1]
          e.data2 = @@last_note_velocity
          e.duration = @@last_note_duration
          if p.insert! pos[0], e
            c.pianoroll.cursor=[pos[0] + e.duration, pos[1]]
          else
            p.dealloc_event! e
          end
        end
      end
    end
    # Note remove on cursor
    on_chain 'C-space' do
      if_context :is? => :pianoroll
      action 'note-del-at-cursor' do |c|
        p = c.pianoroll.phrase
        pos = c.pianoroll.cursor
        e = p.delete_note_on_tick_overlapping!(pos)
        if e
          c.pianoroll.cursor=[pos[0] + e.duration, pos[1]]
          p.dealloc_event! e
        end
      end
    end
    on_chain 'Delete' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'roll-delete-selected' do |c|
        p = c.pianoroll.phrase
        c.pianoroll.selected.each do |item|
          p.delete_note_on_tick! item[0], item[1]
        end
        c.pianoroll.redraw
      end
    end

    # Step edition
    [[0, '1'], [1, 'q'], [2, '2'], [3, 'w'], [4, '3'], [5, 'e'], [6, '4'], [7, 'r'],
     [8, '5'], [9, 't'], [10, '6'], [11, 'y'], [12, '7'], [13, 'u'], [14, '8'], [15, 'i']].each do |x|
      [[42, 'M-'], [84, ''], [127, 'S-']].each do |power|
        on_chain "#{power[1]}#{x[1]}" do
          if_context :is? => :pianoroll
          action "tr-edit-#{x[0]}" do |c|
            p = c.pianoroll.phrase
            cursor = c.pianoroll.cursor
            bar = (cursor[0] / (Kiara::KIARA_PPQ * 4)) * Kiara::KIARA_PPQ * 4
            pos = [bar + x[0] * (Kiara::KIARA_PPQ / 4), cursor[1]]
            # This checks is there's a note on the "step"
            if (p.occupied? pos)
              e = p.delete_note_on_tick_overlapping! pos
              p.dealloc_event! e
              c.pianoroll.redraw
            else
              e = p.alloc_event!
              e.noteon!
              e.chan = p.track_id
              e.data1 = pos[1]
              e.data2 = power[0]
              e.duration = Kiara::KIARA_PPQ / 4
              p.dealloc_event! e unless p.insert! pos[0], e
              c.pianoroll.redraw
            end
          end
        end
      end
    end

    # Move Note
    on_chain 'C-Up' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'move-note-up' do |c|
        c.pianoroll.move [0, 1]
      end
    end
    on_chain 'C-Down' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'move-note-down' do |c|
        c.pianoroll.move [0, -1]
      end
    end
    on_chain 'C-Left' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'move-note-left' do |c|
        c.pianoroll.move [-Kiara::KIARA_PPQ / 4, 0]
      end
    end
    on_chain 'C-Right' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'move-note-right' do |c|
        c.pianoroll.move [Kiara::KIARA_PPQ / 4, 0]
      end
    end

    # Move note FAST
    on_chain 'C-S-Up' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'move-note-up' do |c|
        c.pianoroll.move [0, 12]
      end
    end
    on_chain 'C-S-Down' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'move-note-down' do |c|
        c.pianoroll.move [0, -12]
      end
    end
    on_chain 'C-S-Left' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'move-note-left' do |c|
        c.pianoroll.move [-Kiara::KIARA_PPQ, 0]
      end
    end
    on_chain 'C-S-Right' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'move-note-right' do |c|
        c.pianoroll.move [Kiara::KIARA_PPQ, 0]
      end
    end

    # Resize notes
    on_chain 'C-L-Up' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'resize-note-left-small' do |c|
        c.pianoroll.resize -1
      end
    end
    on_chain 'C-L-Down' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'resize-note-right-small' do |c|
        c.pianoroll.resize 1
      end
    end
    on_chain 'C-L-Left' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'resize-note-left' do |c|
        c.pianoroll.resize -Kiara::KIARA_PPQ / 4
      end
    end
    on_chain 'C-L-Right' do
      if_context :is? => :pianoroll
      if_context :has_selection? => true
      action 'resize-note-right' do |c|
        c.pianoroll.resize Kiara::KIARA_PPQ / 4
      end
    end




##############################
  end
end


