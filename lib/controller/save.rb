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
  # Return a array representing the Event.
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

class Kiara::Phrase

  # Returns an array based reprensentation of the phrase which can be
  # used to serialize data using yaml or other stuff. The
  # representation is the following:
  # [[tick, [event], [event1]], [other_tick, [event2], [event3]], [...]].
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

class Kiara::Pattern
  def to_a(id)
    res = []
    (0...Kiara::CHANNELS).each { |x| res.push get(x).to_a }
    res
  end

  def from_a(a)
    (0...Kiara::CHANNELS).each { |i| get(i).from_a a[i] }
  end
end

class Kiara::PatternStorage
  def to_a
    res = []
    (1..Kiara::KIARA_MAXPATTERNS).each do |x|
      res.push get(x).to_a(x)
    end
    res
  end

  def from_a(a)
    (1..Kiara::KIARA_MAXPATTERNS).each do |i|
      get(i).from_a a[i - 1]
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

class Kiara::Playlist
  def to_a
    res = []
    (0...Kiara::KIARA_PLSCHANNELS).each do |track_id|
      track = []
      (0...Kiara::KIARA_PLSLEN).each do |bar|
        track.push get_pos(track_id, bar)
      end
      res.push track
    end
    res
  end

  def from_a(a)
    (0...Kiara::KIARA_PLSCHANNELS).each do |track_id|
      (0...Kiara::KIARA_PLSLEN).each do |bar|
        set_pos(track_id, bar, a[track_id][bar])
      end
    end
  end
end

class Kiara::Engine
  def to_yaml
    yaml = {}
    yaml['version'] = 1
    yaml['bpm'] = timer.bpm
    yaml['looping'] = transport.is_looping
    yaml['loop_start'] = transport.get_loop_start.to_a
    yaml['loop_end'] = transport.get_loop_end.to_a
    yaml['playlist'] = playlist.to_a
    yaml['patterns'] = Kiara::Memory.pattern.to_a
    yaml.to_yaml
  end

  def from_yaml(io)
    yaml = YAML.load io
    timer.bpm = yaml['bpm']
    Kiara::Memory.event.reset
    playlist.reset!
    playlist.from_a yaml['playlist']
    Kiara::Memory.pattern.reset!
    Kiara::Memory.pattern.from_a yaml['patterns']
  end
end

