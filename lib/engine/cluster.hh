/*
** cluster.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 31 01:45:15 2010 elthariel
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

#ifndef   	CLUSTER_HH_
# define   	CLUSTER_HH_

# include "sector.hh"

class Cluster
{
public:
  Cluster();
  ~Cluster();

  /*
   * The assignment operator of the Cluster Class is used when copy an
   * editable cluster to the read-only cluster stored in the block
   * device. We should here perform a deep copy of the different
   * Sector and of their blocks. This way, the user editable cluster
   * could continue being edited by the user and this doesn't affect
   * the cluster being played by the block device
   */
  Cluster       &operator=(const Cluster &a_cluster);
  Cluster       &operator+=(const Cluster &a_cluster);
  Sector        &operator[](unsigned int idx);

  unsigned int  get_length();
  void          set_length(unsigned int newlen);

  void          reset();
  void          merge(const Cluster &a_cluster);
protected:

  Sector        sectors[MAX_BARS_CLUSTER];
  unsigned int  length;
};

#endif	    /* !CLUSTER_HH_ */
