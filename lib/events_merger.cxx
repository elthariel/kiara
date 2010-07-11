
#include <iostream>
#include "events_merger.hh"

/*
 * EventMerger
 */

EventMerger::EventMerger()
{
}

EventMerger::~EventMerger()
{
}

EventMergerBus        &EventMerger::operator[](unsigned int id)
{
  if (id >= KIARA_TRACKS)
    id = 0;
  return bus[id];
}

/*
 * EventMergerBus
 */

EventMergerBus::EventMergerBus()
  : chan(0)
{
}

EventMergerBus::~EventMergerBus()
{
}

void          EventMergerBus::send(Event &original)
{
  Event       e = original;

  e.set_chan(chan);
  EventBus::send(e);
}

void          EventMergerBus::set_chan(unsigned int a_chan)
{
  if (a_chan >= 16)
    a_chan = 16;
  chan = a_chan;
}

unsigned int  EventMergerBus::get_chan()
{
  return chan;
}

