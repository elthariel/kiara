##
## mapping_patterns.rb
## Login : <elthariel@rincevent>
## Started on  Thu Jul 22 06:38:40 2010 elthariel
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


