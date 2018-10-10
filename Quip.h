//
//  Quip.h
//  CryptoQuip
//
//  Created by Bob Beaty on 5/25/10.
//  Copyright 2010 The Man from S.P.U.D. All rights reserved.
//

// Apple Headers
#import <Cocoa/Cocoa.h>

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "PuzzlePiece.h"

// Superclass Headers

// Forward Class Declarations

// Public Data Types

// Public Constants

// Public Macros


/*!
 @class Quip
 This class is the complete CryptoQuip puzzle and handles all the little
 mundane issues from piecing out the puzzle to solving it and pulling it all
 back together. It's the main controller of the quip.
 */
@interface Quip : NSObject {
@private
	NSString*		_cyphertext;
	Legend*			_startingLegend;
	NSMutableArray*	_puzzlePieces;
	NSMutableArray*	_solutions;
}

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This guy returns the original cyphertext - the complete original statement
 of the puzzle that starts this all off. We'll use this to create the individual
 puzzle pieces.
 */
- (NSString*) getCypherText;

/*!
 This returns the original legend provided in the puzzle statement - every one
 has to have at least one mapping character.
 */
- (Legend*) getStartingLegend;

/*!
 This returns the complete list of puzzle pieces that comprise the engine to
 solve the puzzle. It's the real deal, so please be careful.
 */
- (NSMutableArray*) getPuzzlePieces;

/*!
 This method returns the array of solutions that have been arrived at by one
 of the attack plans. If there's nothing here then maybe you didn't ask this
 guy to solve anything, or maybe there are no valid solutions.
 */
- (NSMutableArray*) getSolutions;

//----------------------------------------------------------------------------
//					Initialization Methods
//----------------------------------------------------------------------------

/*!
 This initialization method will set up the quip to use the provided cyphertext
 and the legend created with the provided character mapping. This is the typical
 statement of the quip "problem", and gets this guy off to a great start.

 @param text The source cyphertext to decode
 @param cypher The cypher character that's part of the hint
 @param plain The plain character that's part of the hint
 @return self, after proper initialization
 */
- (id) initWithCypherText:(NSString*)text where:(unichar)cypher equals:(unichar)plain;

/*!
 This initialization method will set up the quip to use the provided cyphertext
 and the legend created with the provided character mapping. Additionally, the
 list of "known" plaintext words to use to crack the code is supplied so that
 each of the parts of the puzzle can be populated with potential matches.
 This is the way to get everything set up for a solution method.

 @param text The source cyphertext to decode
 @param cypher The cypher character that's part of the hint
 @param plain The plain character that's part of the hint
 @param dict The Legend to use as the starting point for the solution
 @return self, after proper initialization
 */
- (id) initWithCypherText:(NSString*)text where:(unichar)cypher equals:(unichar)plain usingDict:(NSArray*)dict;

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
 This method returns YES if the argument represents the same quip puzzle
 as this instance. That is not to say that they are identical, but that
 they are the same cyphertext and cypherwords.
 */
- (BOOL) isEqual:(id)obj;

/*!
 With a custom -isEquals: method, we need to compute a good hashcode for
 this guy. We're going to make it as simple as we can - simply use the
 -hash values of the ivars and add them up with a nice, prime offset.
 */
- (NSUInteger) hash;

//----------------------------------------------------------------------------
//					NSCopying Methods
//----------------------------------------------------------------------------

/*!
 This is the standard copy method for the Quip so that we can make
 clean copies without having to worry about all the details. It's a nice
 deep copy, where the contents of the returned Quip are the same as
 this instance's.
 */
- (id) copyWithZone:(NSZone*)zone;

//----------------------------------------------------------------------------
//					Solution Methods
//----------------------------------------------------------------------------

/*!
 This is the entry point for attempting the "Word Block" attack on the cyphertext
 The idea is that we start with the initial legend, and then for each plaintext
 word in the first cypherword that matches the legend, we add those keys not in
 the legend, but supplied by the plaintext to the legend, and then try the next
 cypherword in the same manner.

 There will be quite a few 'passes' in this attack plan, but hopefully not
 nearly as many as a character-based scheme.
 
 If this attack results in a successful decoding of the cyphertext, this method
 will return YES, otherwise, it will return NO.

 @param
 @return YES or NO based on the successful outcome of the attck
 */
- (BOOL) attemptWordBlockAttack;

@end
