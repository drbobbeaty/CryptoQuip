//
//  Legend.m
//  CryptoQuip
//
//  Created by Bob Beaty on 5/5/10.
//  Copyright 2010 The Man from S.P.U.D. All rights reserved.
//

// Apple Headers

// System Headers
#include <ctype.h>

// Third Party Headers

// Other Headers

// Class Headers
#import "Legend_Protected.h"
#import "CypherWord.h"

// Superclass Headers

// Forward Class Declarations

// Private Data Types

// Private Constants

// Private Macros

/*!
 @class Legend 
 This class holds the 'legend' or mapping of the cyphertext characters
 to their plaintext counterparts. These will convert, or map, some or all
 of a cypherWord to a plaintext word for filtering on the list of possible
 words. 
 */
@implementation Legend

//----------------------------------------------------------------------------
//					Creation Methods
//----------------------------------------------------------------------------

/*!
 This method enables the caller to create an autoreleased Legend that
 contains the one and only cyphertext to plaintext mapping that is
 supplied as arguments to this guy. This is very helpful when you need
 to make a new legend to add onto another Legend for testing a new idea.

 @param cypher The cypher character
 @param plain The plain character
 @return The created Legend
 */
+ (Legend*) createLegendWhere:(unichar)cypher equals:(unichar)plain
{
	// make a blank Legend and then populate it with the one, known mapping
	return [[Legend alloc] initWithCypherChar:cypher toPlainChar:plain];
}


//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method returns the actual pointer to the 26 element unichar array
 where the position in the array is the cyphertext's offset from 'a',
 and the value is the plaintext character for that cyphertext character.
 Of course, if the character is '\0', then that means there's no mapping
 for that character in the cyphertext.

 @param
 @return The character array representing the mapping
 */
- (unichar*) getMap
{
	return _map;
}


/*!
 This method sets the mapping in this legend for the provided pair of
 characters: the cypher character and the plain character. This will
 go into the legend and will be used in all subsequent decodings of
 cypherwords by this legend.

 @param c The cypher character
 @param p The plain character
 */
- (void) mapCypherChar:(unichar)c toPlainChar:(unichar)p
{
	if (isalpha(c) && isalpha(p)) {
		_map[toupper(c) - 'A'] = tolower(p);
	}
}


/*!
 When a mapping in a legend has been seen to be an error, you need a method
 to 'undo' that mapping so a different modification to the legend cam be
 tried. This method removes the mapping for the cyphertext character in the
 legend so it will not be mapped in subsequent applications of this legend
 to a cypherword.

 @param c The cypher character
 */
- (void) unmapCypherChar:(unichar)c
{
	if (isalpha(c)) {
		_map[toupper(c) - 'A'] = '\0';
	}
}


//----------------------------------------------------------------------------
//					Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method initializes the legend with the provided map, which is, itself
 a legend for this legend. The point is that this is a way to initialize
 a new legend with a simple map array.

 @param map The array of characters that represents the legend (key)
 @return self
 */
- (id) initWithMap:(unichar*)map
{
	if (self = [super init]) {
		[self setMap:map];
	}
	return self;
}


/*!
 This method initializes the instance with a single mapping for the legend.
 it's a common way to create a Legend - as we pretty much know we need to
 have at least one character mapped.

 @param c The cypher character
 @param p The plain character
 @return self
 */
- (id) initWithCypherChar:(unichar)c toPlainChar:(unichar)p
{
	if (self = [super init]) {
		[self mapCypherChar:c toPlainChar:p];
	}
	return self;
}


//----------------------------------------------------------------------------
//					Decoding Methods
//----------------------------------------------------------------------------

/*!
 This method returns the plaintext character for the cyphertext character
 supplied - IF a mapping exists for this cyphertext character. If not, the
 return value will be '\0', so you need to check on this before you go
 blindly using it.

 @param c The cypher character
 @return The plain character
 */
- (unichar) plainCharForCypherChar:(unichar)c
{
	// assume that we're NOT going to be able to map this guy
	unichar		retval = '\0';
	// we're only going to map the alphabet - regardless of case
	if (isalpha(c)) {
		// look for it in the map
		retval = _map[toupper(c) - 'A'];
		// if it's there, then match the case of the cyphertext char
		if ((retval != '\0') && isupper(c)) {
			retval += ('A' - 'a');
		}
	}
	return retval;
}


/*!
 This method returns the cyphertext character for the plaintext character
 supplied - IF a mapping exists for this pairing. If not, the
 return value will be '\0', so you need to check on this before you go
 blindly using it.

 @param p The plain character
 @return The cypher character
 */
- (unichar) cypherCharForPlainChar:(unichar)p
{
	// assume that we're NOT going to be able to map this guy
	unichar	retval = '\0';
	// we're going to search for the lower-case version of the plaintext
	unichar	pt = tolower(p);
	for (int i = 0; i < 26; ++i) {
		if (_map[i] == pt) {
			// we found it - construct it and get it in the right case
			retval = (i + 'a') + (isupper(p) ? ('A' - 'a') : 0);
			break;
		}
	}
	return retval;
}


/*!
 There will be times when we want to know if it's possible to take a
 cypherword and it's possible plaintext and augment our own mapping with
 the characters in these words without creating an illegal Legend. Examples
 would be changing the existing mapped characters or create two different
 plaintext characters for the same cypher character. If it's possible,
 we'll incorporate the mappings and return YES, if not, nothing it changed
 and NO is returned.

 @param cyphertet The cyphertext to use as a sequence of mappings
 @param plaintext The plaintext to use as a sequence of mappings
 @return YES, if the mappings can be incorporated without conflict
 */
- (BOOL) incorporateMappingCypher:(CypherWord*)cw toPlain:(NSString*)pw
{
	BOOL	error = NO;
	
	// make sure there's something to work with
	if ((cw != nil) && (pw != nil) && ([cw length] == [pw length])) {
		// make a copy of the existing map in case we fail
		unichar	backup[26];
		memcpy(backup, [self getMap], sizeof(backup));

		// process every pair of characters in the cypher/plaintext pair
		unichar	cc, pc;
		for (int i = 0; !error && (i < [cw length]); ++i) {
			// get the individual characters from the texts
			cc = tolower([[cw getCypherText] characterAtIndex:i]);
			pc = tolower([pw characterAtIndex:i]);
			
			// check for punctuation - it's gotta match, but it's not mapped
			if (ispunct(cc) || ispunct(pc)) {
				error = (cc != pc);
				continue;
			}
			
			// see if either side of the mapping already exists
			if ([self getMap][cc - 'a'] != '\0') {
				error = ([self getMap][cc - 'a'] != pc);
			} else {
				// see if the plaintext character is already mapped
				for (int j = 0; !error && (j < 26); ++j) {
					error = ([self getMap][j] == pc);
				}
			}
			
			// OK... new, valid, mapping data. Let's save it...
			if (!error) {
				[self mapCypherChar:cc toPlainChar:pc];
			}
		}
		
		// is we had an error, copy BACK the original mapping data
		if (error) {
			memcpy([self getMap], backup, sizeof(backup));
		}
	}

	return !error;
}


/*!
 This method takes a cyphertext and attempts to completely decode it into a
 plaintext using the mapping currently available. If it creates a completely
 decoded word/phrase, it returns that word. If not, it returns nil. All
 whitespace and punctuation is simply passed through unchanged.

 @param cyphertext The cyphertext to decode with the legend
 @return the decoded string, of it's possible
 */
- (NSString*) decode:(NSString*)cyphertext
{
	NSString*	retval = nil;
	
	// make sure that we have something to work with
	if (cyphertext != nil) {
		NSUInteger	len = [cyphertext length];
		unichar		buff[len];
		BOOL		good = YES;
		for (int i = 0; i < len; ++i) {
			// grab the next cypher character...
			buff[i] = [cyphertext characterAtIndex:i];
			// ...decode it if it's necessary
			if (!isspace(buff[i]) && !ispunct(buff[i])) {
				buff[i] = [self plainCharForCypherChar:buff[i]];
				// no match? Then we're stuck and this won't work
				if (buff[i] == '\0') {
					good = NO;
					break;
				}
			}
		}
		// if it's good, then make a string from it
		if (good) {
			retval = [NSString stringWithCharacters:buff length:len];
		}
	}
	
	return retval;
}


//----------------------------------------------------------------------------
//					NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method returns YES if the argument represents the same mapping data
 as this instance. That is not to say that they are identical, but that
 they would perform the mapping the same.
 */
- (BOOL) isEqual:(id)obj
{
	BOOL	equal = NO;
	if ([obj isKindOfClass:[self class]]) {
		equal = (memcmp([self getMap], [obj getMap], sizeof(_map)) == 0);
	}
	return equal;
}


/*!
 With a custom -isEquals: method, we need to compute a good hashcode for
 this map. We're going to make it as simple as we can - simply summing up
 the characters offsetting each by a factor of 31.
 */
- (NSUInteger) hash
{
	NSUInteger	hash = 0;
	for (int i = 0; i < 26; ++i) {
		hash = 31*hash + (_map[i] - 'a');
	}
	return hash;
}


/*!
 This method returns a string that describes the contents of this guy in a
 nice, human-readable format so that it's suitable for logging and debuggung.
 */
- (NSString*) description
{
	NSMutableString*	desc = [[NSMutableString alloc] init];
	[desc appendString:@"["];
	for (int i = 0; i < 26; ++i) {
		// only put down those mappings that are useful and known
		if ([self getMap][i] != '\0') {
			if ([desc length] > 1) {
				[desc appendString:@", "];
			}
			[desc appendFormat:@"%c=%c", (i + 'a'), [self getMap][i]];
		}
	}
	[desc appendString:@"]"];
	return desc;
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
	return [[Legend allocWithZone:zone] initWithMap:[self getMap]];
}

@end
