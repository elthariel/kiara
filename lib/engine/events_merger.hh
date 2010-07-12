/*
** events_merger.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 23:47:55 2010 elthariel
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

#ifndef   	EVENTS_MERGER_HH_
# define   	EVENTS_MERGER_HH_

# include "bus.hh"
# include "boost/utility.hpp"

/*
 * EventMergerBus is the destination bus of all patterns.
 * There is a bus per midi channel. All events passing
 * through an EventMergerBus are checked and modified
 * necessary, at the output they all are on the same midi
 * chan (cf. set_chan(uint))
 */
class EventMergerBus : boost::noncopyable, public EventBus
{
public:
  EventMergerBus();
  ~EventMergerBus();

  virtual void  send(Event &);
  void          set_chan(unsigned int chan);
  unsigned int  get_chan();
protected:
  unsigned int          chan;
};

class EventMerger : boost::noncopyable
{
public:
  EventMerger();
  ~EventMerger();
  EventMergerBus        &operator[](unsigned int);
protected:
  EventMergerBus        bus[KIARA_TRACKS];
};

#endif	    /* !EVENTS_MERGER_HH_ */