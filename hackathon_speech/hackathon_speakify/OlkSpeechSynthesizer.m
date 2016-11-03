//
//  OlkSpeechSynthesizer.m
//  outlook
//
//  Created by nevin on 11/2/16.
//
//

#import <Foundation/Foundation.h>
#import "OlkSpeechSynthesizer.h"
#import "OlkSpeakMacros.h"

static OlkSpeechSynthesizer* sSharedInstance_ = nil;

@implementation OlkSpeechSynthesizer

- (instancetype)init
{
	self = [super init];
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

+ (OlkSpeechSynthesizer*)sharedInstance
{
	if(sSharedInstance_ == nil)
	{
		sSharedInstance_ = [[OlkSpeechSynthesizer alloc] init];
	}
	return sSharedInstance_;
}

@end
