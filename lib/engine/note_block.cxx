
#include <iostream>
#include <cstring>
#include <assert.h>

#include "note_block.hh"
#include "memory.hh"

using namespace std;

NoteBlock::NoteBlock()
{
  reset();
}

NoteBlock::~NoteBlock()
{
  for (int i = 0; i < PPQ * 4 * MAX_BARS; ++i)
    if (data[i])
    {
      Event     *iter = data[i];
      Event     *to_delete = 0;

      while (iter)
      {
        to_delete = iter;
        iter = iter->next;
        delete to_delete;
      }

      data[i] = 0;
    }
}

void          *NoteBlock::operator new(size_t sz)
{
  assert(sz == sizeof(NoteBlock));

  return Memory::note_block().alloc();
}

void          NoteBlock::operator delete(void *p)
{
  if (p)
    Memory::note_block().dealloc((NoteBlock *)p);
}

Event         *NoteBlock::operator[](unsigned int tick)
{
  if (tick >= PPQ * 4 * MAX_BARS)
    return data[0];
  else
    return data[tick];
}

Event         *NoteBlock::get_note_on_tick(unsigned int tick,
                                        unsigned int max_bar,
                                        unsigned char note)
{
  unsigned int i;
  Event *iter = 0;

  if (max_bar > MAX_BARS)
    max_bar = MAX_BARS;

  for (i = 0; i < max_bar * 4 * PPQ; i++)
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

bool          NoteBlock::insert(unsigned int tick, Event *e)
{
  if (tick > MAX_BARS * PPQ * 4 || e == 0)
    return false;

  Event *iter = data[tick];

  e->next = data[tick];
  data[tick] = e;

  return true;
}

bool          NoteBlock::remove(unsigned int tick, Event *e)
{
  if (tick > MAX_BARS * PPQ * 4 || e == 0)
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

int           NoteBlock::next_used_tick(unsigned int tick)
{
  unsigned int i;

  for (i = tick; i < MAX_BARS * PPQ * 4; i++)
    if (data[i])
      return i;
  return -1;
}

void          NoteBlock::reset()
{
  memset(&data, 0, sizeof(data));
}


