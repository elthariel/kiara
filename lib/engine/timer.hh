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

#include <porttime.h>
#include <portmidi.h>

#include "kiara-config.h"
#include "transport.hh"

class Timer
{
public:
  Timer();
  ~Timer();

  void          operator()();
  void          kill();

  void          set_transport(Transport *t = 0);
  unsigned int  get_bpm();
  unsigned int  set_bpm(unsigned int);

protected:
  int           run();

  Transport     *transport;
  unsigned int  bpm;
  double        tick_len;
  double        reminder;
  bool          running;

private:
  Timer(const Timer &to_copy);
};

#endif	    /* !TIMER_HH_ */
