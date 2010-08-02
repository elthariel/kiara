#! /usr/bin/env ruby1.9
## seq_memory_usage.rb
## Login : <elthariel@rincevent>
## Started on  Wed Jul  7 23:23:08 2010 elthariel
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

pointer = 4
uint32 = 4
midi = 4
flags = 4
ppq = 48
bars = 32
tracks = 16
max_noteblocks = 300
max_events = 10 ** 6

# Event: a pointer + midievent + ?flags
event = pointer + midi + flags
# NoteBlock: pointer * ppq * 4 (using 4/4 signature) * bars
noteblock = pointer * ppq * 4 * bars * tracks

# max_patterns = max_noteblocks / 16

event_mem = event * max_events + max_events * uint32
noteblock_mem = noteblock * max_noteblocks + max_noteblocks * uint32


puts "Architechture: #{pointer * 8}bits."
puts "Midi Event Size: #{midi} bytes."
puts "Flags and other: #{flags} bytes."
puts "PPQ: #{ppq}."
puts "Tracks: #{tracks}"
puts "Max NoteBlocks Bars: #{bars}."
puts "Max NoteBlocks: #{max_noteblocks}."
puts "Max Notes: #{max_events}."
# puts "=> Max Patterns: #{max_patterns}"
puts "--------------------------------------"
puts "Memory Consumption:"
puts "\tNoteBlocks:\t#{noteblock_mem / (1024*1024)} Mb."
puts "\tNotes:\t#{event_mem / (1024*1024)} Mb."
# puts "--------------------------------------"
# puts "--------------  Tests ----------------"
# puts "--------------------------------------"

# newnoteblock = pointer * ppq * 4 * bars * 127
# puts newnoteblock / 1024


