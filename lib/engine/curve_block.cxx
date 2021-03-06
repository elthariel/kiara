/*
** curve_block.cxx
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

#include <iostream>
#include <cstring>
#include <assert.h>

#include "curve_block.hh"
#include "memory.hh"

CurveBlock::CurveBlock()
{
  reset();
}

CurveBlock::~CurveBlock()
{
}

void          *CurveBlock::operator new(size_t sz)
{
  assert(sz == sizeof(CurveBlock));

  return Memory::curve_block().alloc();
}

void          CurveBlock::operator delete(void *p)
{
  if (p)
    Memory::curve_block().dealloc((CurveBlock *)p);
}

CurveBlockPtr CurveBlock::create()
{
  CurveBlockPtr ptr(new CurveBlock);

  return ptr;
}

CurveBlockPtr CurveBlock::create(const CurveBlock &block)
{
  CurveBlockPtr ptr(new CurveBlock(block));

  return ptr;
}


CurveBlockPtr create(const CurveBlock &a_block);

char          &CurveBlock::operator[](unsigned int idx)
{
  assert (idx < PPQ * 4 * MAX_BARS);

  if (idx >= PPQ * 4 * length)
    idx = PPQ * 4 * length - 1;

  return curve[idx];
}

bool          CurveBlock::is_empty()
{
  unsigned int i;

  for (i = 0; i < PPQ * 4 * length; i++)
    if (curve[i] >= 0)
      return false;

  return true;
}

void          CurveBlock::reset()
{
  Block::reset();
  memset(&curve, -1, sizeof(curve));
}

/*
 *  Etudiant dans la / En nageant dans la
 *  Piscine pleine de vague
 *  Il implore l'abysse
 *
 *  //Tek 5 en plein
 *  //Eip, serein et sage
 *  //Charme les precipices
 *
 *  Tournent bien des lunes
 *  Encore, et hardi il
 *  Charme les precipices
 *
 * -Haijin
 */

