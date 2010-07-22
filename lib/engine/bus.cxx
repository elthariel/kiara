
#include <iostream>
#include <typeinfo>
#include "bus.hh"

using namespace std;

template <class T>
Bus<T>::Bus()
  : m_send_ticks(true)
{
  unsigned int i;

  for (i = 0; i < KIARA_TRACKS; i++)
    m_bus[i] = 0;
}

template <class T>
Bus<T>::~Bus()
{
}

template <class T>
void  Bus<T>::connect(Bus<T> *a_bus, unsigned int bus_id)
{
  if (bus_id <= KIARA_TRACKS)
    m_bus[bus_id] = a_bus;
}

template <class T>
void  Bus<T>::send(T &e)
{
  unsigned int i;

  for (i = 0; i < KIARA_TRACKS; i++)
    if (m_bus[i])
      m_bus[i]->send(e);
}

template <class T>
void  Bus<T>::tick(TransportPosition pos)
{
  unsigned int i;

  if (m_send_ticks)
    for (i = 0; i < KIARA_TRACKS; i++)
      if (m_bus[i])
        m_bus[i]->tick(pos);
}

// /*
//  * Control wether the bus sends ticks to its connected busses.
//  */
// template <class T>
// virtual void  Bus<T>::set_send_ticks(bool send_tick = true)
// {
//   m_send_ticks = send_tick;
// }

// template <class T>
// virtual bool  Bus<T>::get_send_ticks()
// {
//   return m_send_ticks;
// }
