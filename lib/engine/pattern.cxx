
#include <iostream>
#include "pattern.hh"

using namespace std;

Pattern::Pattern()
  :size(1)
{
}

Pattern::~Pattern()
{
}

void          Pattern::reset()
{
  unsigned int i;

  for (i = 0; i < KIARA_TRACKS; i++)
    phrases[i].reset();
}

NoteBlock        &Pattern::operator[](unsigned int track_id)
{
  if (track_id >= KIARA_TRACKS)
    return phrases[0];
  else
    return phrases[track_id];
}

void          Pattern::tick(TransportPosition pos)
{
  unsigned int i;

  if (pos.bar >= size)
    return;

  // if (pos.tick == 0)
  // cout << "Playing a pattern. cool"
  //      << pos.bar << ":"
  //      << pos.beat << endl;
  for (i = 0; i < KIARA_TRACKS; i++)
    play_track(i, pos);
}

void          Pattern::play_track(unsigned int track,
                                  TransportPosition pos)
{
  Event       *iter = phrases[track][pos];

  if (m_bus[track])
    while(iter)
    {
      m_bus[track]->send(*iter);
      iter = iter->next;
    }
}

unsigned int  Pattern::get_size()
{
  return size;
}

void          Pattern::set_size(unsigned int a_size)
{
  if (a_size > KIARA_MAXBARS)
    a_size = KIARA_MAXBARS;
  size = a_size;
}

