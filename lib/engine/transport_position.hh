/*
** transport_position.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 03:25:25 2010 elthariel
** $Id$
**
** Author(s):
**  - elthariel <elthariel@gmail.com>
**
** Copyright (C) 2010 elthariel
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/

#ifndef   	TRANSPORT_POSITION_HH_
# define   	TRANSPORT_POSITION_HH_

#include "kiara-config.h"

struct TransportPosition
{
public:
  TransportPosition(unsigned int bar,
                    unsigned int beat,
                    unsigned int tick = 0);
  TransportPosition(unsigned int ticks);
  TransportPosition();

  TransportPosition     &operator+=(TransportPosition&);
  TransportPosition     &operator-=(TransportPosition&);
  TransportPosition     operator+(TransportPosition x);
  TransportPosition     operator-(TransportPosition x);
  TransportPosition     &operator++();
  TransportPosition     &operator--();
  TransportPosition     &operator=(TransportPosition&);
  TransportPosition     &operator=(unsigned int);
  operator unsigned int() const;
  unsigned int          to_i() {*this;}
  void                  reset();


  unsigned int          bar;
  unsigned int          beat;
  unsigned int          tick;
};

bool                    operator==(TransportPosition&, TransportPosition&);
bool                    operator!=(const TransportPosition&, const TransportPosition&);
bool                    operator>(const TransportPosition&, const TransportPosition&);
bool                    operator>=(const TransportPosition&, const TransportPosition&);
bool                    operator<(const TransportPosition&, const TransportPosition&);
bool                    operator<=(const TransportPosition&, const TransportPosition&);


#endif	    /* !TRANSPORT_POSITION_HH_ */
