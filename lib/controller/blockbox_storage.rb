##
## blockbox_storage.rb
## Login : <elthariel@rincevent>
## Started on  Mon Aug  2 20:20:36 2010 elthariel
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

=begin
= Introduction
This is the implementation of the BlockBox using Xapian.

Althought the document is not really clear nor detailled, you cand
find some of the ideas which lead to the implementation of this
feature here :
http://kiara.acronyme.org/projects/kiara/wiki/V_0_1_0_design

The BlockBox is a block library providing an efficient way of storing,
'browsing' and loading back blocks. It can store CurveBlocks or
NoteBlocks. These blocks can be used as templates to create new ones
or 'as is'.

The goal here is not to implement a vfs-like subsystem to access
blocks and browse them in a traditionnal way but to provide a gmail
like interface. You have a bunch of blocks, and you can search for a
particular one using its name, its type or tags previously applied.

The BlockBox is divided in two parts:
* The storage, which use the serialization methods to store/load
  blocks.
* The search engine, based on Xapian, which indexes the name, tags,
  and path of every block. As the name suggests it also allows to
  search between all the stored items.

== BlockBoxStorage

The storage use the existing serialization methods. The storage format
is basically a gzipped Yaml file (using GzipWritter and Reader). The
file's extension is .block.gz

Each block in the storage is attributed an UUID (Universally Unique
IDentifier). The file name is UUID.zblock

Considering STORAGE_ROOT as the root folder of the BlockBoxStore, the
hierarchy is the following:
- STORAGE_ROOT/a/a/ -> Contains all the block whose uuid begin by aa.
- STORAGE_ROOT/a/b/ -> "" begin by ab.
- [...]
- STORAGE_ROOT/h/9/ -> "" begin by h9
- [...]
- STORAGE_ROOT/x/x/ -> "" begin by xx

== BlockBoxStorage Format

The storage format is the result of the serialization of a hash with this keys :
  {
   :version => 0 #for later use
   :xapian_id => the_xapian_id,
   # We store this in case the index get corrupt or lost
   :type => 0 of note,
   :tags => ['tag1', 'tag2', 'tag3', [...]]
   :name => "the name of the block",
   # The actual block data (this example is for noteblock)
   # The content of data is a the result of Kiara::NoteBlock.to_a
   :data => [[tick, [event], [event1]],
              other_tick, [event2], [event3]],
              [...]]
  }

== BlockBoxIndex

The index does mainly 3 things :
* It takes a query and returns the results to that query, possibly
  suggesting other pertinents queries or correction
* It takes a block and its metadata and add it to the index.
* For a given result it also could give you the corresponding file
  name/path.

The xapian database is located at STORAGE_ROOT/blockbox.db

=end

require 'lib_uuid'
require 'yaml'

require 'controller/serialization'

module BlockBox

  STORE = ENV['HOME'] + "/.kiara/blockbox"

  class Storage
    def initialize
      create_hierarchy unless File.directory? "#{STORE}/4/2"
    end

    # Takes a block, serialize it and store it.
    #
    # block must be a CurveBlockPtr or a NoteBlockPtr
    #
    # uuid is a string like this one 6e9dbdbb-4ab7-4a86-9aee-93d15d243e76
    # If the uuid argument is given, use it as the file's name and
    # overwrite any existing block with that name
    # If not, a new one is generated
    #
    # Returns nil if the operation failed
    # or the block's uuid if everyting went well.
    def store(block, metadata, uuid = nil)
      uuid = generate_uuid if uuid.nil?
      path = get_path_from_uuid(uuid)

      data = block.to_a
      to_serialize = metadata.dup
      to_serialize[:version] = 0
      to_serialize[:data] = data

      begin
        Zlib::GzipWriter.open(path, 3, 0) do |zf|
          puts "Saving a block to #{path}"
          zf << to_serialize.to_yaml
        end
      rescue => e
        puts e
        puts e.backtrace
        nil
      end
      uuid
    end

    # Takes an uuid, load and unserialize the file with that name
    #
    # Return nil if the file doesn't exists or an error was
    # encountered. Return a Curve/NoteBlockPtr otherwise.
    def load(uuid)
      path = get_path_from_uuid(uuid)
      yaml = nil

      begin
        Zlib::GzipReader.open(path) do |zf|
          puts "Loading #{path}"
          yaml = YAML.load zf
        end
      rescue => e
        puts e
        puts e.backtrace
        nil
      end

      if yaml['version'] == 0
        block = Kiara::NoteBlock::create
        block.from_a yaml['data']
        block
      else
        nil
      end
    end

    protected
    def generate_uuid
      LibUUID::UUID.new.to_guid
    end

    def get_path_from_uuid(uuid)
      "#{STORE}/#{uuid[0]}/#{uuid[1]}/#{uuid}.block.gz"
    end

    def create_hierarchy
      dirs = []
      ('0'..'9').each { |x| dirs.push x }
      ('a'..'z').each { |x| dirs.push x }

      dirs.each do |first|
        dirs.each do |second|
          FileUtils.makedirs "#{STORE}/#{first}/#{second}/"
        end
      end
    end
  end



end
