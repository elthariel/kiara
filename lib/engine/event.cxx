/*
** note.cc
** Login : <elthariel@rincevent>
** Started on  Thu Jul  8 00:39:14 2010 elthariel
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

#include "event.hh"
#include "memory.hh"

using namespace std;

Event::Event()
{
  reset();
}

void          *Event::operator new(size_t sz)
{
  assert(sz == sizeof(Event));

  return Memory::event().alloc();
}

void          Event::operator delete(void *e)
{
  if (e)
    Memory::event().dealloc((Event *)e);
}

void          Event::reset()
{
  memset(this, 0, sizeof(Event));
}

unsigned char Event::get_chan()
{
  return midi[0] & 0x0F;
}

void          Event::set_chan(unsigned char chan)
{
  midi[0] = (midi[0] & 0xF0) | (0x0F & chan);
}

void          Event::set_status(unsigned char status)
{
  midi[0] = status;
}

unsigned char Event::get_status()
{
  return midi[0];
}

void          Event::set_data1(unsigned char d)
{
  midi[1] = d;
}

unsigned char Event::get_data1()
{
  return midi[1];
}

void          Event::set_data2(unsigned char d)
{
  midi[2] = d;
}

unsigned char Event::get_data2()
{
  return midi[2];
}

bool          Event::is_noteon()
{
  return (midi[0] & 0xF0 ) == 0x90;
}

bool          Event::is_noteoff()
{
  return (midi[0] & 0xF0 ) == 0x80;
}

bool          Event::is_cc()
{
  return (midi[0] & 0xF0 ) == 0xB0;
}

void          Event::noteon()
{
  midi[0] = (midi[0] & 0x0F) | 0x90;
}

void          Event::noteoff()
{
  midi[0] = (midi[0] & 0x0F) | 0x80;
}

void          Event::cc()
{
  midi[0] = (midi[0] & 0x0F) | 0xB0;
}

