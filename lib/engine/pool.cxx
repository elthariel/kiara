
#include <iostream>
#include <cstdlib>
#include "pool.hh"

namespace Rt
{
  template <class T>
  Chunk<T>::Chunk(unsigned int a_chunk_capacity)
    :m_free_chunks(a_chunk_capacity),
     m_chunk_capacity(a_chunk_capacity),
     m_next_chunk(0) // Unused for the moment
  {
    m_heap = malloc(sizeof(T) * a_chunk_capacity);
    m_free = (address *)malloc(a_chunk_capacity * sizeof(address));
    reset();
  }

  template <class T>
  Chunk<T>::~Chunk()
  {
    free(m_heap);
  }

  template <class T>
  T                   *Chunk<T>::alloc()
  {
    address               p;
    ///  \todo support chunk chaining
    if(m_free_chunks)
      {
        p = m_free[m_free_chunks - 1];
        m_free_chunks--;
        return ((T *)((char *)m_heap + p * sizeof(T)));
      }
    else
      return (0);
  }

  template <class T>
  void                Chunk<T>::dealloc(T *p)
  {
    address a = (address) p;
    if (((char *)p < m_heap) | ((char *)p > (((char *)m_heap) + m_chunk_capacity * sizeof(T))))
      return;
    a -= (address) m_heap;
    a /= sizeof(T);
    m_free[++m_free_chunks - 1] = a;
    return;
  }

  template <class T>
  void                        Chunk<T>::debug_free()
  {
    unsigned int i;

    std::cout << "Free chunk stack state :" << std::endl;
    for(i = 0; i < m_chunk_capacity; ++i)
      {
        std::cout << i << " :\t" << m_free[i];
        if (m_free_chunks - 1 == i)
          std::cout << " *";
        std::cout << std::endl;
      }
  }

  template <class T>
  void                        Chunk<T>::reset()
  {
    unsigned int i;
    for (i = 0; i < m_chunk_capacity; i++)
      m_free[i] = i;
  }

};


