/*
** sector.cxx
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
#include <assert.h>

#include "sector.hh"

using namespace std;

Sector::Sector()
{
}

Sector::Sector(const Sector &a_sector)
{
  merge(a_sector);
}

/*
 * The assignment operator has basically the same behavior as the copy
 * constructor, but it also resets array items if needed. i.e. the
 * merge of the copy constructor and of reset().
 */
Sector                        &Sector::operator=(const Sector &a_sector)
{
  if (this == &a_sector)
    return *this;

  for (int i = 0; i < CHANNELS; ++i)
  {
    if (a_sector.notes[i])
    {
      NoteBlockPtr nblock = NoteBlock::create(*a_sector.notes[i]);
      notes[i] = nblock;
    }
    else
      notes[i] = NoteBlockPtr();

    for (int j = 0; j < CURVE_POLY; ++j)
      if (a_sector.curves[i][j])
      {
        CurveBlockPtr nblock = CurveBlock::create(*a_sector.curves[i][j]);
        curves[i][j] = nblock;
      }
      else
        curves[i][j] = CurveBlockPtr();
  }

  return *this;
}

Sector                        &Sector::operator+=(const Sector &a_sector)
{
  merge(a_sector);
  return *this;
}

void                          Sector::merge(const Sector &a_sector)
{
  for (int i = 0; i < CHANNELS; ++i)
  {
    if (a_sector.notes[i])
    {
      NoteBlockPtr nblock = NoteBlock::create(*a_sector.notes[i]);
      notes[i] = nblock;
    }

    for (int j = 0; j < CURVE_POLY; ++j)
      if (a_sector.curves[i][j])
      {
        CurveBlockPtr nblock = CurveBlock::create(*a_sector.curves[i][j]);
        curves[i][j] = nblock;
      }
  }
}

boost::shared_ptr<NoteBlock>  Sector::get_note_at(unsigned int channel)
{
  assert(channel < CHANNELS);

  return notes[channel];
}

boost::shared_ptr<CurveBlock> Sector::get_curve_at(unsigned int channel,
                                                   unsigned int curve_idx)
{
  assert(channel < CHANNELS);
  assert(curve_idx < CURVE_POLY);

  return curves[channel][curve_idx];
}

void                          Sector::set_note_at(unsigned int channel,
                                                  boost::shared_ptr<NoteBlock> block)
{
  assert(channel < CHANNELS);

  notes[channel] = block;
}

void                          Sector::set_curve_at(unsigned int channel,
                                                   unsigned int curve_idx,
                                                   boost::shared_ptr<CurveBlock> block)
{
  assert(channel < CHANNELS);
  assert(curve_idx < CURVE_POLY);

  curves[channel][curve_idx] = block;
}

void                          Sector::reset()
{
  for (int i = 0; i < CHANNELS; ++i)
  {
    notes[i] = NoteBlockPtr();
    for (int j = 0; j < CURVE_POLY; ++j)
      curves[i][j] = CurveBlockPtr();
  }
}

