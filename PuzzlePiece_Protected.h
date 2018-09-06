//
//  PuzzlePiece_Protected.h
//  CryptoQuip
//
//  Created by Bob Beaty on 5/25/10.
//  Copyright 2010 The Man from S.P.U.D. All rights reserved.
//

// Apple Headers

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "Quip.h"

// Superclass Headers

// Forward Class Declarations

// Protected Data Types

// Protected Constants

// Protected Macros


/*!
 @category PuzzlePiece(Protected)
 These are the 'protected' methods on the PuzzlePiece object. They are
 protected as a category because they can do a lot more damage than good
 in the wrong hands, but we want to keep everything well encapsulated so
 we need these methods, we just don't want them in the public API that
 everyone gets to see. So they are here.
 */
@interface PuzzlePiece (Protected)

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the cypherword that we're going to be using. It's probably
 smart to clear out the possible matches if you set this so that there's no
 possible disconnect about what's matching with what, but that's up to you.

 @param word CypherWord to set on this PuzzlePiece
 */
- (void) setCypherWord:(CypherWord*)word;

/*!
 This method sets the array we'll use for holding the possible plaintext
 words for the cypherword that we have been given. This is kind of serious
 as it'll drop any existing list and since we'll make one in the -init method
 we might want to be very careful calling this.

 @param array An array of plaintext words that are possible matches to the
              cypher word in the PuzzlePiece
 */
- (void) setPossibles:(NSMutableArray*)array;

/*!
 This method adds the provided plaintext word to the list of possibles for
 this piece of the puzzle. This method DOES NOT check to see if the plaintext
 matches the cyphertext, only that it adds it to the list of possibles. THere
 are other methods that will do the checking and then call this to add the
 proper match to the list.

 @param word The plaintext word that needs to be added
 @return YES if the addition was successful to the list of possibles
 */
- (BOOL) addToPossibles:(NSString*)word;

/*!
 If there's a time to remove one of the possibles from the list, this method
 does that based on it's value not it's pointer. Makes sense.

 @param word The plaintext word that needs to be removed from the list of possibles
 @return YES if the addition was successful
 */
- (BOOL) removeFromPossibles:(NSString*)word;

/*!
 This method simply clears out all the possible plaintext words so we can
 start over anew with a clean slate.
 */
- (void) removeAllPossibles;

@end
