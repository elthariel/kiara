
#include <iostream>
#include <typeinfo>
#include "note_scheduler.hh"

/*
 * NoteScheduler
 */
NoteScheduler::NoteScheduler()
{
  unsigned int i;

  for (i = 0; i < CHANNELS; i++)
    connect(&bus[i], i);
}

NoteScheduler::~NoteScheduler() {}

NoteSchedulerBus &NoteScheduler::operator[](unsigned int i)
{
  if (i >= CHANNELS)
    i = 0;
  return bus[i];
}

// Overloading with empty method to avoid event passing
// Events should go directly to busses, we only pass ticks.
void    NoteScheduler::send(Event &e)
{
  return;
}

/*
 * NoteSchedulerBus
 */

NoteSchedulerBus::Voice::Voice()
  :remaining_tick(0),
   note(0)
{
}

NoteSchedulerBus::NoteSchedulerBus()
{
}

NoteSchedulerBus::~NoteSchedulerBus()
{
}

void    NoteSchedulerBus::send(Event &e)
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

void    NoteSchedulerBus::tick(TransportPosition pos)
{
  unsigned int i;

  for (i = 0; i < TRACK_POLY; i++)
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

int     NoteSchedulerBus::find_free_voice()
{
  unsigned int i;

  for (i = 0; i < TRACK_POLY; i++)
    if (voices[i].remaining_tick == 0)
      return i;
  return -1;
}

