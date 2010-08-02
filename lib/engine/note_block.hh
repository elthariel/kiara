/*
** noteblock.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 05:28:55 2010 elthariel
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

#ifndef   	NOTE_BLOCK_HH_
# define   	NOTE_BLOCK_HH_

# include <stdint.h>

# include "kiara-config.h"

# include "block.hh"
# include "event.hh"

class NoteBlock : public Block
{
public:
  NoteBlock();
  // Deep copy of the NoteBlock (i.e. allocate new events).
  NoteBlock(const NoteBlock &a_block);
  ~NoteBlock();
  /*
   * Overload new and delete operator to avoid calls to malloc but
   * instead use our own allocator (memory pool / Rt::Chunk)
   */
  void          *operator new(size_t);
  void          operator delete(void *);


  Event         *operator[](unsigned int tick);

  /*
   * Return the first found note that is at or overlaps the position
   * 'tick'
   */
  Event         *get_note_on_tick(unsigned int tick,
                                  unsigned char note);


  bool          insert(unsigned int tick, Event *e);
  bool          remove(unsigned int tick, Event *e);

  /*
   * Used to improve save performance
   * Return the first tick >= tick where data[tick] != 0
   *   or -1 the end of the noteblock has been reached
   */
  int           next_used_tick(unsigned int tick);

  /*
   * Entirely empties the noteblock. Used when loading a file.
   * Event are not deallocated, because memory pool is
   * reset as well when loading a file.
   */
  void          reset();

protected:
  Event         *data[PPQ * 4 * MAX_BARS];
};

#endif	    /* !NOTE_BLOCK_HH_ */
