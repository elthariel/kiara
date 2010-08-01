/*
** curve_block.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 31 02:36:40 2010 elthariel
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

#ifndef   	CURVE_BLOCK_HH_
# define   	CURVE_BLOCK_HH_

# include "block.hh"

class CurveBlock : public Block
{
public:
  CurveBlock();
  // deep copy (if it means anything for such data
  CurveBlock(const CurveBlock &a_block);
  ~CurveBlock();
  /*
   * Overload new and delete operator to avoid calls to malloc but
   * instead use our own allocator (memory pool / Rt::Chunk)
   */
  void          *operator new(size_t);
  void          operator delete(void *);


  char          &operator[](unsigned int idx);

  bool          is_empty();
  void          reset();
protected:
  /*
   * This is not a string! This is an array of cc values (data 2). If
   * value is < 0 then the current value is considered not set, the
   * current value is the last value >= 0. If all the values are
   * negative, the curve is empty.
   */
  char          curve[PPQ * 4 * MAX_BARS];
  unsigned int  length;
};

#endif	    /* !CURVE_BLOCK_HH_ */
