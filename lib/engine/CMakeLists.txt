##
## lib/engine/CmakeLists.txt
## Login : <elthariel@rincevent>
## Started on  Fri Jul 23 02:18:34 2010 elthariel
## $Id$
##
## Author(s):
##  - elthariel <elthariel@gmail.com>
##
## Copyright (C) 2010 elthariel
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
##

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(kiara_SOURCES engine.cxx
  event.cxx
  event_scheduler.cxx
  events_merger.cxx
  memory.cxx
  midi_out.cxx
  pattern.cxx
  pattern_storage.cxx
  phrase.cxx
  playlist.cxx
  transport.cxx
  transport_position.cxx
  )

if (UNIX)
  set(kiara_SOURCES ${kiara_SOURCES} timer_linux.cxx)
else (UNIX)
  set(kiara_SOURCES ${kiara_SOURCES} timer.cxx)
endif (UNIX)

include(${SWIG_USE_FILE})
include_directories(${PORTTIME_INCLUDE})
include_directories(${PORTMIDI_INCLUDE})
include_directories(${RUBY_INCLUDE_DIRS})
include_directories(${Boost_INCLUDE_DIRS})

set(CMAKE_SWIG_FLAGS "")

SET_SOURCE_FILES_PROPERTIES(kiara.i PROPERTIES CPLUSPLUS ON)
SET_SOURCE_FILES_PROPERTIES(kiara.i PROPERTIES SWIG_FLAGS "-w801 -ignoremissing")
SWIG_ADD_MODULE(kiara ruby kiara.i ${kiara_SOURCES})
SWIG_LINK_LIBRARIES(kiara ${PORTTIME_LIBRARY} ${PORTMIDI_LIBRARY} ${Boost_LIBRARIES})
SET_TARGET_PROPERTIES(kiara PROPERTIES PREFIX "")
SET_SOURCE_FILES_PROPERTIES(kiaraRUBY_wrap.cxx PROPERTIES COMPILE_FLAGS "-w")





