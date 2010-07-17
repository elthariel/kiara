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

module BaseMapping
  include Mapping

  mapping do
    # Context/Focus Switching
    on_chain 'C-Tab' do
      action 'focus-next' do |context|
        context.next
      end
    end
    on_chain 'C-S-Tab' do
      action 'focus-prev' do |context|
        context.prev
      end
    end

    # Current pattern selection
    on_chain 'Up' do
      if_context :is? => :patterns
      action 'prev-pattern' do |context|
        context.patterns.prev
      end
    end
    on_chain 'Down' do
      if_context :is? => :patterns
      action 'next-pattern' do |context|
        context.patterns.next
      end
    end
    on_chain 'S-Up' do
      if_context :is? => :patterns
      action 'prev-pattern-10' do |context|
        context.patterns.prev(10)
      end
    end
    on_chain 'S-Down' do
      if_context :is? => :patterns
      action 'next-pattern-10' do |context|
        context.patterns.next(10)
      end
    end
  end
end

# module TestMapping
#   include Mapping

#   mapping do
#     on_chain 'C-x' do
#       on_chain 'C-f' do
#         if_context :is => :piano_roll
#         action 'action_name' do |context|
#           puts "super chain new file"
#         end
#       end
#       on_chain 'C-f' do
#         if_context :is_not => :piano_roll
#         action 'action_name' do |context|
#           puts "other super chain, Sens ton doigt!"
#         end
#       end
#     end
#     on_chain 'C-o' do
#       action 'action_name' do |context|
#         puts "chain test open"
#       end
#     end
#     on_chain 'C-s' do
#       action 'action_name' do |context|
#         puts "chain test save"
#       end
#     end
#   end
# end

