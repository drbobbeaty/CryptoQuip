//
//  CypherWord_Protected.h
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
#import "CypherWord.h"

// Superclass Headers

// Forward Class Declarations

// Protected Data Types

// Protected Constants

// Protected Macros


/*!
 @category CypherWord(Protected)
 These are the 'protected' methods on the CypherWord object. They are
 protected as a category because they can do a lot more damage than good
 in the wrong hands, but we want to keep everything well encapsulated so
 we need these methods, we just don't want them in the public API that
 everyone gets to see. So they are here.
 */
@interface CypherWord (Protected)

//----------------------------------------------------------------------------
//					Pattern Matching Methods
//----------------------------------------------------------------------------

/*!
 This method takes an NSString and returns an NSString that is the pattern
 of that word where the values are the index of the character. This is a
 simple baseline pattern generator for the words so they are comparable.

 @param text Cyphertext string representation to set
 @return New NSString with a unified pattern of characters
 @code  => [CypherWord createPatternText:"see"]
  "abb"
  => [CypherWord createPatternText:"rabbit"]
  "abccef"
 */
+ (NSString*) createPatternText:(NSString*)text;

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the cyphertext for this word, and is TYPICALLY set once
 in the -initWithCypherText: method for this guy. After this, it's a matter
 of trying to decode this guy and his buddies.

 @param text Cyphertext string representation to set
 */
- (void) setCypherText:(NSString*)text;

@end
