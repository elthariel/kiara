/*
** timer.cc
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 02:08:00 2010 elthariel
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


#include "timer.hh"

using namespace std;

Timer::Timer()
  :transport(0),
   scheduler(0),
   reminder(0.0),
   running(true)
{
  set_bpm(KIARA_DEFAULTBPM);
  if (Pt_Start(1, 0, 0) != ptNoError)
  {
    std::cerr << "Unable to start PortTime, Kiara won't work at all !"
              << std::endl;
    throw "Unable to start PortTime";
  }
}

Timer::~Timer()
{
}

int           Timer::run()
{
  while (running)
  {
    Pt_Sleep(1);
    reminder += 1;

    if (reminder >= tick_len)
    {
      reminder -= tick_len;
      if (scheduler)
      {
        TransportPosition useless_pos;
        scheduler->tick(useless_pos);
      }
      if (transport)
        transport->trigger_tick();
    }
  }
}

void          Timer::operator()()
{
  run();
}

void          Timer::kill()
{
  running = false;
}

unsigned int  Timer::get_bpm()
{
  return bpm;
}

unsigned int  Timer::set_bpm(unsigned int new_bpm)
{
  bpm = new_bpm;
  tick_len = 60000.0 / (bpm * KIARA_PPQ);
  cout << "New tick len: " << tick_len << "ms." << endl;
}

void          Timer::set_transport(Transport *t)
{
  transport = t;
}

void          Timer::set_scheduler(EventScheduler *s)
{
  scheduler = s;
}


