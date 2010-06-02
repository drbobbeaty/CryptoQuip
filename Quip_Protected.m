//
//  Quip_Protected.m
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
#import "Quip_Protected.h"

// Superclass Headers

// Forward Class Declarations

// Private Data Types

// Private Constants

// Private Macros


/*!
 @category Quip(Protected)
 These are the 'protected' methods on the Quip object. They are
 protected as a category because they can do a lot more damage than good
 in the wrong hands, but we want to keep everything well encapsulated so
 we need these methods, we just don't want them in the public API that
 everyone gets to see. So they are here.
 */
@implementation Quip (Protected)

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method sets the complete cyphertext for the quip. We'll hold onto it
 as a 'reference' but it'll be broken up into individual words and those
 will work on the data to attempt a solution. This guy is just holding onto
 the starting point.
 */
- (void) setCypherText:(NSString*)text
{
	if (_cyphertext != text) {
		[_cyphertext release];
		_cyphertext = [text retain];
	}
}


/*!
 This method sets the starting legend for the puzzle. Every quip has to have
 at least one letter mapping so you know where to start. This is how we'll
 be told what that mapping is.
 */
- (void) setStartingLegend:(Legend*)legend
{
	if (_startingLegend != legend) {
		[_startingLegend release];
		_startingLegend = [legend retain];
	}
}


/*!
 This method sets the array of puzzle pieces that will be created from the
 initial cyphertext and form the backbone of the puzzle solver.
 */
- (void) setPuzzlePieces:(NSMutableArray*)list
{
	if (_puzzlePieces != list) {
		[_puzzlePieces release];
		_puzzlePieces = [list retain];
	}
}

/*!
 This method adds the provided PuzzlePIece to the end of the list of all
 such pieces for this quip. This is generally called when you are building
 up the list of pieces by decomposing the initial cyphertext.
 */
- (BOOL) addToPuzzlePieces:(PuzzlePiece*)piece
{
	BOOL			error = NO;
	
	// see if there's anything to do
	if (!error) {
		if (piece == nil) {
			error = YES;
			NSLog(@"[Quip (Protected) -addToPuzzlePieces:] - the passed-in PuzzlePiece word is nil and that really means that there's nothing for me to do. Please make sure the argument to this method is not nil before calling.");
		}
	}
	
	// see if there's any place to put this guy
	if (!error) {
		if ([self getPuzzlePieces] == nil) {
			error = YES;
			NSLog(@"[Quip (Protected) -addToPuzzlePieces:] - the master storage of all puzzle pieces has not been created. This means that the -init method has probably not been called. Please make sure to properly initialize this object before using it.");
		} else {
			// add him if things are OK to this point
			[[self getPuzzlePieces] addObject:piece];
		}
	}
	
	return !error;
}


/*!
 This method removes the equivalent puzzle piece from the list - if it exists
 in the list. This uses the -isEquals: method so it's not required that they
 be the same instance, just equivalent in that object's sense.
 */
- (BOOL) removeFromPuzzlePIeces:(PuzzlePiece*)piece
{
	BOOL		error = NO;
	
	// see if there's anything to do
	if (!error) {
		if (piece == nil) {
			error = YES;
			NSLog(@"[Quip (Protected) -removeFromPuzzlePieces:] - the passed-in puzzle piece is nil and that really means that there's nothing for me to do. Please make sure the argument to this method is not nil before calling.");
		}
	}
	
	// see if there's any place to yank this guy from
	if (!error) {
		if ([self getPuzzlePieces] == nil) {
			error = YES;
			NSLog(@"[Quip (Protected) -removeFromPuzzlePieces:] - the master storage of all puzzle pieces has not been created. This means that the -init method has probably not been called. Please make sure to properly initialize this object before using it.");
		} else {
			// yank him if things are OK to this point
			[[self getPuzzlePieces] removeObject:piece];
		}
	}
	
	return !error;
}


/*!
 This method clears out all the puzzle pieces from the maintained list. It's
 a good step to call in the -dealloc method.
 */
- (void) removeAllPuzzlePieces
{
	if ([self getPuzzlePieces] == nil) {
		NSLog(@"[Quip (Protected) -removeAllPuzzlePieces] - the master storage of all puzzle pieces has not been created. This means that the -init method has probably not been called. Please make sure to properly initialize this object before using it.");
	} else {
		// clear them all out if things are OK to this point
		[[self getPuzzlePieces] removeAllObjects];
	}
}


/*!
 This method sets the array of complete solutions that will be created from the
 initial cyphertext and our best attempts to solve the puzzle. It's the set of
 all plaintexts that we could create from the initial cyphertext and the legend.
 */
- (void) setSolutions:(NSMutableArray*)list
{
	if (_solutions != list) {
		[_solutions release];
		_solutions = [list retain];
	}
}


/*!
 This method adds the provided plaintext to the end of the list of all
 soutions for this quip. This is generally called when you are solving the
 bloody thing. Don't allow doubles - there's no need.
 */
- (BOOL) addToSolutions:(NSString*)plaintext
{
	BOOL			error = NO;
	
	// see if there's anything to do
	if (!error) {
		if (plaintext == nil) {
			error = YES;
			NSLog(@"[Quip (Protected) -addToSolutions:] - the passed-in solution is nil and that really means that there's nothing for me to do. Please make sure the argument to this method is not nil before calling.");
		}
	}
	
	// see if there's any place to put this guy
	if (!error) {
		if ([self getSolutions] == nil) {
			error = YES;
			NSLog(@"[Quip (Protected) -addToSolutions:] - the master storage of all solutions has not been created. This means that the -init method has probably not been called. Please make sure to properly initialize this object before using it.");
		} else {
			// add him if things are OK to this point
			if (![[self getSolutions] containsObject:plaintext]) {
				[[self getSolutions] addObject:plaintext];
			}
		}
	}
	
	return !error;
}


/*!
 This method removes the equivalent solution from the list - if it exists
 in the list. This uses the -isEquals: method so it's not required that they
 be the same instance, just equivalent in that object's sense.
 */
- (BOOL) removeFromSolutions:(NSString*)plaintext
{
	BOOL		error = NO;
	
	// see if there's anything to do
	if (!error) {
		if (plaintext == nil) {
			error = YES;
			NSLog(@"[Quip (Protected) -removeFromSolutions:] - the passed-in solution is nil and that really means that there's nothing for me to do. Please make sure the argument to this method is not nil before calling.");
		}
	}
	
	// see if there's any place to yank this guy from
	if (!error) {
		if ([self getSolutions] == nil) {
			error = YES;
			NSLog(@"[Quip (Protected) -removeFromSolutions:] - the master storage of all solutions has not been created. This means that the -init method has probably not been called. Please make sure to properly initialize this object before using it.");
		} else {
			// yank him if things are OK to this point
			[[self getSolutions] removeObject:plaintext];
		}
	}
	
	return !error;
}


/*!
 This method clears out all the solutions from the maintained list. It's
 a good step to call in the -dealloc method, or when you want to start over.
 */
- (void) removeAllSolutions
{
	if ([self getSolutions] == nil) {
		NSLog(@"[Quip (Protected) -removeAllSolutions] - the master storage of all solutions has not been created. This means that the -init method has probably not been called. Please make sure to properly initialize this object before using it.");
	} else {
		// clear them all out if things are OK to this point
		[[self getSolutions] removeAllObjects];
	}
}


//----------------------------------------------------------------------------
//					Solution Methods
//----------------------------------------------------------------------------

/*!
 This is the recursive entry point for attempting the "Word Block" attack on
 the cyphertext starting at the 'index'th word in the quip. The idea is that
 we start with the provided legend, and then for each plaintext word in the
 'index'ed cypherword that matches the legend, we add those keys not in
 the legend, but supplied by the plaintext to the legend, and then try the
 next cypherword in the same manner.
 
 If this attack results in a successful decoding of the cyphertext, this method
 will return YES, otherwise, it will return NO.
 */
- (BOOL) doWordBlockAttackOnIndex:(NSUInteger)index withLegend:(Legend*)key
{
	BOOL	haveSolutions = NO;

	// retain the legend we've been given for the time we need it
	[key retain];
	
	// check all the possibles for this guy to see if they can possibly match
	PuzzlePiece*	piece = [[self getPuzzlePieces] objectAtIndex:index];
	CypherWord*		cw = [piece getCypherWord];
	NSString*		dec = nil;
	for (NSString* pw in [piece getPossibles]) {
		if ([cw canMatch:pw with:key]) {
			// good! Now let's see if we are done with all the words
			if (index == [[self getPuzzlePieces] count] - 1) {
				// make sure we can really decode the last word
				if ([key incorporateMappingCypher:cw toPlain:pw]) {
					// if it's good, add the solution to the list
					if ((dec = [key decode:[self getCypherText]]) != nil) {
						if ([self addToSolutions:dec]) {
							haveSolutions = YES;
						}
					}
				}
			} else {
				/*
				 OK, we had a match but we have more cypherwords
				 to check. So, copy the legend, add in the assumed
				 values from the plaintext, and move to the next 
				 word.
				 */
				Legend*	nextKey = [key copy];
				if ([nextKey incorporateMappingCypher:cw toPlain:pw]) {
					haveSolutions = [self doWordBlockAttackOnIndex:(index + 1) withLegend:nextKey];
				}
				// now we can release this new key as we're done with it
				[nextKey release];
			}
		}

		// if we have a solution - stop looking
		if (haveSolutions) {
			break;
		}
	}
	
	// we no longer need the legend, so release it
	[key release];
	return haveSolutions;
}

@end