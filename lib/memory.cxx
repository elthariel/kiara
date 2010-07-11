
#include "memory.hh"

Memory                 *Memory::instance = 0;

Memory                 &Memory::get()
{
  if (!Memory::instance)
    Memory::instance = new Memory();

  return *Memory::instance;
}

Rt::Chunk<Event> &Memory::event()
{
  return Memory::get().event_pool;
}

PatternStorage &Memory::pattern()
{
  return Memory::get().pattern_pool;
}

Memory::Memory()
  :event_pool(KIARA_MAXEVENTS)
{
}

