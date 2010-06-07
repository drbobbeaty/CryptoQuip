//
//  puzzlePiece.h
//  CryptoQuip
//
//  Created by Bob Beaty on 5/7/10.
//  Copyright 2010 The Man from S.P.U.D. All rights reserved.
//

// Apple Headers
#import <Cocoa/Cocoa.h>

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "CypherWord.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class PuzzlePiece
 This class is one "word" in the puzzle - it has a cypher word, and a list
 of all the 'possibles' for that word based on the dictionary parsed and the
 pattern matching that has been done. These will be put together in a list
 to complete the cryptoquip.
 */
@interface PuzzlePiece : NSObject {
@private
	CypherWord*		_cyphertext;
	NSMutableArray*	_possiblePlaintexts;
}

//----------------------------------------------------------------------------
//					Creation Methods
//----------------------------------------------------------------------------

/*!
 This method allows the caller to create an autoreleased PuzzlePiece that
 is based on the provided cyphertext. This is useful in building up the
 puzzle from it's definition.
 */
+ (PuzzlePiece*) createPuzzlePiece:(NSString*)cypher;

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method returns the CypherWord that is the starting point for this part
 of the puzzle.
 */
- (CypherWord*) getCypherWord;

/*!
 This method returns the array of possible plaintext words that match the
 length and structure of the cypherword. These can then be used as "tests"
 for decoding the cypherword and comparing it to each of these in turn.
 */
- (NSMutableArray*) getPossibles;

//----------------------------------------------------------------------------
//					Initialization Methods
//----------------------------------------------------------------------------

/*!
 This initialization method takes a cyphertext and will create a CypherWord
 based on it and then hang onto it so that we're ready to throw in possible
 plaintext words and get around to solving the puzzle.
 */
- (id) initWithCypherText:(NSString*)text;

//----------------------------------------------------------------------------
//					NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method makes sure to call the super's -init and then allocation all the
 things we're going to need to function properly.
 */
- (id) init;

/*!
 Because we created stuff in our -init, we need to make sure that we clean up
 after ourselves, and that's what we're going to be doing here. Just being a
 good citizen.
 */
- (void) dealloc;

/*!
 This method returns YES if the argument represents the same puzzle piece
 as this instance. That is not to say that they are identical, but that
 they have the same cyphertext, and same list of possible plain text words.
 */
- (BOOL) isEqual:(id)obj;

/*!
 With a custom -isEquals: method, we need to compute a good hashcode for
 this map. We're going to make it as simple as we can - simply summing up
 the -hash values offsetting each by a factor of 31.
 */
- (NSUInteger) hash;

/*!
 This method returns a string that describes the contents of this guy in a
 nice, human-readable format so that it's suitable for logging and debuggung.
 */
- (NSString*) description;

//----------------------------------------------------------------------------
//					Comparison Methods (for Sorting)
//----------------------------------------------------------------------------

/*!
 This comparison method will compare the lengths of the cypherwords so that
 you can use this method to sort the puzzle pieces on the lengths of the words
 for some attack.
 */
- (NSComparisonResult) compareLength:(PuzzlePiece*)anOther;

/*!
 This comparison method will compare the number of possible plaintext matches
 for the argument and this instance to see who has more. This is useful in
 sorting the puzzle pieces on the number of possible matches in the attack.
 */
- (NSComparisonResult) comparePossibles:(PuzzlePiece*)anOther;

//----------------------------------------------------------------------------
//					NSCopying Methods
//----------------------------------------------------------------------------

/*!
 This is the standard copy method for the PuzzlePiece so that we can make
 clean copies without having to worry about all the details. It's a nice
 deep copy, where the contents of the returned PuzzlePiece are the same as
 this instance's.
 */
- (id) copyWithZone:(NSZone*)zone;

//----------------------------------------------------------------------------
//					Plaintext Handling Methods
//----------------------------------------------------------------------------

/*!
 This method returns the number of possible plaintext matches we are currently
 holding that match in pattern, and length, the cyphertext we have. It's a
 simple way to see how many possible decodings we know about for this one
 cypherword.
 */
- (int) countOfPossibles;

/*!
 This method uses the provided legend to partially, if not fully, decode the
 cypherword into plaintext and then check that against all the possible plain
 text words we know about and returns how many matches there are. THis is a
 good way to see how many, if any, matches there are to the decoding provided
 by the legend.
 */
- (int) countOfPossiblesUsingLegend:(Legend*)key;

/*!
 This method looks at the supplied plaintext word, and if it's pattern matches
 the CypherWord we have, then we'll add it to the array of possibles. It's a
 simple way to populate the list of possible plaintext words for all the
 pieces in the puzzle.
 */
- (BOOL) checkPlaintextForPossibleMatch:(NSString*)plain;

@end
