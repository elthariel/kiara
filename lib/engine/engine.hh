/*
** engine.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 01:58:57 2010 elthariel
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

#ifndef   	ENGINE_HH_
# define   	ENGINE_HH_

# include <boost/thread.hpp>
# include <boost/utility.hpp>

# include "timer.hh"
# include "memory.hh"
# include "playlist.hh"
# include "events_merger.hh"
# include "event_scheduler.hh"
# include "midi_out.hh"

class Engine : boost::noncopyable
{
public:
  Engine();
  ~Engine();

  void                          start();
  void                          stop();
  Timer                         &timer();
  Transport                     &transport();
  Playlist                      &playlist();
  EventMerger                   &merger();
  EventScheduler                &scheduler();
  MidiOut                       &midi_out();
protected:
  Timer                         m_timer;
  Transport                     m_transport;
  EventMerger                   m_merger;
  Playlist                      m_playlist;
  EventScheduler                m_scheduler;
  MidiOut                       m_out;
  boost::thread                 engine_thread;
};

#endif	    /* !ENGINE_HH_ */
