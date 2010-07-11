
#include <iostream>
#include "midi_out.hh"

using namespace std;

MidiOut::MidiOut() :out(0) {}
MidiOut::~MidiOut() {}

PortMidiStream  *MidiOut::get_out()
{
  return out;
}

void    MidiOut::set_out(PortMidiStream *a_out)
{
  out = a_out;
}

void    MidiOut::send(Event &e)
{
  if (!out)
    return;

  Pm_WriteShort(out, 0, Pm_Message(e.midi[0],
                                   e.midi[1],
                                   e.midi[2]));
}

// End point, disabling connection.
void    MidiOut::connect(EventBus *a_bus,
                         unsigned int bus_id)
{
}

// End point, we doesn't use nor need to relay ticks
void    MidiOut::tick(TransportPosition pos)
{
  static int zzz = 0;
  zzz = (zzz + 1) % 50;
  if (zzz == 0)
    cout << "MidiOut: tick" << endl;
}
