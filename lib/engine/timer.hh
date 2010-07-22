/*
** timer.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 02:00:29 2010 elthariel
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

#ifndef   	TIMER_HH_
# define   	TIMER_HH_

#include "kiara-config.h"
#include "transport.hh"
#include "event_scheduler.hh"
#include "boost/utility.hpp"

class Timer : private boost::noncopyable
{
public:
  Timer();
  ~Timer();

  void          operator()();
  void          kill();

  void          set_transport(Transport *t = 0);
  void          set_scheduler(EventScheduler *s = 0);
  unsigned int  get_bpm();
  unsigned int  set_bpm(unsigned int);

protected:
  int           run();

  Transport     *transport;
  EventScheduler *scheduler;

  /*
   * Current bpm
   */
  unsigned int  bpm;

  /*
   * Current tick length, in ms or in s, depending on implementation.
   * Default portable one is in ms, _linux one based on nanosleep is
   * in seconds.
   */
  double        tick_len;
  double        reminder;
  bool          running;

};

#endif	    /* !TIMER_HH_ */
