//
//  MailSpeakObserver.m
//  outlook
//
//  Created by nevin on 11/2/16.
//
//

#import "MailSpeakObserver.h"
#import "OlkSpeechSynthesizer.h"
#import "OlkSpeechRecognizer.h"
#import "OlkSpeakEvent.h"
#import "OlkSpeakEventQueue.h"

static MailSpeakObserver* sSharedInstance_ = nil;

@interface MailSpeakObserver()
{
	OlkSpeechSynthesizer *synthesizer_;
	OlkSpeakEvent *speakEvent_;
}

@property (readonly) OlkSpeechSynthesizer *synthesizer;
@property (readonly) OlkSpeechRecognizer *recognizer;
@property (readwrite, retain) OlkSpeakEvent *speakEvent;

@end


@implementation MailSpeakObserver

@synthesize synthesizer = synthesizer_;
@synthesize recognizer = recognizer_;
@synthesize speakEvent = speakEvent_;

- (instancetype)init
{
	self = [super init];
	
	if(self)
	{
		synthesizer_ = [OlkSpeechSynthesizer sharedInstance];
        recognizer_ = [OlkSpeechRecognizer sharedInstance];
	}
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

+ (MailSpeakObserver*)sharedInstance
{
	if(sSharedInstance_ == nil)
	{
		sSharedInstance_ = [[MailSpeakObserver alloc] init];
	}
	return sSharedInstance_;
}


- (void)handleSpeakEvent:(OlkSpeakEvent*)speakEvent
{
	[self setSpeakEvent:speakEvent];
	
	if([speakEvent type] == SpeakEvent_NewMessage)
	{
        // play the welcome message
		[[self synthesizer] playMessage:(NSString*)@"New Message. Do you want to read the message. Yes or No ?" onSynthesizerCallback:^(void){

            [self captureUserInput];
            
		}];
	}
}

-(void) captureUserInput
{
    // wait for user input.
    [[self recognizer] listenToCommands:@[@"yes", @"no"] onRecognizerCallback:^(NSString *aCmd){
        
        [self handleUserInput:aCmd];
    }];
 
}

-(void) handleUserInput:(NSString *)aCmd
{
    if([aCmd isEqualToString:@"yes"])
    {
        [[self synthesizer] playMessage:(NSString*)[[self speakEvent] data] onSynthesizerCallback:^(void){
            
            [self completedOperation];
            
        }];
    }
    else if([aCmd isEqualToString:@"no"])
    {
        [self completedOperation];
    }
}


-(void) completedOperation
{
    [[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_OperationCompleted];
}

@end
