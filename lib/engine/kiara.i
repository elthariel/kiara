%module kiara
%{
#include "engine.hh"
#include "bus.hh"
#include "engine.hh"
#include "transport.hh"
#include "transport_position.hh"
#include "block.hh"
#include "note_block.hh"
#include "curve_block.hh"
#include "event.hh"
#include "chan_merger.hh"
#include "note_scheduler.hh"
#include "midi_out.hh"
#include "memory.hh"
#include "kiara-config.h"
#include "pool.hh"
#include "timer.hh"
#include "sector.hh"
#include "cluster.hh"
#include "block_device.hh"
// #include "boost/shared_ptr.hpp"
%}


// General rules
%rename("get") operator[](unsigned int);
%rename("valid?") valid();
%rename("nil?") nil();

namespace boost
{
  template<class T> T * get_pointer(shared_ptr<T> const & p);
  template<class T> class shared_ptr
  {
  public:
    T * operator->() const;
    %extend {
      bool      valid()
      {
        return boost::get_pointer<T>(*$self) != 0;
      }
    }
    %extend {
      bool      nil()
      {
        return boost::get_pointer<T>(*$self) == 0;
      }
    }
  };
}

%ignore boost::shared_ptr::get();
%ignore NoteBlockPtr::get();

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

// Block rules
%rename("length") Block::get_length();
%rename("length=") Block::set_length(unsigned int);

// NoteBlock rules
%bang NoteBlock::reset();
%bang NoteBlock::insert(unsigned int, Event *);
%bang NoteBlock::remove(unsigned int, Event *);

// CurveBlock rules
%bang CurveBlock::reset();
%rename("empty?") CurveBlock::is_empty();

// Sector rules
%bang Sector::merge(const Sector &);
%bang Sector::reset();

// Cluster rules
%bang Cluster::merge(const Cluster &);
%bang Cluster::reset();
%rename("length") Cluster::get_length();
%rename("length=") Cluster::set_length(unsigned int);

// BlockDevice rules
%rename("length") BlockDevice::get_length();
%rename("break_triggered?") BlockDevice::is_break_triggered();
%rename("interrupt_triggered?") BlockDevice::is_interrupt_triggered();
%bang BlockDevice::trigger_break();
%bang BlockDevice::trigger_interrupt();
%rename("interrupt_time") BlockDevice::interrupt_time();
%rename("current_start_time") BlockDevice::current_start_time();

// Timer rules
%rename("bpm") Timer::get_bpm();
%rename("bpm=") Timer::set_bpm(unsigned int);

%include "bus.hh"
%template(EventBus) Bus<Event>;
%include "pool.hh"
%template(EventPool) Rt::Chunk<Event>;
%template(NoteBlockPool) Rt::Chunk<NoteBlock>;
%template(CurveBlockPool) Rt::Chunk<CurveBlock>;
%include "engine.hh"
%include "transport.hh"
%include "transport_position.hh"
%include "block.hh"
%include "note_block.hh"
%include "curve_block.hh"
%template(NoteBlockPtr) boost::shared_ptr<NoteBlock>;
%template(CurveBlockPtr) boost::shared_ptr<CurveBlock>;
// shared_ptr rules
/* %rename ("valid?") NoteBlockPtr::valid(); */
/* %rename ("nil?") NoteBlockPtr::nil(); */
/* %rename ("valid?") CurveBlockPtr::valid(); */
/* %rename ("nil?") CurveBlockPtr::nil(); */
%include "event.hh"
%include "chan_merger.hh"
%include "note_scheduler.hh"
%include "midi_out.hh"
%include "memory.hh"
%include "kiara-config.h"
%include "timer.hh"
%include "sector.hh"
%include "cluster.hh"
%include "block_device.hh"

%module PortMidi
%{
#include "../../include/portmidi.h"
%}
%include <../../include/portmidi.h>

