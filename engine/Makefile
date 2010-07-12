##
## Makefile
## Login : <elthariel@rincevent>
## Started on  Wed Jul  7 22:43:10 2010 elthariel
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

### Config variables
RUBYINC =	/usr/include/ruby-1.9.0
RUBYARCH =	x86_64-linux
SWIG =		/usr/bin/swig
SWIGFLAGS =	-c++ -ruby -ignoremissing
RUBY =		/usr/bin/ruby1.9
CXX =		/usr/bin/g++
LDADD =		-lportmidi -lboost_thread
LDFLAGS =	-shared
CXXFLAGS =	-g -O2 -fPIC -I$(RUBYINC) -I$(RUBYINC)/$(RUBYARCH)

NAME =		kiara.so
OBJS =		kiara_wrap.o event.o engine.o timer.o \
		transport.o transport_position.o memory.o \
		phrase.o playlist.o pattern.o \
		pattern_storage.o events_merger.o \
		event_scheduler.o midi_out.o
SRCS =		$(OBJS:.o=.cxx)

all: $(NAME)

$(NAME): $(OBJS)
	$(CXX) $(CXXFLAGS) $(LDADD) $(LDFLAGS) -o $@ $(OBJS)

%_wrap.o: %_wrap.cxx
	$(CXX) $(CXXFLAGS) -w -c -o $@ $<

%.o: %.cxx
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%_wrap.cxx: %.i
	$(SWIG) $(SWIGFLAGS) $<

clean:
	rm -rf $(NAME) $(OBJS)
	rm -f kiara_wrap.cxx

re: clean all
c : clean

.PHONY: all clean re
