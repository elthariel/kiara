/*
** block.cc
** Login : <elthariel@rincevent>
** Started on  Sat Jul 31 22:26:04 2010 elthariel
** $Id$
**
** Author(s):
**  - elthariel <elthariel@gmail.com>
**
** Copyright (C) 2010 elthariel
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/

#include <iostream>
#include "block.hh"

using namespace std;

Block::Block()
  : m_xapian_id(INVALID_ID)
{
  reset();
}

Block::Block(const Block &a_block)
  : length(a_block.length),
    m_modified(a_block.m_modified),
    m_xapian_id(a_block.m_xapian_id)
{
}

Block         &Block::operator=(const Block &a_block)
{
  length = a_block.length;
}

unsigned int  Block::get_length()
{
  return length;
}

void          Block::set_length(unsigned int newlen)
{
  if (newlen > MAX_BARS)
    newlen = MAX_BARS;
  else if (newlen != length)
  {
    length = newlen;
    m_modified = true;
  }
}

void          Block::reset()
{
  m_modified = true;
  length = 1;
}

bool          Block::get_modified()
{
  return m_modified;
}

void          Block::set_modified(bool is_modified)
{
  m_modified = is_modified;
}

Block::Id     Block::get_xapian_id()
{
  return m_xapian_id;
}

void          Block::set_xapian_id(Block::Id new_id)
{
  m_xapian_id = new_id;
}

