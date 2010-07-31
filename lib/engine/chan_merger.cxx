
#include <iostream>
#include "chan_merger.hh"

/*
 * ChanMerger
 */

ChanMerger::ChanMerger()
{
  unsigned int i;

  for (i = 0; i < CHANNELS; i++)
    bus[i].set_chan(i % 16);
}

ChanMerger::~ChanMerger()
{
}

ChanMergerBus        &ChanMerger::operator[](unsigned int id)
{
  if (id >= CHANNELS)
    id = 0;
  return bus[id];
}

/*
 * ChanMergerBus
 */

ChanMergerBus::ChanMergerBus()
  : chan(0)
{
}

ChanMergerBus::~ChanMergerBus()
{
}

void          ChanMergerBus::send(Event &original)
{
  Event       e = original;

  e.set_chan(chan);
  EventBus::send(e);
}

void          ChanMergerBus::set_chan(unsigned int a_chan)
{
  if (a_chan >= 16)
    a_chan = 16;
  chan = a_chan;
}

unsigned int  ChanMergerBus::get_chan()
{
  return chan;
}

