#ifndef   	POOL_HH_
# define   	POOL_HH_

# ifdef HAVE_CONFIG_H
# include "config.h"
# endif

# include "sys/types.h"

namespace Rt
{

  /*!
  ** \brief Pool based memory manager (1).
  ** This allocator is not thread safe.
  * \todo Handle alignment
  * \todo Touches all memory pages to truly alloc
  * \todo mlock
  */

  template <class T>
  class Chunk
  {
  public:
    typedef size_t    address;

  public:
    Chunk(unsigned int a_chunk_capacity);
    ~Chunk();

    /// \return 0 if there is no more memory available in this chunk.
    T                           *alloc();
    void                        dealloc(T *);

    void                        debug_free(); /// \internal display the free chunk lifo.
  protected:
    unsigned int                m_chunk_capacity;
    volatile unsigned int       m_free_chunks;
    void                        *m_heap;
    address                     *m_free;
    Chunk                       *m_next_chunk; /// Unused for the moment, this will serve for chaining chunk
  };
}

#include "pool.cxx"

#endif	    /* !POOL_HH_ */


