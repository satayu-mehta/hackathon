/*!
	@file		OlkSpeakEvent.h
	
	@author		Michael Leung (mileun)
	@date		Copyright 2016 Microsoft Corporation. All rights reserved.
 */

#import <Foundation/Foundation.h>

typedef enum OlkSpeakEventType {
	SpeakEvent_EnableSystem,
	SpeakEvent_DisableSystem,
		SpeakEvent_NewMessage,
	SpeakEvent_COUNT
} OlkSpeakEventType;

@interface OlkSpeakEvent : NSObject
@property (nonatomic, assign) OlkSpeakEventType type;
@property (nonatomic, retain) NSObject* data;

- (id)initWithType:(OlkSpeakEventType)type andData:(NSObject*)data;
@end
