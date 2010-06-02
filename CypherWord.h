//
//  CypherWord.h
//  CryptoQuip
//
//  Created by Bob Beaty on 5/5/10.
//  Copyright 2010 The Man from S.P.U.D. All rights reserved.
//

// Apple Headers
#import <Cocoa/Cocoa.h>

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "Legend.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class CypherWord
 This class is the basic implementation of an original cyphertext word
 in the puzzle. This is going to be entered from the puzzle and we'll
 have methods that can apply a legend to attempt a decoding of the word
 with all the different flavors so that we'll be able to tell if the
 Legend does all that we need.
 */
@interface CypherWord : NSObject {
@private
	NSString*		_cyphertext;
}

//----------------------------------------------------------------------------
//					Creation Methods
//----------------------------------------------------------------------------

/*!
 This method allows the caller to create an autoreleased CypherWord that
 is the provided cyphertext. This is useful in building up the puzzle from
 it's definition.
 */
+ (CypherWord*) createCypherWord:(NSString*)cypher;

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method returns the cyphertext that we're usaing as the starting point
 for all the mapping and decoding tests and methods.
 */
- (NSString*) getCypherText;

/*!
 This method returns the length of characters in the cypherword. It's here to
 make this look a lot more like an NSString so it's easy to work with them.
 */
- (NSUInteger) length;

//----------------------------------------------------------------------------
//					Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method initializes this instance with the provided cyphertext so that
 we're ready to start doing all the magic this guy is capable of.
 */
- (id) initWithCypherText:(NSString*)text;

//----------------------------------------------------------------------------
//					Cyphertext/Plaintext Methods
//----------------------------------------------------------------------------

/*!
 One of the initial tests of a plaintext word is to see if the pattern of
 characters matches the cyphertext. If the pattern doesn't match, then the
 decoded text can't possibly match, either. This method will look at the
 pattern of characters in the cyphertext and compare it to the pattern in
 the argument and if they match, will return YES.
 */
- (BOOL) matchesPattern:(NSString*)plaintext;

/*!
 This method will use the provided Legend and map the cyphertext into a
 plaintext string and then see if the resulting word COULD BE the plaintext.
 This is not to say that the word is completely decoded - only that those
 characters that are decoded match the characters in the plaintext.
 */
- (BOOL) canMatch:(NSString*)plaintext with:(Legend*)key;

/*!
 This method returns YES if, and only if, the Legend applied to this cyphertext
 results in the plaintext <b>exactly</b>. This means that there are NO characters
 that aren't properly decoded in the cyphertext. If this method returns YES,
 then -canMatch:with: will be YES, but the reverse is not necessarily true.
 */
- (BOOL) decodesTo:(NSString*)plaintext with:(Legend*)key;

/*!
 This method takes the Legend and applies it to the cyphertext and IF it creates
 a completely decoded word, it returns that word. If not, it returns nil. This
 is very similar to -decodesTo:with: but it returns the word it decodes to.
 */
- (NSString*) createPlaintextWithLegend:(Legend*)key;

//----------------------------------------------------------------------------
//					NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method returns YES if the argument represents the same cyphertext
 as this instance. That is not to say that they are identical, but that
 they are the same characters in the proper order.
 */
- (BOOL) isEqual:(id)obj;

/*!
 With a custom -isEquals: method, we need to compute a good hashcode for
 this guy. We're going to make it as simple as we can - simply use the
 -hash values of the ivars and add them up.
 */
- (NSUInteger) hash;

/*!
 This method returns a string that describes the contents of this guy in a
 nice, human-readable format so that it's suitable for logging and debuggung.
 */
- (NSString*) description;

//----------------------------------------------------------------------------
//					NSCopying Methods
//----------------------------------------------------------------------------

/*!
 This is the standard copy method for the Legend so that we can make
 clean copies without having to worry about all the details. It's a nice
 deep copy, where the contents of the returned Legend are the same as
 this instance's.
 */
- (id) copyWithZone:(NSZone*)zone;

@end
