/*
** sector.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 31 01:58:35 2010 elthariel
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

#ifndef   	SECTOR_HH_
# define   	SECTOR_HH_

# include <boost/shared_ptr.hpp>

# include "note_block.hh"
# include "curve_block.hh"

class Sector
{
public:
  Sector();
  // Should perform a deep copy
  Sector(const Sector &a_sector);
  ~Sector();

protected:
  boost::shared_ptr<NoteBlock>  notes[CHANNELS];
  boost::shared_ptr<CurveBlock> curves[CHANNELS * CURVE_POLY];
};

#endif	    /* !SECTOR_HH_ */
