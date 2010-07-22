
#include <iostream>
#include <cstring>
#include "phrase.hh"

using namespace std;

Phrase::Phrase()
{
  reset();
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
  if (tick > KIARA_MAXBARS * KIARA_PPQ * 4 || e == 0)
    return false;

  Event *iter = data[tick];

  e->next = data[tick];
  data[tick] = e;

  return true;
}

bool          Phrase::remove(unsigned int tick, Event *e)
{
  if (tick > KIARA_MAXBARS * KIARA_PPQ * 4 || e == 0)
    return false;

  Event *iter = data[tick];

  if (iter == e)
  {
    // cout << "Removing first element" << e
    //      << ", next: " << iter->next
    //      << endl;
    data[tick] = iter->next;
    return true;
  }

  while (iter && iter->next)
  {
    if (iter->next == e)
    {
      // cout << "Removing first element" << e
      //      << ", next: " << iter->next
      //      << ", next: " << iter->next->next
      //      << endl;
      iter->next = iter->next->next;
      return true;
    }
    iter = iter->next;
  }
  return false;
}

int           Phrase::next_used_tick(unsigned int tick)
{
  unsigned int i;

  for (i = tick; i < KIARA_MAXBARS * KIARA_PPQ * 4; i++)
    if (data[i])
      return i;
  return -1;
}

void          Phrase::reset()
{
  memset(&data, 0, sizeof(data));
}


