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

#ifndef   	PHRASE_HH_
# define   	PHRASE_HH_

# include <stdint.h>

# include "kiara-config.h"
# include "event.hh"

class Phrase
{
public:
  Phrase();
  ~Phrase();
  Event         *operator[](unsigned int tick);
  Event         *get_note_on_tick(unsigned int tick,
                                  unsigned int max_bar,
                                  unsigned char note);


  bool          insert(unsigned int tick, Event *e);
protected:
  Event         *data[KIARA_PPQ * 4 * KIARA_MAXBARS];
};

#endif	    /* !PHRASE_HH_ */
