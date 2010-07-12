
#include <iostream>
#include <cstring>
#include "phrase.hh"

using namespace std;

Phrase::Phrase()
{
  memset(&data, 0, sizeof(data));
}

Phrase::~Phrase()
{
  // FIXME dealloc all events.
}

Event         *Phrase::operator[](unsigned int tick)
{
  if (tick >= KIARA_PPQ * 4 * KIARA_MAXBARS)
    return data[0];
  else
    return data[tick];
}

Event         *Phrase::get_note_on_tick(unsigned int tick,
                                        unsigned int max_bar,
                                        unsigned char note)
{
  unsigned int i;
  Event *iter = 0;

  if (max_bar > KIARA_MAXBARS)
    max_bar = KIARA_MAXBARS;

  for (i = 0; i < max_bar * 4 * KIARA_PPQ; i++)
  {
    iter = data[i];
    while (iter)
    {
      if (iter->midi[1] == note && tick >= i && tick < i + iter->duration)
        return iter;
      iter = iter->next;
    }
  }
  return iter;
}

bool          Phrase::insert(unsigned int tick, Event *e)
{
  if (tick > KIARA_MAXBARS * KIARA_PPQ * 4)
    return false;

  Event *iter = data[tick];

  if (!iter)
    data[tick] = e;
  else
  {
    while (iter->next)
      iter = iter->next;
    iter->next = e;
  }

  return true;
}

