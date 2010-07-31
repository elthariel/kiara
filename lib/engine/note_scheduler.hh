/*
** event_scheduler.hh
** Login : <elthariel@rincevent>
** Started on  Sun Jul 11 00:26:46 2010 elthariel
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

#ifndef   	NOTE_SCHEDULER_HH_
# define   	NOTE_SCHEDULER_HH_

# include "boost/utility.hpp"
# include "bus.hh"

class NoteSchedulerBus : public EventBus, boost::noncopyable
{
protected:
  struct Voice
  {
    Voice();
    uint16_t    remaining_tick;
    uint8_t     chan;
    uint8_t     note;
  };
public:
  NoteSchedulerBus();
  ~NoteSchedulerBus();
  virtual void  send(Event &e);
  virtual void  tick(TransportPosition pos);

protected:
  int           find_free_voice();

  Voice         voices[TRACK_POLY];
};

// connect before Playlist in Transport.
class NoteScheduler : public EventBus, boost::noncopyable
{
public:
  NoteScheduler();
  ~NoteScheduler();

  NoteSchedulerBus     &operator[](unsigned int i);
  virtual void          send(Event &e);

protected:

  NoteSchedulerBus     bus[CHANNELS];
};

#endif	    /* !NOTE_SCHEDULER_HH_ */
