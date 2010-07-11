
#include <iostream>

#include "engine.hh"

Engine::Engine()
{
  unsigned int i;

  Memory::get();

  m_timer.set_transport(&m_transport);
  m_transport.connect(&m_scheduler, 0);
  m_transport.connect(&m_playlist, 1);
  Memory::pattern().set_event_merger(m_merger);
  for (i = 0; i < KIARA_TRACKS; i++)
  {
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

Playlist                      &Engine::playlist()
{
  return m_playlist;
}

EventMerger                   &Engine::merger()
{
  return m_merger;
}

EventScheduler                &Engine::scheduler()
{
  return m_scheduler;
}

void            Engine::start()
{
  std::cout << "Starting Kiara Engine" << std::endl;
  engine_thread = boost::thread(boost::ref(m_timer));
  m_transport.start();
}

void            Engine::stop()
{
  m_timer.kill();
  engine_thread.join();
}

