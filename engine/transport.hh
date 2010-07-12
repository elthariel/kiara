/*
** transport.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 03:10:39 2010 elthariel
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

#ifndef   	TRANSPORT_HH_
# define   	TRANSPORT_HH_

# include "transport_position.hh"
# include "bus.hh"

class Transport : public EventBus
{
public:
  Transport();
  ~Transport();

  // Called from the timer
  void                  trigger_tick();

  void                  start();
  void                  stop();
  void                  pause();
  void                  loop(bool enable_loop = true);
  void                  jump(TransportPosition pos);

  bool                  is_playing();
  bool                  is_looping();

// FIXME ruby binding memory leak?
  void                  set_loop_start(TransportPosition start);
  void                  set_loop_end(TransportPosition end);
  TransportPosition     get_loop_start();
  TransportPosition     get_loop_end();
  TransportPosition     get_position();

protected:
  bool                  playing;
  bool                  looping;
  TransportPosition     position;
  TransportPosition     loop_start;
  TransportPosition     loop_end;

};

#endif	    /* !TRANSPORT_HH_ */
