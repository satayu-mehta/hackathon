/*!
	@file		OlkSpeakEventQueue.h
	
	@author		Michael Leung (mileun)
	@date		Copyright 2016 Microsoft Corporation. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "ISpeakEventObserver.h"
#import "OlkSpeakEvent.h"

@interface OlkSpeakEventQueue : NSObject
{
	NSArray* _observersByType;
	NSArray* _events;
	//Index of the next free event slot.
	unsigned int _eventsHead;
	//Index of the last used event slot.
	unsigned int _eventsTail;
}

+ (OlkSpeakEventQueue*)getInstance;

- (void)addObserver:(NSObject<ISpeakEventObserver>*)observer forType:(OlkSpeakEventType)type;
- (void)removeObserver:(NSObject<ISpeakEventObserver>*)observer forType:(OlkSpeakEventType)type;
- (void)removeObserver:(NSObject<ISpeakEventObserver>*)observer;
- (void)postEventOfType:(OlkSpeakEventType)type withDataOrNil:(NSObject*)data;
- (void)postEventOfType:(OlkSpeakEventType)type;
@end
