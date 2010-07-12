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
%}

// %include "note.hh"

%rename("get") operator[](unsigned int);

%include "bus.hh"
%template(EventBus) Bus<Event>;
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

%module PortMidi
%{
#include "/usr/include/portmidi.h"
%}
%include </usr/include/portmidi.h>

