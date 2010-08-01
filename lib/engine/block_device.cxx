/*
** cluster.cxx
** Login : <elthariel@rincevent>
** Started on  Sat Jul 31 22:26:04 2010 elthariel
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

#include <iostream>
#include <assert.h>

#include "block_device.hh"

using namespace std;

BlockDevice::BlockDevice(Cluster &a_loop_cluster,
                         Cluster &a_break_cluster,
                         Cluster &a_interrupt_cluster)
  : loop_cluster(a_loop_cluster),
    break_cluster(a_break_cluster),
    interrupt_cluster(a_interrupt_cluster)
{
  current.set_length(0);

  for (int i = 0; i < CHANNELS; ++i)
    for (int j = 0; j < CURVE_POLY; ++j)
      cc_numbers[i][j] = 71 + j;
}

BlockDevice::~BlockDevice()
{
}

// FIXME const this!
Sector                &BlockDevice::operator[](unsigned int idx)
{
  return current[idx];
}

void                  BlockDevice::send(Event &e)
{
  // the method is void to override default behavior which is to forward
  // received events.
}

bool                  BlockDevice::is_break_triggered()
{
  return break_triggered;
}

bool                  BlockDevice::is_interrupt_triggered()
{
  return interrupt_triggered;
}

void                  BlockDevice::trigger_break(bool trig)
{
  break_triggered = trig;
}

void                  BlockDevice::trigger_interrupt(bool trig)
{
  interrupt_triggered = trig;
}

TransportPosition     BlockDevice::get_interrupt_time()
{
  return interrupt_time;
}

TransportPosition     BlockDevice::get_current_start_time()
{
  return current_start_time;
}

void                  BlockDevice::set_cc_number(unsigned int chan,
                                                 unsigned int lane_idx,
                                                 unsigned char cc_number)
{
  assert (chan < CHANNELS);
  assert (lane_idx < CURVE_POLY);
  assert (cc_number < 128);

  cc_numbers[chan][lane_idx] = cc_number;
}

unsigned char         BlockDevice::get_cc_number(unsigned int chan,
                                                 unsigned int lane_idx)
{
  assert (chan < CHANNELS);
  assert (lane_idx < CURVE_POLY);

  return cc_numbers[chan][lane_idx];
}






/***********************************************************
 * Block device playback implementation
 * All the interresting methods are below
 */

void                  BlockDevice::tick(TransportPosition pos)
{
  TransportPosition   relative_pos = pos - current_start_time;

  // If this is the first tick of a bar, check if we have to copy cluster etc.
  if (pos.beat == 0 && pos.tick == 0)
    if (new_bar(relative_pos))
      relative_pos = pos - current_start_time;

  play_tick(relative_pos);
}

/*
 * The algorithm is basically the following:
 * - if we have an interruption, merge its content to the playing cluster
 * - if we are at the end of the current cluster, copy a new one:
 *   - if we have a break trigger, copy the break cluster
 *   - else copy the loop cluster
 */
bool                  BlockDevice::new_bar(TransportPosition relative_pos)
{
  bool                res = false;

  if (relative_pos.bar >= current.get_length())
  {
    load_cluster();
    res = true;
  }

  if (interrupt_triggered)
    handle_interrupt();

  return res;
}

void                  BlockDevice::handle_interrupt()
{
  interrupt_triggered = false;
  current += interrupt_cluster;
}

void                  BlockDevice::load_cluster()
{
  Cluster             *to_load;

  if (break_triggered)
  {
    to_load = &break_cluster;
    break_triggered = false;
  }
  else
    to_load = &loop_cluster;

  current = *to_load;
}

void                  BlockDevice::play_tick(TransportPosition relative_pos)
{
  for (int i = 0; i < CHANNELS; ++i)
  {
    play_note(relative_pos, i);
    for (int j = 0; j < CURVE_POLY; ++j)
      play_curve(relative_pos, i, j);
  }
}

void                  BlockDevice::play_note(TransportPosition pos,
                                             unsigned int chan)
{
  if (m_bus[chan])
    // We have to find a block starting here or an overlapping block
    for (int i = pos.bar; i <= 0; --i)
    {
      Sector &sector = current[pos.bar];
      if (sector.get_note_at(chan) &&
          i + sector.get_note_at(chan)->get_length() > pos.bar)
      {
        NoteBlockPtr    block = sector.get_note_at(chan);
        Event           *iter = (*block)[pos];
        Event           to_play;

        while (iter)
        {
          to_play = *iter;
          m_bus[chan]->send(to_play);
          iter = iter->next;
        }
        break; // We only play the first matching pattern. i.e. last overlaps first.
      }
    }
}

void                  BlockDevice::play_curve(TransportPosition pos,
                                              unsigned int chan,
                                              unsigned int track_id)
{
  if (m_bus[chan])
    // We have to find a block starting here or an overlapping block
    for (int i = pos.bar; i <= 0; --i)
    {
      Sector &sector = current[pos.bar];
      if (sector.get_curve_at(chan, track_id) &&
          i + sector.get_curve_at(chan, track_id)->get_length() > pos.bar)
      {
        CurveBlockPtr   block = sector.get_curve_at(chan, track_id);

        if ((*block)[pos] >= 0)
        {
          Event           e;

          e.cc();
          e.set_data1(cc_numbers[chan][track_id]);
          e.set_data2((*block)[pos]);
          m_bus[chan]->send(e);
        }
        break; // We only play the first matching pattern. i.e. last overlaps first.
      }
    }
}


