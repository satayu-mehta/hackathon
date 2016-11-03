//
//  MailSpeakObserver.m
//  outlook
//
//  Created by nevin on 11/2/16.
//
//

#import "MailSpeakObserver.h"
#import "OlkSpeechSynthesizer.h"
#import "OlkSpeakEvent.h"

static MailSpeakObserver* sSharedInstance_ = nil;

@interface MailSpeakObserver()
{
	OlkSpeechSynthesizer *synthesizer_;
	OlkSpeakEvent *speakEvent_;
}

@property (readonly) OlkSpeechSynthesizer *synthesizer;
@property (readwrite, retain) OlkSpeakEvent *speakEvent;

@end


@implementation MailSpeakObserver

@synthesize synthesizer = synthesizer_;
@synthesize speakEvent = speakEvent_;

- (instancetype)init
{
	self = [super init];
	
	if(self)
	{
		synthesizer_ = [OlkSpeechSynthesizer sharedInstance];
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
		[[self synthesizer] playMessage:(NSString*)[speakEvent data] onCompletionCallback:^(void){
			
			[self userSelection];
			
		}];
	}
}

-(void) userSelection
{
	
}

@end
