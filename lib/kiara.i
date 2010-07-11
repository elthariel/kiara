%module kiara
%{
#include "engine.hh"
%}

// %include "note.hh"

%include "bus.hh"
%template(EventBus) Bus<Event>;
%include "engine.hh"
%include "playlist.hh"
%include "pattern.hh"
%include "phrase.hh"
%include "event.hh"
%include "events_merger.hh"
%include "event_scheduler.hh"
%include "midi_out.hh"

%module PortMidi
%{
#include "/usr/include/portmidi.h"
%}
%include </usr/include/portmidi.h>
