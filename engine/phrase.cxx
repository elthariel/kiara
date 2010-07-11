
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

Event         *&Phrase::operator[](unsigned int tick)
{
  if (tick >= KIARA_PPQ * 4 * KIARA_MAXBARS)
    return data[0];
  else
    return data[tick];
}


