
#include <iostream>
#include <typeinfo>
#include "bus.hh"

using namespace std;

template <class T>
Bus<T>::Bus()
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

  for (i = 0; i < KIARA_TRACKS; i++)
    if (m_bus[i])
      m_bus[i]->tick(pos);

  // static int zzz = 0;
  // zzz = (zzz + 1) % 100;
  // if (zzz == 0)
  //   cout << typeid(*this).name()
  //        << ": tick" << endl;
}

