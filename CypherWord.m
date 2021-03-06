//
//  CypherWord.m
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
#import "CypherWord_Protected.h"

// Superclass Headers

// Forward Class Declarations

// Private Data Types

// Private Constants

// Private Macros


/*!
 @class CypherWord
 This class is the basic implementation of an original cyphertext word
 in the puzzle. This is going to be entered from the puzzle and we'll
 have methods that can apply a legend to attempt a decoding of the word
 with all the different flavors so that we'll be able to tell if the
 Legend does all that we need.
 */
@implementation CypherWord

//----------------------------------------------------------------------------
//					Creation Methods
//----------------------------------------------------------------------------

/*!
 This method allows the caller to create an autoreleased CypherWord that
 is the provided cyphertext. This is useful in building up the puzzle from
 it's definition.

 @param cypher Source cypherword string
 @return newly created CypherWord
 */
+ (CypherWord*) createCypherWord:(NSString*)cypher
{
	// make a blank CypherWord and then populate it with the given text
	return [[CypherWord alloc] initWithCypherText:cypher];
}


//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method returns the cyphertext that we're usaing as the starting point
 for all the mapping and decoding tests and methods.

 @param
 @return String representation of the cyphertext
 */
- (NSString*) getCypherText
{
	return _cyphertext;
}


/*!
 This method returns the length of characters in the cypherword. It's here to
 make this look a lot more like an NSString so it's easy to work with them.

 @param
 @return Count of characters in the cypherword
 */
- (NSUInteger) length
{
	return _cypherSize;
}


/*!
 This method returns an NSString that is the pattern of the cyphertext where
 the pattern is uniform so that 'see', 'bee', and 'all' - all have the same
 pattern.

 @param
 @return String uniform pattern of the cyphertext
 */
- (NSString*) getCypherPattern
{
	return _cypherPattern;
}


//----------------------------------------------------------------------------
//					Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method initializes this instance with the provided cyphertext so that
 we're ready to start doing all the magic this guy is capable of.

 @param text Source cypherword string
 @return self
 */
- (id) initWithCypherText:(NSString*)text
{
	if (self = [super init]) {
		[self setCypherText:text];
	}
	return self;
}


//----------------------------------------------------------------------------
//					Cyphertext/Plaintext Methods
//----------------------------------------------------------------------------

/*!
 One of the initial tests of a plaintext word is to see if the pattern of
 characters matches the cyphertext. If the pattern doesn't match, then the
 decoded text can't possibly match, either. This method will look at the
 pattern of characters in the cyphertext and compare it to the pattern in
 the argument and if they match, will return YES.

 @param plaintext A plaintext word to see if it matches the pattern
                  of the cypherword
 @return YES if the pattern of the two words matches
 */
- (BOOL) matchesPattern:(NSString*)plaintext
{
	return ([self getCypherText] != nil) && (plaintext != nil) &&
	       ([self length] == [plaintext length]) &&
	       [[self getCypherPattern] isEqualToString:[CypherWord createPatternText:plaintext]];
}


/*!
 This method will use the provided Legend and map the cyphertext into a
 plaintext string and then see if the resulting word COULD BE the plaintext.
 This is not to say that the word is completely decoded - only that those
 characters that are decoded match the characters in the plaintext.

 @param plaintext A possible plaintext version of the cypherword
 @param key The decoding legend (key) for the mapping
 @return YES, if the cypherword maps to the plaintext with the legend
 */
- (BOOL) canMatch:(NSString*)plaintext with:(Legend*)key
{
	BOOL	match = YES;
	
	// make sure that we have something to work with
	if (match && (([self getCypherText] == nil) || (plaintext == nil) || (key == nil))) {
		match = NO;
	}
	
	// check the lengths - gotta be the same here for sure
	if (match && ([[self getCypherText] length] != [plaintext length])) {
		match = NO;
	}
	
	/*
	 * Let's run through all the characters, and IF a cypher character is
	 * mapped by the Legend, it had better map to the plaintext character
	 * or else we don't have a match. As soon as we don't have a match, we
	 * can quit looking.
	 */
	if (match) {
		unichar		plain;
		NSUInteger	len = [plaintext length];
		for (NSUInteger i = 0; (i < len) && match; ++i) {
			// get the next possible pair in the two words
			plain = [key plainCharForCypherChar:[[self getCypherText] characterAtIndex:i]];
			// if it's mapped, then it had better match the plaintext
			if ((plain != '\0') && (tolower(plain) != tolower([plaintext characterAtIndex:i]))) {
				match = NO;
				break;
			}
		}
	}
	
	return match;
}


/*!
 This method returns YES if, and only if, the Legend applied to this cyphertext
 results in the plaintext <b>exactly</b>. This means that there are NO characters
 that aren't properly decoded in the cyphertext. If this method returns YES,
 then -canMatch:with: will be YES, but the reverse is not necessarily true.

 @param plaintext A possible plaintext version of the cypherword
 @param legend The decoding legend (key) for the mapping
 @return YES, if the cypherword maps to the plaintext with the legend
 */
- (BOOL) decodesTo:(NSString*)plaintext with:(Legend*)key
{
	BOOL	match = YES;
	
	// make sure that we have something to work with
	if (match && (([self getCypherText] == nil) || (plaintext == nil) || (key == nil))) {
		match = NO;
	}
	
	// check the lengths - gotta be the same here for sure
	if (match && ([[self getCypherText] length] != [plaintext length])) {
		match = NO;
	}
	
	/*
	 * Let's run through all the characters, and EVERY cypher character had
	 * better be mapped by the Legend - if it's not, then we aren't matching.
	 * Additionally, it had better map to the plaintext character or else we
	 * don't have a match. As soon as we don't have a match, we can quit looking.
	 */
	if (match) {
		unichar		plain;
		NSUInteger	len = [plaintext length];
		for (NSUInteger i = 0; (i < len) && match; ++i) {
			// get the next possible pair in the two words
			plain = [key plainCharForCypherChar:[[self getCypherText] characterAtIndex:i]];
			// must be mapped, and match the plaintext
			if ((plain == '\0') || (tolower(plain) != tolower([plaintext characterAtIndex:i]))) {
				match = NO;
				break;
			}
		}
	}
	
	return match;
}


/*!
 This method takes the Legend and applies it to the cyphertext and IF it creates
 a completely decoded word, it returns that word. If not, it returns nil. This
 is very similar to -decodesTo:with: but it returns the word it decodes to.

 @param legend The decoding legend (key) for the mapping
 @return Decoded string for the cypherword
 */
- (NSString*) createPlaintextWithLegend:(Legend*)key
{
	return [key decode:[self getCypherText]];
}


//----------------------------------------------------------------------------
//					NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method returns YES if the argument represents the same cyphertext
 as this instance. That is not to say that they are identical, but that
 they are the same characters in the proper order.
 */
- (BOOL) isEqual:(id)obj
{
	BOOL	equal = NO;
	if ([obj isKindOfClass:[self class]]) {
		equal = [[self getCypherText] isEqual:obj];
	}
	return equal;
}


/*!
 With a custom -isEquals: method, we need to compute a good hashcode for
 this guy. We're going to make it as simple as we can - simply use the
 -hash values of the ivars and add them up.
 */
- (NSUInteger) hash
{
	return [[self getCypherText] hash];
}


/*!
 This method returns a string that describes the contents of this guy in a
 nice, human-readable format so that it's suitable for logging and debuggung.
 */
- (NSString*) description
{
	return [[self getCypherText] copy];
}


//----------------------------------------------------------------------------
//					NSCopying Methods
//----------------------------------------------------------------------------

/*!
 This is the standard copy method for the Legend so that we can make
 clean copies without having to worry about all the details. It's a nice
 deep copy, where the contents of the returned Legend are the same as
 this instance's.
 */
- (id) copyWithZone:(NSZone*)zone
{
	// simply use the allocWithZone and populate it properly - easy
	return [[CypherWord allocWithZone:zone] initWithCypherText:[self getCypherText]];
}

@end
