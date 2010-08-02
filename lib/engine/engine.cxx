
#include <iostream>

#include "engine.hh"

Engine::Engine()
  : m_device(m_loop, m_break, m_interrupt)
{
  unsigned int i;

  Memory::get();

  Pm_Initialize();
  m_timer.set_transport(&m_transport);
  m_timer.set_scheduler(&m_scheduler);
  m_transport.connect(&m_device, 0);
  for (i = 0; i < CHANNELS; i++)
  {
    m_device.connect(&m_merger[i], i);
    m_merger[i].connect(&m_scheduler[i]);
    m_scheduler[i].connect(&m_out);
  }
}

Engine::~Engine()
{
}

Timer                         &Engine::timer()
{
  return m_timer;
}

Transport                     &Engine::transport()
{
  return m_transport;
}

ChanMerger                   &Engine::merger()
{
  return m_merger;
}

NoteScheduler                &Engine::scheduler()
{
  return m_scheduler;
}

MidiOut                       &Engine::midi_out()
{
  return m_out;
}

Cluster                       &Engine::loop()
{
  return m_loop;
}

Cluster                       &Engine::dabreak()
{
  return m_break;
}

Cluster                       &Engine::interrupt()
{
  return m_interrupt;
}

BlockDevice                   &Engine::device()
{
  return m_device;
}

void            Engine::start()
{
  std::cout << "Starting Kiara Engine" << std::endl;
  engine_thread = boost::thread(boost::ref(m_timer));
  // m_transport.start();
}

void            Engine::stop()
{
  m_timer.kill();
  engine_thread.join();
}

