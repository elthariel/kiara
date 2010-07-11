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
#include "event.hh"

using namespace std;

Event::Event()
{
  reset();
}

void          Event::reset()
{
  memset(this, 0, sizeof(Event));
}

uint8_t       Event::get_chan()
{
  return midi[0] & 0x0F;
}

void          Event::set_chan(uint8_t chan)
{
  midi[0] = (midi[0] & 0xF0) | (0x0F & chan);
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

