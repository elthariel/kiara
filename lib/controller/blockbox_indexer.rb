##
## blockbox_indexer.rb
## Login : <elthariel@rincevent>
## Started on  Mon Aug  2 22:49:11 2010 elthariel
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

require 'xapian'

module BlockBox

  DB = STORE + "/blockbox.db"

  class Index
    def initialize
      @db = Xapian::WritableDatabase.new(DB, Xapian::DB_CREATE_OR_OPEN)
    end

    # Add a block to the index, return true if successfull
    def add(uuid, type, tags, name)
    end

    # Update the indexed data of uuid
    # return nil if an error occured or uuid doesn't exists
    def update(uuid, type, tags, name)
    end

    # Parse and run the given query on the database.
    # Returns a list of matches or nil if an error occured
    def query(da_query)
    end

    # Return a spelling suggestion for the last query
    def spelling()
    end

    # Return a suggestion for the last query
    def suggest()
    end

    # Notifies the search engine that a block has been loaded It will
    # then be considered 'relevant' by the search engine. Improving
    # future suggestions
    def loaded(id_or_uuid)
    end

    # Return a list of tags ordered by their frequency.
    # the format is the following
    # [['tagname', occurence_count, 'internal_name'], ['tagname2', ...], [...]]
    def tags(max = 50)
      # FIXME replace this hardcoded stuff with the actual list
      [['note', 5000, '__type__note'],
       ['curve', 3000, '__type__curve'],
       ['drum', 53, '__tag__drum'],
       ['lead', 48, '__tag__lead'],
       ['hardcore', 42, '__tag__hardcore'],
       ['nubreak', 23, '__tag__nubreak']]
    end

  end

end
