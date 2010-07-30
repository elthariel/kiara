/*
** phrase.hh
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
# include "event.hh"

class NoteBlock
{
public:
  NoteBlock();
  ~NoteBlock();
  Event         *operator[](unsigned int tick);

  /*
   * Return the first found note that is at or overlaps the position
   * 'tick' It only search the first max_bar bars. The max_bar
   * parameter is mainly used to hint the function about the pattern
   * length of which the phrase has no knowledge
   */
  Event         *get_note_on_tick(unsigned int tick,
                                  unsigned int max_bar,
                                  unsigned char note);


  bool          insert(unsigned int tick, Event *e);
  bool          remove(unsigned int tick, Event *e);

  /*
   * Used to improve save performance
   * Return the first tick >= tick where data[tick] != 0
   *   or -1 the end of the phrase has been reached
   */
  int           next_used_tick(unsigned int tick);

  /*
   * Entirely empties the phrase. Used when loading a file.
   * Event are not deallocated, because memory pool is
   * reset as well when loading a file.
   */
  void          reset();
protected:
  Event         *data[KIARA_PPQ * 4 * KIARA_MAXBARS];
};

#endif	    /* !NOTE_BLOCK_HH_ */
