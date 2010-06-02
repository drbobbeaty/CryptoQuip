//
//  Legend.h
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

// Superclass Headers

// Forward Class Declarations
@class CypherWord;

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class Legend 
 This class holds the 'legend' or mapping of the cyphertext characters
 to their plaintext counterparts. These will convert, or map, some or all
 of a cypherWord to a plaintext word for filtering on the list of possible
 words. 
 */
@interface Legend : NSObject {
@private
	unichar		_map[26];
}

//----------------------------------------------------------------------------
//					Creation Methods
//----------------------------------------------------------------------------

/*!
 This method enables the caller to create an autoreleased Legend that
 contains the one and only cyphertext to plaintext mapping that is
 supplied as arguments to this guy. This is very helpful when you need
 to make a new legend to add onto another Legend for testing a new idea.
 */
+ (Legend*) createLegendWhere:(unichar)cypher equals:(unichar)plain;

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method returns the actual pointer to the 26 element unichar array
 where the position in the array is the cyphertext's offset from 'a',
 and the value is the plaintext character for that cyphertext character.
 Of course, if the character is '\0', then that means there's no mapping
 for that character in the cyphertext.
 */
- (unichar*) getMap;

/*!
 This method sets the mapping in this legend for the provided pair of
 characters: the cypher character and the plain character. This will
 go into the legend and will be used in all subsequent decodings of
 cypherwords by this legend.
 */
- (void) mapCypherChar:(unichar)c toPlainChar:(unichar)p;

/*!
 When a mapping in a legend has been seen to be an error, you need a method
 to 'undo' that mapping so a different modification to the legend cam be
 tried. This method removes the mapping for the cyphertext character in the
 legend so it will not be mapped in subsequent applications of this legend
 to a cypherword.
 */
- (void) unmapCypherChar:(unichar)c;

//----------------------------------------------------------------------------
//					Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method initializes the legend with the provided map, which is, itself
 a legend for this legend. The point is that this is a way to initialize
 a new legend with a simple map array.
 */
- (id) initWithMap:(unichar*)map;

/*!
 This method initializes the instance with a single mapping for the legend.
 it's a common way to create a Legend - as we pretty much know we need to
 have at least one character mapped.
 */
- (id) initWithCypherChar:(unichar)c toPlainChar:(unichar)p;

//----------------------------------------------------------------------------
//					Decoding Methods
//----------------------------------------------------------------------------

/*!
 This method returns the plaintext character for the cyphertext character
 supplied - IF a mapping exists for this cyphertext character. If not, the
 return value will be '\0', so you need to check on this before you go
 blindly using it.
 */
- (unichar) plainCharForCypherChar:(unichar)c;

/*!
 This method returns the cyphertext character for the plaintext character
 supplied - IF a mapping exists for this pairing. If not, the
 return value will be '\0', so you need to check on this before you go
 blindly using it.
 */
- (unichar) cypherCharForPlainChar:(unichar)p;

/*!
 There will be times when we want to know if it's possible to take a
 cypherword and it's possible plaintext and augment our own mapping with
 the characters in these words without creating an illegal Legend. Examples
 would be changing the existing mapped characters or create two different
 plaintext characters for the same cypher character. If it's possible,
 we'll incorporate the mappings and return YES, if not, nothing it changed
 and NO is returned.
 */
- (BOOL) incorporateMappingCypher:(CypherWord*)cw toPlain:(NSString*)pw;

/*!
 This method takes a cyphertext and attempts to completely decode it into a
 plaintext using the mapping currently available. If it creates a completely
 decoded word/phrase, it returns that word. If not, it returns nil.
 */
- (NSString*) decode:(NSString*)cyphertext;

//----------------------------------------------------------------------------
//					NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method returns YES if the argument represents the same mapping data
 as this instance. That is not to say that they are identical, but that
 they would perform the mapping the same.
 */
- (BOOL) isEqual:(id)obj;

/*!
 With a custom -isEquals: method, we need to compute a good hashcode for
 this map. We're going to make it as simple as we can - simply summing up
 the characters offsetting each by a factor of 31.
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
