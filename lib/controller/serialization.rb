##
## save.rb
## Login : <elthariel@rincevent>
## Started on  Mon Jul 19 08:41:59 2010 elthariel
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

require 'yaml'

# Load/Save Implementation is based on the amazingly simple to use
# YAML serialization/deserialization library. All the saved data are
# converted to arrays or hashes, converted to yaml and written
# compressed.

class Kiara::Event
  # Return a array representing the Event. It's self describing
  def to_a
    [
     status,
     data1,
     data2,
     flags,
     duration
    ]
  end

  def from_a(a)
    self.status = a[0].to_i
    self.data1 = a[1].to_i
    self.data2 = a[2].to_i
    self.flags = a[3]
    self.duration = a[4].to_i
  end

  def to_s
    "status: 0x#{self.status}, data1: 0x#{self.data1}, data2: 0x#{self.data2}, "
  end
end

class Kiara::NoteBlock

  # Returns an array based reprensentation of the noteblock which can be
  # used to serialize data using yaml or other stuff. The
  # representation is the following:
  # {
  #  :version => 0 #for later use
  #  :xapian_id => the_xapian_id,
  #  :type => 0 of note,
  #  :tags => ['tag1', 'tag2', 'tag3', [...]] # We store this in case the index get corrupt or lost
  #  :name => "the name of the block",
  #  :data => [[tick, [event], [event1]],
  #             other_tick, [event2], [event3]],
  #             [...]]
  # }
  #
  # Please refer to Kiara::Event#to_a implementation for the format of
  # [eventx]
  def to_a
    res = []

    iter = 0
    while (iter = next_used_tick iter) >= 0 do
      puts iter
      e = get(iter)
      tick = []
      while e do
        tick.push e.to_a
        e = e.next
      end
      res.push [iter, tick]
      iter += 1
    end
    res
  end

  def from_a(a)
    a.each do |tick|
      tick[1].each do |item|
        puts "inserting at #{tick[0]} : #{item}"
        e = Kiara::Memory.event.alloc
        e.from_a item
        puts e
        insert! tick[0], e
      end
    end
  end
end

class Kiara::TransportPosition
  def to_a
    [bar, beat, tick]
  end

  def from_a(a)
    bar = a[0]
    beat = a[1]
    tick = a[2]
  end
end

# # Note sure this is still really necessary
# class Kiara::Engine
#   def to_yaml
#     yaml = {}
#     yaml['version'] = 1
#     yaml['bpm'] = timer.bpm
#     yaml['looping'] = transport.is_looping
#     yaml['loop_start'] = transport.get_loop_start.to_a
#     yaml['loop_end'] = transport.get_loop_end.to_a
#     yaml.to_yaml
#   end

#   def from_yaml(io)
#     yaml = YAML.load io
#     timer.bpm = yaml['bpm']
#     # Kiara::Memory.event.reset
#   end
# end

