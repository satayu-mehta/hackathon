/*!
	@file		OlkSpeakEventQueue.m
	
	@author		Michael Leung (mileun)
	@date		Copyright 2016 Microsoft Corporation. All rights reserved.
 */

#import "OlkSpeakEventQueue.h"

static OlkSpeakEventQueue* sEventQueueInstance = nil;

static int sExpectedMaxEventsPerType = 1024;
@implementation OlkSpeakEventQueue
- (instancetype)init
{
	self = [super init];
	if (self)
	{
		NSMutableArray* observerArray = [[[NSMutableArray alloc] initWithCapacity:SpeakEvent_COUNT] autorelease];
		for(int i = 0; i < SpeakEvent_COUNT; ++i)
		{
			[observerArray insertObject:[[[NSMutableArray alloc] init] autorelease] atIndex:i];
		}
		_observersByType = [observerArray copy];
		
		NSMutableArray* eventArray = [[[NSMutableArray alloc] initWithCapacity:sExpectedMaxEventsPerType] autorelease];
		for(int i = 0; i < sExpectedMaxEventsPerType; ++i)
		{
			[eventArray insertObject:[[[OlkSpeakEvent alloc] init] autorelease] atIndex:i];
		}
		_events = [eventArray copy];
		_eventsHead = 0;
		_eventsTail = 0;
	}
	return self;
}

- (void)dealloc
{
	//Remove all subscribers.
	[_observersByType release];
	//Remove all events.
	[_events release];
	[super dealloc];
}

- (BOOL)canAdvanceHead
{
	unsigned int newHead = (_eventsHead + 1) % sExpectedMaxEventsPerType;
	return newHead != _eventsTail;
}

- (BOOL)canAdvanceTail
{
	return _eventsTail != _eventsHead;
}

- (void)advanceHead
{
	AssertSz([self canAdvanceHead], "Trying to move queue head past tail");
	_eventsHead = (_eventsHead + 1) % sExpectedMaxEventsPerType;
}

- (void)advanceTail
{
	AssertSz([self canAdvanceTail], "Trying to move queue tail ahead of head");
	//The tail object isn't used
	_eventsTail = (_eventsTail + 1) % sExpectedMaxEventsPerType;
}

- (OlkSpeakEvent*)addEventOfType:(OlkSpeakEventType)type withDataOrNil:(NSObject*)data
{
	if(![self canAdvanceHead])
	{
		return nil;
	}
	
	//Get the next free event.
	OlkSpeakEvent* event = [_events objectAtIndex:_eventsHead];
	[event setType:type];
	[event setData:data];
	
	//Update the head only.
	[self advanceHead];
	
	return event;
}

#pragma mark - Public Interface
+ (OlkSpeakEventQueue*)getInstance
{
	if(sEventQueueInstance == nil)
	{
		sEventQueueInstance = [[OlkSpeakEventQueue alloc] init];
	}
	AssertSz(sEventQueueInstance != nil, @"Couldn't initialize event queue instance!");
	return sEventQueueInstance;
}

- (void)addObserver:(NSObject<ISpeakEventObserver>*)observer forType:(OlkSpeakEventType)type
{
	[[_observersByType objectAtIndex:type] addObject:observer];
}

- (void)removeObserver:(NSObject<ISpeakEventObserver>*)observer forType:(OlkSpeakEventType)type
{
	[[_observersByType objectAtIndex:type] removeObject:observer];
}

- (void)removeObserver:(NSObject<ISpeakEventObserver>*)observer
{
	//Remove observer from all event types.
	for(NSMutableArray* observerArray in _observersByType)
	{
		[observerArray removeObject:observer];
	}
}

- (void)postEventOfType:(OlkSpeakEventType)type withDataOrNil:(NSObject*)data
{
	//Create the event...
	OlkSpeakEvent* eventToPost = [self addEventOfType:type withDataOrNil:data];
	
	if(eventToPost != nil)
	{
		//Then broadcast it. This can be an asynchronous event if needed.
		NSArray* observerArray = [_observersByType objectAtIndex:type];
		for(NSObject<ISpeakEventObserver>* observer in observerArray)
		{
			[observer handleSpeakEvent:eventToPost];
		}
		
		//Event is done broadcasting, update the tail.
		[self advanceTail];
	}
}

- (void)postEventOfType:(OlkSpeakEventType)type
{
	[self postEventOfType:type withDataOrNil:nil];
}
@end
