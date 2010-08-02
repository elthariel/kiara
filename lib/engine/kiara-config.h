/*
** kiara-config.h
** Login : <elthariel@rincevent>
** Started on  Sat Jul 10 02:01:49 2010 elthariel
** $Id$
**
** Author(s):
**  - elthariel <elthariel@gmail.com>
**
** Copyright (C) 2010 elthariel
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/

#ifndef   	KIARA_CONFIG_H_
# define   	KIARA_CONFIG_H_

#define         PPQ                     48

/*
 * The maximum of bars of a block
 */
#define         MAX_BARS                16

/*
 * The maximum of bars of a cluster. (This is really
 * cheaper to allocate)
 */
#define         MAX_BARS_CLUSTER        64

/*
 * The maximum allocatable events
 */
#define         MAX_EVENTS              1000000

/*
 * The maximum allocatable curve blocks.
 */
#define         MAX_CURVE_BLOCKS        4000

/*
 * The maximum allocatable note blocks
 */
#define         MAX_NOTE_BLOCKS         1000

/*
 * Due to MIDI protocol restriction, this should be < 16
 * until we change our event format.
 */
#define         CHANNELS                16

/*
 * The number of note on waiting for their note off to be
 * schedulded.
 */
#define         TRACK_POLY              32

/*
 *  The number of curve you could play concurrently on each
 *  track.
 */
#define         CURVE_POLY              3

/*
 * The bpm when the application starts.
 */
#define         START_BPM               120


// FIXME Removes this when 0.1.0 work is over
// #define         KIARA_MAXPHRASES        2000
// #define         KIARA_MAXPATTERNS       200
// #define         KIARA_PLSLEN            32
// #define         KIARA_PLSCHANNELS         20


#endif 	    /* !KIARA_CONFIG_H_ */
