/*
** note_block.cxx
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
#include <cstring>
#include <assert.h>

#include "note_block.hh"
#include "memory.hh"

using namespace std;

NoteBlock::NoteBlock()
{
  reset();
}

NoteBlock::NoteBlock(const NoteBlock &a_block)
  : Block(a_block)
{
  reset();

  for (int i = 0; i < PPQ * 4 * MAX_BARS; ++i)
    if (a_block.data[i])
    {
      Event     *a_iter = a_block.data[i];
      Event     *iter = new Event(*a_iter);

      data[i] = iter;

      while(a_iter->next)
      {
        iter->next = new Event(*a_iter->next);

        iter = iter->next;
        a_iter = a_iter->next;
      }
    }
}

NoteBlock::~NoteBlock()
{
  for (int i = 0; i < PPQ * 4 * MAX_BARS; ++i)
    if (data[i])
    {
      Event     *iter = data[i];
      Event     *to_delete = 0;

      while (iter)
      {
        to_delete = iter;
        iter = iter->next;
        delete to_delete;
      }

      data[i] = 0;
    }
}

void          *NoteBlock::operator new(size_t sz)
{
  assert(sz == sizeof(NoteBlock));

  return Memory::note_block().alloc();
}

void          NoteBlock::operator delete(void *p)
{
  if (p)
    Memory::note_block().dealloc((NoteBlock *)p);
}

Event         *NoteBlock::operator[](unsigned int tick)
{
  assert (tick < PPQ * 4 * MAX_BARS);

  if (tick >= PPQ * 4 * length)
    tick = PPQ * 4 * length - 1;

  return data[tick];
}

Event         *NoteBlock::get_note_on_tick(unsigned int tick,
                                        unsigned int max_bar,
                                        unsigned char note)
{
  unsigned int i;
  Event *iter = 0;

  assert(max_bar < MAX_BARS);

  if (max_bar > length)
    max_bar = length;

  for (i = 0; i < max_bar * 4 * PPQ; i++)
  {
    iter = data[i];
    while (iter)
    {
      if (iter->midi[1] == note && tick >= i && tick < i + iter->duration)
        return iter;
      iter = iter->next;
    }
  }
  return iter;
}

bool          NoteBlock::insert(unsigned int tick, Event *e)
{
  assert(tick < MAX_BARS * PPQ * 4);
  assert(e == 0);

  if (tick >= MAX_BARS * PPQ * 4 || e == 0)
    return false;

  Event *iter = data[tick];

  e->next = data[tick];
  data[tick] = e;

  return true;
}

bool          NoteBlock::remove(unsigned int tick, Event *e)
{
  assert(tick < MAX_BARS * PPQ * 4);
  assert(e == 0);

  if (tick > MAX_BARS * PPQ * 4 || e == 0)
    return false;

  Event *iter = data[tick];

  if (iter == e)
  {
    data[tick] = iter->next;
    return true;
  }

  while (iter && iter->next)
  {
    if (iter->next == e)
    {
      iter->next = iter->next->next;
      return true;
    }
    iter = iter->next;
  }
  return false;
}

int           NoteBlock::next_used_tick(unsigned int tick)
{
  unsigned int i;

  for (i = tick; i < MAX_BARS * PPQ * 4; i++)
    if (data[i])
      return i;
  return -1;
}

void          NoteBlock::reset()
{
  Block::reset();
  memset(&data, 0, sizeof(data));
}


