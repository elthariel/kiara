cmake_minimum_required(VERSION 2.6)
project(Kiara)

# The version number.
set(Kiara_VERSION_MAJOR 1)
set(Kiara_VERSION_MINOR 0)

include(build_options.cmake)

find_package(Ruby 1.9.0 REQUIRED)
find_package(SWIG REQUIRED)
set(Boost_USE_STATIC_LIBS OFF)
set(Boost_USE_MULTITHREADED OFF)
find_package(Boost 1.40 REQUIRED COMPONENTS thread)
find_library(PORTTIME_LIBRARY porttime "${PORTTIME_PREFIX}/lib")
find_library(PORTMIDI_LIBRARY portmidi "${PORTMIDI_PREFIX}/lib")
find_path(PORTTIME_INCLUDE porttime.h "${PORTTIME_PREFIX}/include")
find_path(PORTMIDI_INCLUDE portmidi.h "${PORTMIDI_PREFIX}/include")

if (SWIG_FOUND)
  message(STATUS "Found SWIG: ${SWIG_EXECUTABLE}")
else (SWIG_FOUND)
  message(SEND_ERROR "SWIG Not Found, this is required")
endif (SWIG_FOUND)

if ("${PORTTIME_LIBRARY}" STREQUAL "PORTTIME_LIBRARY-NOTFOUND")
  message (SEND_ERROR "Unable to find PortTime, this is a requirement")
else ("${PORTTIME_LIBRARY}" STREQUAL "PORTTIME_LIBRARY-NOTFOUND")
  message(STATUS "Found PortTime library: ${PORTTIME_LIBRARY}")
endif ("${PORTTIME_LIBRARY}" STREQUAL "PORTTIME_LIBRARY-NOTFOUND")

if ("${PORTMIDI_LIBRARY}" STREQUAL "PORTMIDI_LIBRARY-NOTFOUND")
  message (SEND_ERROR "Unable to find PortMidi, this is a requirement")
else ("${PORTMIDI_LIBRARY}" STREQUAL "PORTMIDI_LIBRARY-NOTFOUND")
  message(STATUS "Found PortMidi library: ${PORTMIDI_LIBRARY}")
endif ("${PORTMIDI_LIBRARY}" STREQUAL "PORTMIDI_LIBRARY-NOTFOUND")

if ("${PORTTIME_INCLUDE}" STREQUAL "PORTTIME_INCLUDE-NOTFOUND")
  message (SEND_ERROR "Unable to find porttime.h, this is a requirement")
else ("${PORTTIME_INCLUDE}" STREQUAL "PORTTIME_INCLUDE-NOTFOUND")
  message(STATUS "Found PortTime header path: ${PORTTIME_INCLUDE}")
endif ("${PORTTIME_INCLUDE}" STREQUAL "PORTTIME_INCLUDE-NOTFOUND")

if ("${PORTMIDI_INCLUDE}" STREQUAL "PORTMIDI_INCLUDE-NOTFOUND")
  message (SEND_ERROR "Unable to find portmidi.h, this is a requirement")
else ("${PORTMIDI_INCLUDE}" STREQUAL "PORTMIDI_INCLUDE-NOTFOUND")
  message(STATUS "Found PortMidi header path: ${PORTMIDI_INCLUDE}")
endif ("${PORTMIDI_INCLUDE}" STREQUAL "PORTMIDI_INCLUDE-NOTFOUND")


add_subdirectory(lib/engine)

