/*
** cluster.cxx
** Login : <elthariel@rincevent>
** Started on  Sat Jul 31 22:26:04 2010 elthariel
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

#include <iostream>
#include <assert.h>

#include "cluster.hh"

using namespace std;

Cluster::Cluster()
  : length(4)
{
}

Cluster::~Cluster()
{
}

Cluster       &Cluster::operator=(const Cluster &a_cluster)
{
  if (this == &a_cluster)
    return *this;

  for (int i = 0; i < length; ++i)
    sectors[i] = a_cluster.sectors[i];
  length = a_cluster.length;
  return *this;
}

Cluster       &Cluster::operator+=(const Cluster &a_cluster)
{
  merge(a_cluster);
  return *this;
}

Sector        &Cluster::operator[](unsigned int idx)
{
  assert(idx < MAX_BARS_CLUSTER);

  if (idx >= length)
    idx = length;
  return sectors[idx];
}

unsigned int  Cluster::get_length()
{
  return length;
}

void          Cluster::set_length(unsigned int newlen)
{
  assert(newlen < MAX_BARS_CLUSTER);

  length = newlen;
}

void          Cluster::reset()
{
  for (int i = 0; i < MAX_BARS_CLUSTER; ++i)
    sectors[i].reset();
}

void          Cluster::merge(const Cluster &a_cluster)
{
  unsigned int min = length < a_cluster.length ? length : a_cluster.length;

  for (int i = 0; i < min; ++i)
    sectors[i] += a_cluster.sectors[i];
}

