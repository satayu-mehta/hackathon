/*!
	@file		OlkSpeakEventQueue.m
	
	@author		Michael Leung (mileun)
	@date		Copyright 2016 Microsoft Corporation. All rights reserved.
 */

#import "OlkSpeakEventQueue.h"

#import <Cocoa/Cocoa.h>
#import "OlkSpeakMacros.h"

static OlkSpeakEventQueue* sEventQueueInstance = nil;

static int sExpectedMaxEventsPerType = 1024;
static CFTimeInterval sMaxProcessTimeSeconds = 0.100;
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
		
		_dispatchQueue = [[NSOperationQueue alloc] init];
		[_dispatchQueue setMaxConcurrentOperationCount:1];
		[_dispatchQueue setName:@"OlkSpeakEvent Operation Queue"];
		//Prime the dispatch loop.
		[_dispatchQueue addOperation:[[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(processEvents) object:nil] autorelease]];
	}
	return self;
}

- (void)dealloc
{
	[_dispatchQueue release];
	//Remove all events.
	[_events release];
	//Remove all subscribers.
	[_observersByType release];
	
	[super dealloc];
}

- (BOOL)canAdvanceTail
{
	unsigned int newTail = (_eventsTail + 1) % sExpectedMaxEventsPerType;
	return newTail != _eventsHead;
}

- (BOOL)canAdvanceHead
{
	return _eventsHead != _eventsTail;
}

- (void)advanceHead
{
    AssertSz([self canAdvanceHead], @"Trying to move queue head past tail");

	//The head object isn't used anymore, so remove its data too.
	OlkSpeakEvent* headEvent = [_events objectAtIndex:_eventsHead];
	[headEvent setType:SpeakEvent_COUNT];
	[headEvent setData:nil];
	_eventsHead = (_eventsHead + 1) % sExpectedMaxEventsPerType;
}

- (void)advanceTail
{
	AssertSz([self canAdvanceTail], @"Trying to move queue tail ahead of head");
	_eventsTail = (_eventsTail + 1) % sExpectedMaxEventsPerType;
}

- (void)processEvents
{
	CFTimeInterval timeStart = CACurrentMediaTime();
	CFTimeInterval timeMax = timeStart + sMaxProcessTimeSeconds;
	for(int i = _eventsHead; i != _eventsTail; i = i + 1 % sExpectedMaxEventsPerType)
	{
		OlkSpeakEvent* eventToPost = [_events objectAtIndex:i];
		AssertSz([eventToPost type] != SpeakEvent_COUNT, @"Trying to process invalid event");
		//Then broadcast it. This can be an asynchronous event if needed.
		NSArray* observerArray = [_observersByType objectAtIndex:[eventToPost type]];
		for(NSObject<ISpeakEventObserver>* observer in observerArray)
		{
			[observer handleSpeakEvent:eventToPost];
		}
		
		//Event is done broadcasting, update the head.
		[self advanceHead];
	}
	
	//If we finished early, sleep the processing thread.
	CFTimeInterval remainingTime = timeMax - timeStart;
	if(remainingTime > 0)
	{
		[NSThread sleepForTimeInterval:remainingTime];
	}

	//Schedule the next process event call.
	[_dispatchQueue addOperation:[[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(processEvents) object:nil] autorelease]];
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
	//Create and enqueue the event.
	if([self canAdvanceTail])
	{
		//Get the next free event.
		OlkSpeakEvent* event = [_events objectAtIndex:_eventsTail];
		[event setType:type];
		[event setData:data];
		
		//Update the tail only.
		[self advanceTail];
	}
}

- (void)postEventOfType:(OlkSpeakEventType)type
{
	[self postEventOfType:type withDataOrNil:nil];
}
@end
