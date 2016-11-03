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

@implementation MailSpeakObserver

- (void)handleSpeakEvent:(OlkSpeakEvent*)speakEvent
{
	if([speakEvent type] == SpeakEvent_NewMessage)
	{
		//Play "You have got a new message from X? Do you want to read?"
		OlkSpeechSynthesizer* synthesizer = [OlkSpeechSynthesizer sharedInstance];
		
		if([synthesizer playNewMessageNotification:@"Sender"])
		{
			//User want to read the message
			[synthesizer readNewMessage:nil];
		}
		else
		{
			//Done with this event
			
		}
	}
		
}

@end
