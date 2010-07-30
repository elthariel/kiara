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
#include "note_block.hh"
#include "event.hh"
#include "chan_merger.hh"
#include "note_scheduler.hh"
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
%rename("noteon?") Event::is_noteon();
%rename("noteoff?") Event::is_noteoff();
%rename("cc?") Event::is_cc();
%bang Event::reset();
%bang Event::cc();
%bang Event::noteon();
%bang Event::noteoff();

%bang Playlist::reset();
%bang PatternStorage::reset();
%bang Pattern::reset();
%bang NoteBlock::reset();

// NoteBlock rules
%bang NoteBlock::insert(unsigned int, Event *);
%bang NoteBlock::remove(unsigned int, Event *);

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
%include "note_block.hh"
%include "event.hh"
%include "chan_merger.hh"
%include "note_scheduler.hh"
%include "midi_out.hh"
%include "memory.hh"
%include "kiara-config.h"
%include "timer.hh"

%module PortMidi
%{
#include "../../include/portmidi.h"
%}
%include <../../include/portmidi.h>

