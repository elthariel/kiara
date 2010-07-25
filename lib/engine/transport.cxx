
#include <iostream>
#include "transport.hh"

using namespace std;

Transport::Transport()
  : playing(false),
    looping(true),
    loop_end(4, 0, 0)
{
}

Transport::~Transport()
{
}

void                  Transport::trigger_tick()
{
  if (playing)
  {
    // Using EventBus to trigger linked busses.
    tick(position);

    // FIXME This only works for PPQ = 48
    // Out ppq = 48, midi clock one's 24
    if (position.tick % 2 == 0)
    {
      Event     midi_tick;
      midi_tick.midi[0] = 0xF8;
      m_midi_clock.send(midi_tick);
    }

    /*
     * After we played current tick, we jump to next tick
     * and if necessary we loop back.
     */
    ++position;
    if (looping && position >= loop_end)
      position = loop_start;
  }
}

void                  Transport::start()
{
  playing = true;

  Event     clock;
  clock.midi[0] = 0xFA;
  m_midi_clock.send(clock);
}

void                  Transport::stop()
{
  playing = false;
  position = loop_start;

  Event     clock;
  clock.midi[0] = 0xFC;
  m_midi_clock.send(clock);
}

void                  Transport::pause()
{
  playing = !playing;

  Event     clock;
  clock.midi[0] = playing ? 0xFB : 0xFC;
  m_midi_clock.send(clock);
}

void                  Transport::loop(bool enable_loop)
{
  looping = enable_loop;
}

void                  Transport::jump(TransportPosition pos)
{
  // FIXME Notify somebody that will kill note-on if necessary.
  position = pos;
}

bool                  Transport::is_playing()
{
  return playing;
}

bool                  Transport::is_looping()
{
  return looping;
}

void                  Transport::set_loop_start(TransportPosition start)
{
  loop_start = start;
}

void                  Transport::set_loop_end(TransportPosition end)
{
  loop_end = end;
}

TransportPosition     Transport::get_loop_start()
{
  return loop_start;
}

TransportPosition     Transport::get_loop_end()
{
  return loop_end;
}

TransportPosition     Transport::get_position()
{
  return position;
}

EventBus              &Transport::midi_clock()
{
  return m_midi_clock;
}

