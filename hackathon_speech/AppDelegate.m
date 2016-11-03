//
//  AppDelegate.m
//  hackathon_speech
//
//  Created by Satayu Mehta on 11/2/16.
//  Copyright © 2016 outlook. All rights reserved.
//

#import "AppDelegate.h"

#import "MailSpeakObserver.h"
#import "OlkSpeakEvent.h"
#import "OlkSpeakEventQueue.h"

@interface AppDelegate ()

@property IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	// register observers
	[[OlkSpeakEventQueue getInstance] addObserver:[MailSpeakObserver sharedInstance] forType:SpeakEvent_NewMessage];
	
	// post notifications
	[[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_NewMessage withDataOrNil:@"hello world"];
    [[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_NewMessage withDataOrNil:@"hello satayu"];
    [[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_NewMessage withDataOrNil:@"hello john"];
    [[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_NewMessage withDataOrNil:@"hello vivek"];
    [[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_NewMessage withDataOrNil:@"hello maria"];
    
    [self performSelector:@selector(delayedEvents) withObject:self afterDelay:1.0];
    
}

-(void) delayedEvents
{
    [[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_NewMessage withDataOrNil:@"hello world"];
    [[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_NewMessage withDataOrNil:@"hello satayu"];
    [[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_NewMessage withDataOrNil:@"hello john"];
    [[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_NewMessage withDataOrNil:@"hello vivek"];
    [[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_NewMessage withDataOrNil:@"hello maria"];   
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


@end
