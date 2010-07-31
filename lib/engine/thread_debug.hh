/*
** thread_debug.hh
** Login : <elthariel@rincevent>
** Started on  Sat Jul 31 15:49:26 2010 elthariel
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

#ifndef   	THREAD_DEBUG_HH_
# define   	THREAD_DEBUG_HH_

# include <assert.h>
# include <boost/thread.hpp>

extern boost::thread::id __rt_thread_id;

# define        I_AM_THE_RT_THREAD __rt_thread_id = boost::this_thread::get_id();

# define        ASSERT_RT_THREAD assert(boost::this_thread::get_id == __rt_thread_id);
# define        ASSERT_NONRT_THREAD assert(boost::this_thread::get_id != __rt_thread_id);

#endif	    /* !THREAD_DEBUG_HH_ */
