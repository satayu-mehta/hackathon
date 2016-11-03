/*!
	@file		ISpeakEventObserver.h
	
	@author		Michael Leung (mileun)
	@date		Copyright 2016 Microsoft Corporation. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "OlkSpeakEvent.h"

/*
 An example of the observers is the recognizer (let's call it
 OlkSpeakRecognizer) and the synthesizer (OlkSpeakSynthesizer).
 Let's say they both want to listen for screen lock/unlock, but the
 recognizer also wants to listen for synthesizer events
 (so it knows not to read commands from the microphone while the speaker is active)
 and the synthesizer wants to listen for commands from the recognizer.
 
 In OlkSpeakEvent.h:
	Add SpeakEvent_StartSynthSpeech, SpeakEvent_EndSynthSpeech,
	SpeakEvent_RecognizerCommand
	to OlkSpeakEventType.
 
 In OlkSpeakRecognizer.h:
	@protocol OlkSpeakRecognizer : NSObject<ISpeakEventObserver>
	{
	}
	...
	@property (nonatomic, assign) BOOL active;
	- (void)handleSpeakEvent:(OlkSpeakEvent*)speakEvent;
	- (void)listenForCommand;
	@end
 In OlkSpeakRecognizer.m:
	@implementation OlkSpeakRecognizer
	- (id)init
	{
		if( (self = [super init]) )
		{
			[[OlkSpeakEventQueue getInstance] addObserver:self forType:SpeakEvent_StartSynthSpeech];
			[[OlkSpeakEventQueue getInstance] addObserver:self forType:SpeakEvent_EndSynthSpeech];
			[[OlkSpeakEventQueue getInstance] addObserver:self forType:SpeakEvent_EnableSystem];
			[[OlkSpeakEventQueue getInstance] addObserver:self forType:SpeakEvent_DisableSystem];
		}
		return self;
	}

	- (void)dealloc
	{
		[[OlkSpeakEventQueue getInstance] removeObserver:self];
		[super dealloc];
	}

	- (void)handleSpeakEvent:(OlkSpeakEvent*)speakEvent
	{
		switch([speakEvent type])
		{
			//Disable the recognizer
			//when the screen is locked
			//or the synthesizer is speaking.
			case SpeakEvent_DisableSystem:
			case SpeakEvent_StartSynthSpeech:
				//Disable the recognizer.
				[self setActive:NO];
				break;
			//Enable the recognizer
			//when the screen is unlocked
			//or the synthesizer has stopped speaking.
			case SpeakEvent_EnableSystem:
			case SpeakEvent_EndSynthSpeech:
				[self setActive:YES];
				break;
		}
	}

	- (void)listenForCommand
	{
		if([self active])
		{
			//Convert microphone input to a command...
			RecognizerCommand* command = ...;

			[[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_RecognizerCommand withData:command];
		}
	}
	@end
 
 In OlkSpeakSynthesizer.h:
	@protocol OlkSpeakSynthesizer : NSObject<ISpeakEventObserver>
	...
	@property (nonatomic, assign) BOOL active;
	- (void)handleSpeakEvent:(OlkSpeakEvent*)speakEvent;
	@end
 In OlkSpeakSynthesizer.m:
	@implementation OlkSpeakSynthesizer
	- (id)init
	{
		if( (self = [super init]) )
		{
			[[OlkSpeakEventQueue getInstance] addObserver:self forType:SpeakEvent_RecognizerCommand];
			[[OlkSpeakEventQueue getInstance] addObserver:self forType:SpeakEvent_EnableSystem];
			[[OlkSpeakEventQueue getInstance] addObserver:self forType:SpeakEvent_DisableSystem];
		}
		return self;
	}

	- (void)dealloc
	{
		[[OlkSpeakEventQueue getInstance] removeObserver:self];
		[super dealloc];
	}
 
	- (void)synthesizeSpeech:(NSString*)speech
	{
		if([self active])
		{
			[[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_StartSynthSpeech];
			//Play the speech.
			...
			[[OlkSpeakEventQueue getInstance] postEventOfType:SpeakEvent_EndSynthSpeech];
		}
	}

	- (void)handleSpeakEvent:(OlkSpeakEvent*)speakEvent
	{
		switch([speakEvent type])
		{
			//Disable the recognizer
			//when the screen is locked
			//or the synthesizer is speaking.
			case SpeakEvent_DisableSystem:
			//Disable the recognizer.
			[self setActive:NO];
			break;
			//Enable the recognizer
			//when the screen is unlocked
			//or the synthesizer has stopped speaking.
			case SpeakEvent_EnableSystem:
			[self setActive:YES];
			break;
			//Synthesize speech data.
			case SpeakEvent_RecognizerCommand:
			[self synthesizeSpeech:[speakEvent data]];
			break;
		}
	}
	@end
 */
@protocol ISpeakEventObserver <NSObject>

- (void)handleSpeakEvent:(OlkSpeakEvent*)speakEvent;

@end
