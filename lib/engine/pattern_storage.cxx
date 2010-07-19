
#include <iostream>
#include "pattern_storage.hh"

PatternStorage::PatternStorage()
{
}

PatternStorage::~PatternStorage()
{
}

unsigned int  PatternStorage::size()
{
  return KIARA_MAXPATTERNS;
}

void          PatternStorage::reset()
{
  unsigned int i;

  for (i = 0; i < KIARA_MAXPATTERNS; i++)
    patterns[i].reset();
}

void          PatternStorage::set_event_merger(EventMerger &merger)
{
  unsigned int i, j;

  for (i = 0; i < KIARA_MAXPATTERNS; i++)
    for (j = 0; j < KIARA_TRACKS; j++)
      patterns[i].connect(&merger[j], j);
}

Pattern       &PatternStorage::operator[](unsigned int id)
{
  id--;
  if (id >= size())
    return patterns[0];
  else
    return patterns[id];
}
