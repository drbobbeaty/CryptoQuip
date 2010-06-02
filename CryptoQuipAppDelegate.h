//
//  CryptoQuipAppDelegate.h
//  CryptoQuip
//
//  Created by Bob Beaty on 5/5/10.
//  Copyright 2010 The Man from S.P.U.D. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CryptoQuipAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
