//
//  Quip.m
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
 @class Quip
 This class is the complete CryptoQuip puzzle and handles all the little
 mundane issues from piecing out the puzzle to solving it and pulling it all
 back together. It's the main controller of the quip.
 */
@implementation Quip

//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This guy returns the original cyphertext - the complete original statement
 of the puzzle that starts this all off. We'll use this to create the individual
 puzzle pieces.
 */
- (NSString*) getCypherText
{
	return _cyphertext;
}


/*!
 This returns the original legend provided in the puzzle statement - every one
 has to have at least one mapping character.
 */
- (Legend*) getStartingLegend
{
	return _startingLegend;
}


/*!
 This returns the complete list of puzzle pieces that comprise the engine to
 solve the puzzle. It's the real deal, so please be careful - it's immutable
 because it'll be dangerous to mess with it and it's contents.
 */
- (NSArray*) getPuzzlePieces
{
	return _puzzlePieces;
}


/*!
 This method returns the array of solutions that have been arrived at by one
 of the attack plans. If there's nothing here then maybe you didn't ask this
 guy to solve anything, or maybe there are no valid solutions.
 */
- (NSMutableArray*) getSolutions
{
	return _solutions;
}


//----------------------------------------------------------------------------
//					Initialization Methods
//----------------------------------------------------------------------------

/*!
 This initialization method will set up the quip to use the provided cyphertext
 and the legend created with the provided character mapping. This is the typical
 statement of the quip "problem", and gets this guy off to a great start.
 */
- (id) initWithCypherText:(NSString*)text where:(unichar)cypher equals:(unichar)plain
{
	return [self initWithCypherText:text where:cypher equals:plain usingDict:nil];
}


/*!
 This initialization method will set up the quip to use the provided cyphertext
 and the legend created with the provided character mapping. Additionally, the
 list of "known" plaintext words to use to crack the code is supplied so that
 each of the parts of the puzzle can be populated with potential matches.
 This is the way to get everything set up for a solution method.
 */
- (id) initWithCypherText:(NSString*)text where:(unichar)cypher equals:(unichar)plain usingDict:(NSArray*)dict
{
	if (self = [self init]) {
		// save the important arguments as ivars
		[self setCypherText:text];
		[self setStartingLegend:[Legend createLegendWhere:cypher equals:plain]];
		// now let's parse the cyphertext into puzzle pieces
		PuzzlePiece*	pp = nil;
		for (NSString* cw in [text componentsSeparatedByString:@" "]) {
			if ([cw length] > 0) {
				if ((pp = [PuzzlePiece createPuzzlePiece:cw]) != nil) {
					[self addToPuzzlePieces:pp];
				}
			}
		}
		// if we have a dictionary of words, use them
		if (dict != nil) {
			for (NSString* pw in dict) {
				for (PuzzlePiece* pp in [self getPuzzlePieces]) {
					[pp checkPlaintextForPossibleMatch:pw];
				}
			}
		}
	}
	return self;	
}


//----------------------------------------------------------------------------
//					NSObject Overridden Methods
//----------------------------------------------------------------------------

/*!
 This method makes sure to call the super's -init and then allocation all the
 things we're going to need to function properly.
 */
- (id) init
{
	if (self = [super init]) {
		// make the array to hold all the puzzle pieces
		NSMutableArray*		a = [[[NSMutableArray alloc] init] autorelease];
		if (a == nil) {
			NSLog(@"[PuzzlePIece -init] - the storage for all the plaintext words that match the cyphertext could not be created. This is a serious allocation error and needs to be looked into as soon as possible.");
		} else {
			[self setPuzzlePieces:a];
		}
		
		// make an array to hold all the solutions
		a = [[[NSMutableArray alloc] init] autorelease];
		if (a == nil) {
			NSLog(@"[PuzzlePIece -init] - the storage for all the plaintext solutions to the puzzle could not be created. This is a serious allocation error and needs to be looked into as soon as possible.");
		} else {
			[self setSolutions:a];
		}
	}
	return self;	
}


/*!
 Because we created stuff in our -init, we need to make sure that we clean up
 after ourselves, and that's what we're going to be doing here. Just being a
 good citizen.
 */
- (void) dealloc
{
	// drop all the memory we're using
	[self removeAllPuzzlePieces];
	// ...and the array that held it
	[self setPuzzlePieces:nil];
	// ...and don't forget to call the super's dealloc too...
	[super dealloc];	
}


/*!
 This method returns YES if the argument represents the same quip puzzle
 as this instance. That is not to say that they are identical, but that
 they are the same cyphertext and cypherwords.
 */
- (BOOL) isEqual:(id)obj
{
	BOOL	equal = NO;
	if ([obj isKindOfClass:[self class]] &&
		[[self getCypherText] isEqual:[obj getCypherText]] &&
		[[self getStartingLegend] isEqual:[obj getStartingLegend]] &&
		[[self getPuzzlePieces] isEqualToArray:[obj getPuzzlePieces]]) {
		equal = YES;
	}
	return equal;
}


/*!
 With a custom -isEquals: method, we need to compute a good hashcode for
 this guy. We're going to make it as simple as we can - simply use the
 -hash values of the ivars and add them up with a nice, prime offset.
 */
- (NSUInteger) hash
{
	// start with the hash of the plain cyphertext string...
	NSUInteger	hash = 31 * [[self getCypherText] hash]
						+ [[self getStartingLegend] hash];
	// ...now add in the hash of each of the puzzle pieces we have now
	for (PuzzlePiece* pp in [self getPuzzlePieces]) {
		hash = 31*hash + [pp hash];
	}
	return hash;
}


//----------------------------------------------------------------------------
//					NSCopying Methods
//----------------------------------------------------------------------------

/*!
 This is the standard copy method for the Quip so that we can make
 clean copies without having to worry about all the details. It's a nice
 deep copy, where the contents of the returned Quip are the same as
 this instance's.
 */
- (id) copyWithZone:(NSZone*)zone
{
	// simply use the allocWithZone and populate it properly - easy
	id	dup = [[Quip allocWithZone:zone] init];
	// now let's add in copies of all the ivars we have to make it equal
	[dup setCypherText:[[[self getCypherText] copyWithZone:zone] autorelease]];
	[dup setStartingLegend:[[[self getStartingLegend] copyWithZone:zone] autorelease]];
	for (PuzzlePiece* pp in [self getPuzzlePieces]) {
		[[dup getPuzzlePieces] addObject:[[pp copyWithZone:zone] autorelease]];
	}
	return dup;	
}


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
 */
- (BOOL) attemptWordBlockAttack
{
	return [self doWordBlockAttackOnIndex:0 withLegend:[self getStartingLegend]];
}

@end