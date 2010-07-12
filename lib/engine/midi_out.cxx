
#include <iostream>
#include "midi_out.hh"

using namespace std;

MidiOut::MidiOut() :out(0), id(0) {}
MidiOut::~MidiOut()
{
  if (out)
    Pm_Close(out);
}

// Call from the gui thread
unsigned MidiOut::get_out()
{
  return id;
}

// Call from the gui thread
void    MidiOut::set_out(unsigned a_id)
{
  PortMidiStream *new_stream = 0, *old_stream = 0;;

  if (!Pm_OpenOutput(&new_stream, a_id, 0, 10, 0, 0, 0))
  {
    cout << "Opened a new MidiOut" << endl;
    id = a_id;
    old_stream = out;
    out = new_stream;
    if (old_stream)
      Pm_Close(old_stream);
  }
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
    cout << "MidiOut: should not be ticking" << endl;
}
