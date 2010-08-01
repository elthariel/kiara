/*
** note.hh
** Login : <elthariel@rincevent>
** Started on  Thu Jul  8 00:33:48 2010 elthariel
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

#ifndef   	NOTE_HH_
# define   	NOTE_HH_

#include <stdint.h>

// FIXME, packed attribute is not defined
//struct __attribute__((packed)) Event
struct Event
{
  Event();

  /*
   * Copy Constructor. this->next is reset to 0
   */

  Event(const Event &an_event);

  // this->next is reset to 0
  Event         &operator=(const Event& an_event);

  /*
   * Overload new and delete operator to avoid calls to malloc but
   * instead use our own allocator (memory pool / Rt::Chunk)
   */
  void          *operator new(size_t sz);
  void          operator delete(void *e);

  Event         *next;
  char          midi[3];
  char          flags;
  unsigned short duration; // will store duration for notes.

  void          reset();

  void          set_chan(unsigned char);
  unsigned char get_chan();
  void          set_status(unsigned char);
  unsigned char get_status();
  void          set_data1(unsigned char);
  unsigned char get_data1();
  void          set_data2(unsigned char);
  unsigned char get_data2();
  void          noteon();
  void          noteoff();
  void          cc();

  bool          is_noteon();
  bool          is_noteoff();
  bool          is_cc();
};

#endif	    /* !NOTE_HH_ */
