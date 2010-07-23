##
## build_options.cmake
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

#
# We will here set build options in order to replace manually written
# kiara-config.h
#

set (PORTTIME_PREFIX "/home/somebody/builds/portmidi")
set (PORTMIDI_PREFIX "/home/somebody/builds/portmidi")

# If you want to help cmake find swig, you'll have to add its
# installation path to the PATH env variables

# Use the more precise nanosleep based timer. (It'll work only on recent linux kernel)
set (USE_NANOSLEEP_TIMER ON)

# Release or debug mode ?
# the following build types are availables :
# [Debug|Release|RelWithDebInfo|MinSizeRel]
set (CMAKE_BUILD_TYPE RelWithDebInfo)
