/*!
	@file		OlkSpeakEvent.h
	
	@author		Michael Leung (mileun)
	@date		Copyright 2016 Microsoft Corporation. All rights reserved.
 */

#import <Foundation/Foundation.h>

typedef enum OlkSpeakEventType {
	SpeakEvent_NewMessage,
    SpeakEvent_OperationCompleted,
	SpeakEvent_COUNT
} OlkSpeakEventType;

// Define a new type for the block
typedef void (^onSynthesizerCallback)(void);

typedef void (^onRecognizerCallback)(NSString*);

@interface OlkSpeakEvent : NSObject
@property (nonatomic, assign) OlkSpeakEventType type;
@property (nonatomic, retain) NSObject* data;

- (id)initWithType:(OlkSpeakEventType)type andData:(NSObject*)data;
@end
