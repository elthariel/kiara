/*
** pattern.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 15:33:17 2010 elthariel
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

#ifndef   	PATTERN_HH_
# define   	PATTERN_HH_

#include "phrase.hh"
#include "bus.hh"

class Pattern : public EventBus
{
public:
  Pattern();
  ~Pattern();

  Phrase        &operator[](unsigned int track_id);

  /*
   * When sending tick to patterns, pos must be relative to
   * the start of the pattern.
   */
  virtual void  tick(TransportPosition pos);

  unsigned int  get_size();
  void          set_size(unsigned int a_size);
protected:
  void          play_track(unsigned int track,
                           TransportPosition pos);

  Phrase        phrases[KIARA_TRACKS];

  // The size of the pattern in bars.
  unsigned int  size;
};

#endif	    /* !PATTERN_HH_ */
