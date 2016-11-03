//
//  OlkSpeechSynthesizer.m
//  outlook
//
//  Created by nevin on 11/2/16.
//
//

#import "OlkSpeechSynthesizer.h"

static OlkSpeechSynthesizer* sSharedInstance_ = nil;

@interface OlkSpeechSynthesizer()
{
	NSSpeechSynthesizer *synthesizer;
	onCompletionCallback callback;
}

@end


@implementation OlkSpeechSynthesizer

- (instancetype)init
{
	self = [super init];
	
	synthesizer = [[NSSpeechSynthesizer alloc] init];
	[synthesizer setDelegate:self];
	
	return self;
}

- (void)dealloc
{
	[synthesizer release]; synthesizer = nil;
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


-(void) playMessage:(NSString *)message onCompletionCallback:completionBlock
{
	// release previous block.
	if(callback)
	{
		Block_release(callback);
	}
	
	callback = Block_copy(completionBlock);
	[synthesizer startSpeakingString:message];
}

-(void) speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking
{
	[callback invoke];
}

@end
