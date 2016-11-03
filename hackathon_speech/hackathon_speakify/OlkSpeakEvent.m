/*!
	@file		OlkSpeakEvent.m
	
	@author		Michael Leung (mileun)
	@date		Copyright 2016 Microsoft Corporation. All rights reserved.
 */

#import "OlkSpeakEvent.h"

@implementation OlkSpeakEvent
- (id)initWithType:(OlkSpeakEventType)type andData:(NSObject*)data
{
	self = [super init];
	if (self)
	{
		_type = type;
		_data = [data retain];
	}
	return self;
}

- (id) init
{
	return [self initWithType:SpeakEvent_COUNT andData:nil];
}

- (void)dealloc
{
	[_data release]; _data = nil;
	[super dealloc];
}
@end
