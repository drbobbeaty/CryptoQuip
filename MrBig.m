//
//  MrBig.m
//  CryptoQuip
//
//  Created by Bob Beaty on 5/21/10.
//  Copyright 2010 The Man from S.P.U.D. All rights reserved.
//

// Apple Headers

// System Headers

// Third Party Headers

// Other Headers

// Class Headers
#import "MrBig.h"
#import "Quip.h"

// Superclass Headers

// Forward Class Declarations

// Private Data Types

// Private Constants

// Private Macros


/*!
 @class MrBig
 This class is my main app controller - every app has to have one, and this
 is mine. We're going to have all the IB Outlets/Actions so that we can play
 nice in the AppKit world, and then when we're asked to do something, we'll
 hop to it and get it all done.
 */
@implementation MrBig

//----------------------------------------------------------------------------
//					Initialization Methods
//----------------------------------------------------------------------------

/*!
 This method is called when the class is initialized and we're
 going to take this opportunity to make sure that if no defaults
 exist for this user, we're going to make them and save them so
 that the later parts of the code that depend on them will not
 run into the problem of them not being there.
 */
+ (void) initialize
{
	/*
	 * Because it's possible that subclasses will implement this
	 * method as well, we need to make sure that we're only doing
	 * the initialization for *this* class and not all other
	 * subclasses.
	 */
	if (self == [MrBig class]) {
        /* put initialization code here */
    }
}


//----------------------------------------------------------------------------
//					Accessor Methods
//----------------------------------------------------------------------------

/*!
 This method returns the text field that's been wired in as the line of
 cyphertext that the user will be providing.
 */
- (NSTextField*) getCyphertextLine
{
	return _cyphertextLine;
}


/*!
 This method returns the text field that's been wired in as the line where
 I'll be placing the answer to the puzzle, once I get a solution.
 */
- (NSTextField*) getPlaintextLine
{
	return _plaintextLine;
}


/*!
 This method gets the combo box that will hold the "cyphertext" half of the
 initial legend for the solution of the puzzle. It's a simple way to get
 the user to tell us what the initial 'key' to the puzzle is.
 */
- (NSComboBox*) getCypherChar
{
	return _cypherChar;
}


/*!
 This method gets the combo box that will hold the "plaintext" half of the
 initial legend for the solution of the puzzle. It's a simple way to get
 the user to tell us what the initial 'key' to the puzzle is.
 */
- (NSComboBox*) getPlainChar
{
	return _plainChar;
}


/*!
 This method returns the status line on the window so that I can update the
 user as to what's going on inside me.
 */
- (NSTextField*) getStatusLine
{
	return _statusLine;
}


/*!
 This method sets the list of acceptable, known, words that the engine has at
 it's disposal. If the word isn't in this list, it's impossible to decode any
 cyphertext into it. Try to make this as complete as possible.
 */
- (void) setWordList:(NSMutableArray*)list
{
	_wordList = list;
}


/*!
 This method returns the list of all the words we know about. This is important
 source material for any and all solution attacks as they have to have some
 idea of the possible words to map to.
 */
- (NSMutableArray*) getWordList
{
	return _wordList;
}


//----------------------------------------------------------------------------
//					IB Actions
//----------------------------------------------------------------------------

/*!
 This action is typically the target of a button the user will press on when
 they want us to solve the provided puzzle. It's going to create a Quip with
 the cyphertext and the initial start at a legend and then ask it to solve the
 puzzle. When it's done, we'll pick off the solutions and see what we see.
 */
- (IBAction) decode:(id)sender
{
	// get the values from the UI elements
	NSString*	cyphertext = [[self getCyphertextLine] stringValue];
	// ...get the character that's the cypher part of the legend
	unichar		cypher = '\0';
	NSString*	cypherCombo = [[self getCypherChar] stringValue];
	if ((cypherCombo != nil) && ([cypherCombo length] > 0)) {
		cypher = tolower([cypherCombo characterAtIndex:0]);
	}
	// ...get the character that's the plain part of the legend
	unichar		plain = '\0';
	NSString*	plainCombo = [[self getPlainChar] stringValue];
	if ((plainCombo != nil) && ([plainCombo length] > 0)) {
		plain = tolower([plainCombo characterAtIndex:0]);
	}
	
	// now let's call the solver
	[self solve:cyphertext where:cypher equals:plain];
}


/*!
 This method runs a simple test decoding so that we can be sure that things
 are working properly. It's going to use the cyphertext:
     Fict O ncc bivteclnbklzn O lcpji ukl pt vzglcddp
 with the initial legend:
     b = t
 and *should* solve to the plaintext:
     When I see thunderstorms I reach for an umbrella
 If not, then we're in trouble.
 */
- (IBAction) testDecode:(id)sender
{
	[self solve:@"Fict O ncc bivteclnbklzn O lcpji ukl pt vzglcddp" where:'b' equals:'t'];
}


/*!
 This method is what really runs the decoder, and it takes the cyphertext
 string as well as the initial part of the legend, and will load up the
 Quip and have it do it's thing, placing the solution in the text field
 when it's done. Pretty simple. I just needed a single method to do this.
 */
- (void) solve:(NSString*)cyphertext where:(unichar)cypher equals:(unichar)plain
{
	NSLog(@"Solving puzzle: '%@' where %c=%c", cyphertext, cypher, plain);
	// make a new Quip, and give it the arguments it needs.
	Quip*	q = [[Quip alloc] initWithCypherText:cyphertext where:cypher equals:plain usingDict:[self getWordList]];
	if ([q attemptWordBlockAttack]) {
		NSLog(@"Solution found: '%@'", [[q getSolutions] objectAtIndex:0]);
		[[self getPlaintextLine] setStringValue:[[q getSolutions] objectAtIndex:0]];
	}
}


//----------------------------------------------------------------------------
//					General Housekeeping
//----------------------------------------------------------------------------

/*!
 There are a lot of housekeeping things that I need to do when I
 first start up. The first thing I need to do is to load up the
 user preferences and then use them to modify the settings from the
 defaults.
 */
- (void) awakeFromNib
{
	// clear out the input and output text areas as we want them clean
	[[self getPlaintextLine] setStringValue:@""];
	// ...and de-select the character mappings
	[[self getCypherChar] deselectItemAtIndex:[[self getCypherChar] indexOfSelectedItem]];
	[[self getPlainChar] deselectItemAtIndex:[[self getPlainChar] indexOfSelectedItem]];
	
	// Set the status to a simple 'Ready'
	[self showStatus:@"Ready"];
}


//----------------------------------------------------------------------------
//					NSWindow Delegate Methods
//----------------------------------------------------------------------------

/*!
 This method is called by the main window when it's about to get
 closed. This means it's time for us to save out the existing
 structure of the window to the defaults so that it can be read
 in again when next the user needs a window.
 */
- (void) windowWillClose:(NSNotification*)aNotification
{
	
}


//----------------------------------------------------------------------------
//					NSApplication Delegate Methods
//----------------------------------------------------------------------------

/*!
 When the last window closes on this app, we need to quit as it's just
 plain time to go. This is done here as we are the application's
 delegate and this is expected of us. Nice NSApplication class...
 */
- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)theApplication
{
	return YES;
}


//----------------------------------------------------------------------------
//					Convenience UI Methods
//----------------------------------------------------------------------------

/*!
 This method is a simple conveneient way to set the text on the status
 line to a nice value. It also logs the status to the console log so that
 there's a more permanent record of what's been happening.
 */
- (void) showStatus:(NSString*)status
{
	[[self getStatusLine] setStringValue:status];
	NSLog(@"%@", status);
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
		NSMutableArray*		a = [[NSMutableArray alloc] init];
		if (a == nil) {
			NSLog(@"[MrBig -init] - the storage for all the plaintext words could not be created. This is a serious allocation error and needs to be looked into as soon as possible.");
		} else {
			// get the location of the 'words' file
			NSString*	resDir = [[NSBundle mainBundle] resourcePath];
			NSString*	wordsFile = [NSString stringWithFormat:@"%@/words", resDir];
			NSString*	contents = [NSString stringWithContentsOfFile:wordsFile encoding:NSUTF8StringEncoding error:NULL];
			[a addObjectsFromArray:[contents componentsSeparatedByString:@"\n"]];
			NSLog(@"Loaded %lu words from %@", [a count], wordsFile);
			// now save what we have
			[self setWordList:a];
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
	[[self getWordList] removeAllObjects];
	// ...and the array that held it
	[self setWordList:nil];
}

@end
