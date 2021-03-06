/*
** memory.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 05:56:58 2010 elthariel
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

#ifndef   	MEMORY_HH_
# define   	MEMORY_HH_

# include <boost/utility.hpp>
# include "kiara-config.h"
# include "pool.hh"
# include "event.hh"
# include "note_block.hh"
# include "curve_block.hh"

class Memory : private boost::noncopyable
{
public:
  static Memory                 &get();
  static Rt::Chunk<Event>       &event();
  static Rt::Chunk<NoteBlock>   &note_block();
  static Rt::Chunk<CurveBlock>  &curve_block();

protected:
  Memory();

  static Memory                 *instance;

  Rt::Chunk<Event>              event_pool;
  Rt::Chunk<NoteBlock>          note_block_pool;
  Rt::Chunk<CurveBlock>         curve_block_pool;
};

#endif	    /* !MEMORY_HH_ */
