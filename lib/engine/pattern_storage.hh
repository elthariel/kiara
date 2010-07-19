/*
** pattern_storage.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 15:58:52 2010 elthariel
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

#ifndef   	PATTERN_STORAGE_HH_
# define   	PATTERN_STORAGE_HH_

# include <boost/utility.hpp>

# include "pattern.hh"
# include "events_merger.hh"

class PatternStorage : boost::noncopyable
{
public:
  PatternStorage();
  ~PatternStorage();

  Pattern       &operator[](unsigned int id);
  unsigned int  size();

  void          set_event_merger(EventMerger &merger);

  void          reset();
protected:
  Pattern       patterns[KIARA_MAXPATTERNS];
};

#endif	    /* !PATTERN_STORAGE_HH_ */
