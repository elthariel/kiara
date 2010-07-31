/*
** block_device.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 31 16:34:54 2010 elthariel
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

#ifndef   	BLOCK_DEVICE_HH_
# define   	BLOCK_DEVICE_HH_

# include "bus.hh"
# include "cluster.hh"

class BlockDevice : public EventBus
{
public:
  BlockDevice(const Cluster &a_loop_cluster,
              const Cluster &a_break_cluster,
              const Cluster &a_interrupt_cluster);
  ~BlockDevice();

  // FIXME const this!
  Sector                &operator[](unsigned int);

  virtual void          send(T &e);
  virtual void          tick(TransportPosition pos);

  bool                  is_break_triggered();
  bool                  is_interrupt_triggered();
  void                  trigger_break(bool trig = true);
  void                  trigger_interrupt(bool trig = true);
protected:

  Cluster               current;
  const Cluster         &loop_cluster;
  const Cluster         &break_cluster;
  const Cluster         &interrupt_cluster;
  TransportPosition     interrupt_time;
  TransportPosition     current_start_time;
  bool                  break_triggered;
  bool                  interrupt_triggered;
};

#ENDIF	    /* !BLOCK_DEVICE_HH_ */
