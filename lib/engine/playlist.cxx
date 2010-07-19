
#include <iostream>
#include <cstring>
#include "playlist.hh"
#include "memory.hh"

using namespace std;

Playlist::Playlist()
{
  reset();
}

void          Playlist::reset()
{
  memset(&patterns, 0, sizeof(patterns));
}

int           Playlist::get_pos(unsigned int track,
                                unsigned int bar)
{
  if (track < KIARA_PLSTRACKS && bar < KIARA_PLSLEN)
    return patterns[track][bar];
  return 0;
}

bool          Playlist::set_pos(unsigned int track,
                      unsigned int bar,
                      unsigned pattern_id)
{
  // FIXME handle pattern longer that 1 bar
  //  using the negative value stuff
  if (track < KIARA_PLSTRACKS && bar < KIARA_PLSLEN)
    patterns[track][bar] = pattern_id;
}

void          Playlist::tick(TransportPosition pos)
{
  // static int z = 0;
  // z = (z + 1) % 20;
  // if (z == 0)
  //   cout << "Playlist: tick" << endl;

  unsigned int i;

  for (i = 0; i < KIARA_PLSTRACKS; i++)
  {
    TransportPosition relative_pos;

    if (patterns[i][pos.bar] > 0)
      // simple case, we are on a pattern start
      relative_pos = TransportPosition(0, pos.beat, pos.tick);
    else if (patterns[i][pos.bar] < 0)
    {
      unsigned int start = get_pattern_start(i, pos.bar);
      relative_pos = TransportPosition(pos.bar - start, pos.beat, pos.tick);
    }
    else
      continue; // Nothing to play, we skip tick();

    Memory::pattern()[patterns[i][pos.bar]].tick(relative_pos);
  }
}

unsigned      Playlist::get_pattern_start(unsigned int track,
                                          unsigned int bar)
{
  if (track >= KIARA_PLSTRACKS && bar >= KIARA_PLSLEN
      && patterns[track][bar] >= 0)
    return 0;

  while (patterns[track][bar] < 0 && bar)
    bar--;

  return bar;
}

