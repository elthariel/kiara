/*
** midi_out.hh
** Login : <elthariel@rincevent>
** Started on  Sun Jul 11 02:25:52 2010 elthariel
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

#ifndef   	MIDI_OUT_HH_
# define   	MIDI_OUT_HH_

# include <portmidi.h>
# include "bus.hh"

class MidiOut : public EventBus
{
public:
  MidiOut();
  ~MidiOut();

  PortMidiStream        *get_out();
  void                  set_out(PortMidiStream *);

  virtual void          send(Event &e);
  virtual void          connect(EventBus *a_bus,
                                unsigned int bus_id = 0);
  virtual void          tick(TransportPosition pos);

protected:
  PortMidiStream        *out;
};

#endif	    /* !MIDI_OUT_HH_ */
