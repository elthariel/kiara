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

#include <time.h>
#include <cmath>
#include <cstring>
#include <stdio.h>

// Linux specific headers
#include <errno.h>
#include <sys/mman.h>
#include <sched.h>

#include "timer.hh"
#include "thread_debug.hh"

using namespace std;

#define __KIARA_LINUX_TIMER_CLOCK   CLOCK_REALTIME

Timer::Timer()
  :transport(0),
   scheduler(0),
   reminder(0.0),
   running(true)
{
  set_bpm(START_BPM);
}

Timer::~Timer()
{
}

int           Timer::run()
{
  /*
   * Since we are using absolute time when sleeping, we here query the
   * start time (last_tick). We then add the tick size to this time
   * and sleep until that new time.
   */
  struct timespec       last_tick;
  clock_gettime(__KIARA_LINUX_TIMER_CLOCK, &last_tick);

  while (running)
  {
    struct timespec     request;

    /*
     * If tick_len is 1.2465, tv_sec should be 1 and tv_nsec
     * 2465000000000
     */
    request.tv_sec = last_tick.tv_sec + floor(tick_len);
    request.tv_nsec = last_tick.tv_nsec + (tick_len - floor(tick_len)) * 1000 * 1000 * 1000;
    request.tv_sec += request.tv_nsec / (1000 * 1000 * 1000);
    request.tv_nsec = request.tv_nsec % (1000 * 1000 * 1000);

    // cout << request.tv_sec << ":" << request.tv_nsec << endl;
    while (clock_nanosleep(__KIARA_LINUX_TIMER_CLOCK, TIMER_ABSTIME, &request, 0))
      cout << "clock_nanosleep interrupted ?!" << endl;

    memcpy(&last_tick, &request, sizeof(last_tick));

    if (scheduler)
    {
      TransportPosition useless_pos;
      scheduler->tick(useless_pos);
    }
    if (transport)
      transport->trigger_tick();
  }
}

static void   __acquire_rt_privileges()
{
  struct sched_param sched_param;

  /*
   * Trying to lock memory pages (avoid swapping and stuffs)
   * to prevent pages faults that would ruin our timer accuracy.
   */
  if (mlockall(MCL_CURRENT))
    perror("Kiara-Engine, Unable to lock memory pages");

  /*
   * Try to obtain the real-time scheduling privileges for the current
   * thread.
   */
  sched_param.sched_priority = 40;
  if (sched_setscheduler(0, SCHED_FIFO, &sched_param))
    perror("Kiara-Engine, Unable acquire realtime scheduling");
}

void          Timer::operator()()
{
  I_AM_THE_RT_THREAD;
  __acquire_rt_privileges();
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
  tick_len = 60.0 / (bpm * PPQ);
  cout << "New tick len: " << tick_len << "s." << endl;
}

void          Timer::set_transport(Transport *t)
{
  transport = t;
}

void          Timer::set_scheduler(NoteScheduler *s)
{
  scheduler = s;
}


