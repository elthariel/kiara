
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

Rt::Chunk<NoteBlock> &Memory::note_block()
{
  return Memory::get().note_block_pool;
}

Rt::Chunk<CurveBlock> &Memory::curve_block()
{
  return Memory::get().curve_block_pool;
}

Memory::Memory()
  :event_pool(MAX_EVENTS),
   note_block_pool(MAX_NOTE_BLOCKS),
   curve_block_pool(MAX_CURVE_BLOCKS)
{
}

