/*
** playlist.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 15:32:13 2010 elthariel
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

#ifndef   	PLAYLIST_HH_
# define   	PLAYLIST_HH_

# include <boost/utility.hpp>

# include "bus.hh"
# include "pattern.hh"

class Playlist : public EventBus //, boost::noncopyable
{
public:
  Playlist();
  /*
   * returns : 0 if empty
   * x < 0 if overlapped by a previous pattern
   * x > 0, pos contains the start of a pattern.
   */
  int           get_pos(unsigned int track,
                        unsigned int bar);
  /*
   * return false if the place is already occupied
   * or overlapped by a previous pattern.
   */
  bool          set_pos(unsigned int track,
                        unsigned int bar,
                        unsigned int pattern_id);

  virtual void  tick(TransportPosition pos);
protected:
  // Return the position of the start of the pattern
  // overlapping the given positon
  // or 0 if there is no overlapping pattern here.
  unsigned      get_pattern_start(unsigned int track,
                                  unsigned int bar);


  // Pattern positioning granularity is bar.
  // negative value means the bar is overlapped
  // by a previous pattern.
  int           patterns[KIARA_PLSTRACKS][KIARA_PLSLEN];
};

#endif	    /* !PLAYLIST_HH_ */
