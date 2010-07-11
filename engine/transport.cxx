
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
    ++position;
    if (looping && position >= loop_end)
    {
      position = loop_start;
      cout << "Looping !" << endl;
    }

    // Using EventBus to trigger linked busses.
    tick(position);

    if (position.tick == 0)
      cout << "Pos: " << position.bar
           << "-" << position.beat << endl;
  }
}

void                  Transport::start()
{
  playing = true;
}

void                  Transport::stop()
{
  playing = false;
  position = loop_start;
}

void                  Transport::pause()
{
  playing = !playing;
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

