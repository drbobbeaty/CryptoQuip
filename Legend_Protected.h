//
//  Legend_Protected.h
//  CryptoQuip
//
//  Created by Bob Beaty on 5/5/10.
//  Copyright 2010 The Man from S.P.U.D. All rights reserved.
//

// Apple Headers

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "Legend.h"

// Superclass Headers

// Forward Class Declarations

// Protected Data Types

// Protected Constants

// Protected Macros


/*!
 @category Legend(Protected)
 These are the 'protected' methods on the Legend object. They are
 protected as a category because they can do a lot more damage than good
 in the wrong hands, but we want to keep everything well encapsulated so
 we need these methods, we just don't want them in the public API that
 everyone gets to see. So they are here.
 */
@interface Legend (Protected)

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method takes a unichar array of 26 elements and uses that as the
 new mapping of cyphertext characters to plaintext characters. The logic
 is that the position in the array is the cyphertext character - offset
 from 'a', and the value is the plaintext character for that guy.

 @param map Array of characters that represents the Legend (key)
 */
- (void) setMap:(unichar*)map;

@end
