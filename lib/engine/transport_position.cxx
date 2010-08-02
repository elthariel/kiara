
#include <iostream>
#include "transport_position.hh"

TransportPosition::TransportPosition(unsigned int a_bar,
                                     unsigned int a_beat,
                                     unsigned int a_tick)
  :bar(a_bar),
   beat(a_beat),
   tick(a_tick)
{
}

TransportPosition::TransportPosition(unsigned int ticks)
{
  (*this) = ticks;
}

TransportPosition::TransportPosition()
  :bar(0),
   beat(0),
   tick(0)
{
}

TransportPosition     &TransportPosition::operator+=(TransportPosition &tp)
{
  // unsigned int        tmp;

  // tmp = tp.tick + tick;
  // tick = tmp % PPQ;
  // tmp = tp.beat + beat + tmp / PPQ;
  // beat = tmp % 4;
  // tmp = tp.bar + bar + tmp / 4;
  *this = (unsigned int)*this + (unsigned int) tp;

  return *this;
}

TransportPosition     &TransportPosition::operator-=(TransportPosition  &other)
{
  if (other >= *this)
    reset();
  else
    *this = (unsigned int)*this - (unsigned int)other;
  return *this;
}

TransportPosition     TransportPosition::operator+(TransportPosition x)
{
  return TransportPosition((unsigned int) (*this) + (unsigned int) x);
}

TransportPosition     TransportPosition::operator-(TransportPosition x)
{
  return TransportPosition((unsigned int) (*this) - (unsigned int) x);
}

TransportPosition     &TransportPosition::operator++()
{
  TransportPosition increment(0, 0, 1);
  return *this += increment;
}

TransportPosition     &TransportPosition::operator--()
{
  TransportPosition increment(0, 0, 1);
  return *this -= increment;
}

TransportPosition     &TransportPosition::operator=(TransportPosition &other)
{
  tick = other.tick;
  beat = other.beat;
  bar = other.bar;
}

TransportPosition     &TransportPosition::operator=(unsigned int value)
{
  bar = value / (PPQ * 4);
  value = value % (PPQ * 4);
  beat = value / PPQ;
  tick = value % PPQ;
}

TransportPosition::operator unsigned int() const
{
  return tick + beat * PPQ + bar * 4 * PPQ;
}

bool                  operator==(TransportPosition &a, TransportPosition &b)
{
  return (a.bar == b.bar && a.beat == b.beat && a.tick == b.tick);
}

bool                  operator!=(const TransportPosition &a, const TransportPosition &b)
{
  return !(a == b);
}

bool                  operator>(const TransportPosition &a, const TransportPosition &b)
{
  return (unsigned int)a > (unsigned int)b;
}

bool                  operator>=(const TransportPosition &a, const TransportPosition &b)
{
  return (a > b) || (a == b);
}

bool                  operator<(const TransportPosition &a, const TransportPosition &b)
{
  return (unsigned int)a < (unsigned int)b;
}

bool                  operator<=(const TransportPosition &a, const TransportPosition &b)
{
  return (a < b) || (a == b);
}

void                  TransportPosition::reset()
{
  bar = 0;
  beat = 0;
  tick = 0;
}

