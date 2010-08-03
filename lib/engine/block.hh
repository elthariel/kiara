/*
** base_block.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 31 02:37:51 2010 elthariel
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

#ifndef   	BLOCK_HH_
# define   	BLOCK_HH_

# include "kiara-config.h"

class Block
{
public:
  typedef unsigned int  Id;
  enum {INVALID_ID = 0};

  Block();
  Block(const Block &a_block);

  virtual Block         &operator=(const Block &a_block);

  virtual unsigned int  get_length();
  virtual void          set_length(unsigned int newlen);
  virtual void          reset();

  /*
   * Has the block been modified since the last time it was saved
   */
  bool          get_modified();
  /*
   * You should not call this method, unless you know what you are
   * doing. It is for use with the BlockBox and serialisation code.
   */
  void          set_modified(bool modified = false);

  /*
   * Return the id of the document storing the block filename and
   * metadatas in the index. If get_modified is true, the document
   * corresponding to the id is for an old version of the block,
   * i.e. the block has been modified since the id was attributed.
   */
  Id            get_xapian_id();
  /*
   * Update the id when saving the block.
   */
  void          set_xapian_id(Id new_id = INVALID_ID);
protected:
  unsigned int  length;
  /*
   * Has the object been modified since it's last save
   */
  bool          m_modified;
  /*
   * Used by the BlockBox, to fetch back tags and name for a given
   * block.
   */
  Id            m_xapian_id;
};

#endif	    /* !BLOCK_HH_ */
