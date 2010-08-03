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

# Returns an Array of all Xapian::Terms for this database.
module Xapian
class Database
  def allterms_prefix(prefix)
    Xapian._safelyIterate(self._dangerous_allterms_begin(prefix),
                          self._dangerous_allterms_end(prefix)) { |item|
      Xapian::Term.new(item.term, 0, item.termfreq)
    }
  end # allterms
end
end


module BlockBox

  DB = STORE + "/blockbox.db"

  class Index
    IDX_TYPE = 0
    IDX_TAGS = 1
    IDX_NAME = 2

    def initialize
      @db = Xapian::WritableDatabase.new(DB, Xapian::DB_CREATE_OR_OPEN)
      @enquire = Xapian::Enquire.new(@db)
      @enquire.sort_by_relevance_then_value! IDX_NAME, false
      @parser = Xapian::QueryParser.new
      @parser.add_boolean_prefix 'tag', '__tag__'
      @parser.add_boolean_prefix 'type', '__type__'
      @rset = Xapian::RSet.new
      # The last run query, i.e. the query active in the Enquire object.
      @query = nil
    end

    # Add a block to the index, return true if successfull if id is
    # provided, replace the existing document having this id by the
    # new one.
    def add(uuid, type, tags, name, id = nil)
      xdoc = Xapian::Document.new
      xdoc.data = uuid
      xdoc.add_value IDX_TYPE, type
      xdoc.add_value IDX_TAGS, tags.join(';')
      xdoc.add_value IDX_NAME, name
      xdoc.add_posting "__type__#{type}", 0

      posting_id = 1
      tags.each do |t|
        xdoc.add_posting "__tag__#{t}", posting_id
        @db.add_spelling t
        posting_id += 1
      end
      name.each do |n|
        xdoc.add_posting "#{n}", posting_id
        @db.add_spelling name
        posting_id += 1
      end

      if docid
        @db.replace_document id, xdoc
      else
        @db.add_document xdoc
      end
    end

    # Removes a document from the index
    def remove(id)
      @db.delete_document id
    end

    # Parse and run the given query on the database.
    # Returns a list of matches or nil if an error occured
    def query(query, results = 50)
      query.gsub! '&&', 'AND'
      query.gsub! '||', 'OR'
      query.gsub! '&', 'AND'
      query.gsub! '|', 'OR'
      query.gsub! '!', 'NOT'
      query.gsub! '^', 'XOR'
      q += "(#{query})"

      @query = @parser.parse_query q
      @enquire.set_query(@query)

      matches = @enquire.mset(0, 50, @rset).matches
      # FIXME Transform the matches into something usefull ...
    end

    # Return a spelling suggestion for the given string
    def spelling(str)
      @db.spelling_suggestion(str)
    end

    # Return a suggestion for the last query
    def suggest()
    end

    # Notifies the search engine that a block has been loaded It will
    # then be considered 'relevant' by the search engine. Improving
    # future suggestions
    def loaded(id)
      @rset.add_document(id)
    end
    def unloaded(id)
      @rset.remove_document(id)
    end

    # Return a list of tags ordered by their frequency.
    # the format is the following
    # [['tagname', occurence_count, 'internal_name'], ['tagname2', ...], [...]]
    def tags(max = 50)
      # Smth like this should work
      # terms = @db.allterms_prefix('__tag__')
      # puts terms.class
      # puts terms.inspect
      # terms.map { |x| [x[0], x[2]] }

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
