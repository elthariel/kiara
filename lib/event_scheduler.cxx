
#include <iostream>
#include <typeinfo>
#include "event_scheduler.hh"

/*
 * EventScheduler
 */
EventScheduler::EventScheduler()
{
  unsigned int i;

  for (i = 0; i < KIARA_TRACKS; i++)
    connect(&bus[i], i);
}

EventScheduler::~EventScheduler() {}

EventSchedulerBus &EventScheduler::operator[](unsigned int i)
{
  if (i >= KIARA_TRACKS)
    i = 0;
  return bus[i];
}

// Overloading with empty method to avoid event passing
// Events should go directly to busses, we only pass ticks.
void    EventScheduler::send(Event &e)
{
  return;
}

/*
 * EventSchedulerBus
 */

EventSchedulerBus::Voice::Voice()
  :remaining_tick(0),
   note(0)
{
}

EventSchedulerBus::EventSchedulerBus()
{
}

EventSchedulerBus::~EventSchedulerBus()
{
}

void    EventSchedulerBus::send(Event &e)
{
  int   voice_id;

  if (e.is_noteon())
    if ((voice_id = find_free_voice()) >= 0)
    {
      voices[voice_id].note = e.midi[1];
      voices[voice_id].chan = e.midi[0] & 0x0F;
      voices[voice_id].remaining_tick = e.duration;
    }
    else
      return;

  EventBus::send(e);
}

void    EventSchedulerBus::tick(TransportPosition pos)
{
  // static int zzz = 0;
  // zzz = (zzz + 1) % 50;
  // if (zzz == 0)
  //   cout << typeid(*this).name() << ": tick" << endl;

  unsigned int i;

  for (i = 0; i < KIARA_TRACK_POLY; i++)
    if (voices[i].remaining_tick > 0)
    {
      voices[i].remaining_tick--;
      if (voices[i].remaining_tick == 0)
      {
        Event   e;
        e.midi[0] = 0x80 | voices[i].chan;
        e.midi[1] = voices[i].note;
        e.midi[2] = 0;
        EventBus::send(e);
      }
    }
}

int     EventSchedulerBus::find_free_voice()
{
  unsigned int i;

  for (i = 0; i < KIARA_TRACK_POLY; i++)
    if (voices[i].remaining_tick == 0)
      return i;
  return -1;
}

