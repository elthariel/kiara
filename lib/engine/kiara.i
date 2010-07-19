%module kiara
%{
#include "engine.hh"
#include "bus.hh"
#include "engine.hh"
#include "transport.hh"
#include "transport_position.hh"
#include "playlist.hh"
#include "pattern.hh"
#include "pattern_storage.hh"
#include "phrase.hh"
#include "event.hh"
#include "events_merger.hh"
#include "event_scheduler.hh"
#include "midi_out.hh"
#include "memory.hh"
#include "kiara-config.h"
#include "pool.hh"
#include "timer.hh"
%}

// %include "note.hh"

// General rules
%rename("get") operator[](unsigned int);

// Event rules
%rename("chan") Event::get_chan();
%rename("chan=") Event::set_chan(unsigned char);
%rename("status") Event::get_status();
%rename("status=") Event::set_status(unsigned char);
%rename("data1") Event::get_data1();
%rename("data1=") Event::set_data1(unsigned char);
%rename("data2") Event::get_data2();
%rename("data2=") Event::set_data2(unsigned char);
%bang Event::reset();
%bang Event::cc();
%bang Event::noteon();
%bang Event::noteoff();

%bang Playlist::reset();
%bang PatternStorage::reset();
%bang Pattern::reset();
%bang Phrase::reset();

// Phrase rules
%bang Phrase::insert(unsigned int, Event *);
%bang Phrase::remove(unsigned int, Event *);

// Timer rules
%rename("bpm") Timer::get_bpm();
%rename("bpm=") Timer::set_bpm(unsigned int);

%include "bus.hh"
%template(EventBus) Bus<Event>;
%include "pool.hh"
%template(EventPool) Rt::Chunk<Event>;
%include "engine.hh"
%include "transport.hh"
%include "transport_position.hh"
%include "playlist.hh"
%include "pattern.hh"
%include "pattern_storage.hh"
%include "phrase.hh"
%include "event.hh"
%include "events_merger.hh"
%include "event_scheduler.hh"
%include "midi_out.hh"
%include "memory.hh"
%include "kiara-config.h"
%include "timer.hh"

%module PortMidi
%{
#include "/usr/include/portmidi.h"
%}
%include </usr/include/portmidi.h>

