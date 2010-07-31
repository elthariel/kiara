/*
** ibus.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 14:43:00 2010 elthariel
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

#ifndef   	IBUS_HH_
# define   	IBUS_HH_

# include "transport_position.hh"
# include "event.hh"
# include "kiara-config.h"

template <class T>
class Bus
{
public:
  Bus();
  virtual ~Bus();
  virtual void  connect(Bus<T> *a_bus,
                        unsigned int bus_id = 0);
  virtual void  send(T &e);
  virtual void  tick(TransportPosition pos);
  // virtual void  set_send_ticks(bool send_tick = true);
  // virtual bool  get_send_ticks();
protected:
  Bus<T>       *m_bus[CHANNELS];
  bool          m_send_ticks;
};

#include "bus.cxx"

typedef Bus<Event>     EventBus;

#endif	    /* !IBUS_HH_ */
