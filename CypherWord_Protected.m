//
//  CypherWord_Protected.m
//  CryptoQuip
//
//  Created by Bob Beaty on 5/10/10.
//  Copyright 2010 The Man from S.P.U.D. All rights reserved.
//

// Apple Headers

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "CypherWord_Protected.h"

// Superclass Headers

// Forward Class Declarations

// Private Data Types

// Private Constants

// Private Macros


/*!
 @category CypherWord(Protected)
 These are the 'protected' methods on the CypherWord object. They are
 protected as a category because they can do a lot more damage than good
 in the wrong hands, but we want to keep everything well encapsulated so
 we need these methods, we just don't want them in the public API that
 everyone gets to see. So they are here.
 */
@implementation CypherWord (Protected)

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the cyphertext for this word, and is TYPICALLY set once
 in the -initWithCypherText: method for this guy. After this, it's a matter
 of trying to decode this guy and his buddies.
 */
- (void) setCypherText:(NSString*)text
{
	_cyphertext = text;
}

@end
