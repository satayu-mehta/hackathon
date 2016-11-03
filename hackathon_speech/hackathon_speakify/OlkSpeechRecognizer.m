//
//  OlkSpeechRecognizer.m
//  outlook
//
//  Created by satayu on 11/2/16.
//
//

#import "OlkSpeechRecognizer.h"

static OlkSpeechRecognizer* sSharedInstance_ = nil;

@interface OlkSpeechRecognizer()
{
	NSSpeechRecognizer *recognizer;
	onRecognizerCallback callback;
    NSArray *cmds;
}

@end


@implementation OlkSpeechRecognizer

- (instancetype)init
{
	self = [super init];
	
	recognizer = [[NSSpeechRecognizer alloc] init];
	[recognizer setDelegate:self];
	
	return self;
}

- (void)dealloc
{
	[recognizer release]; recognizer = nil;
	[super dealloc];
}

+ (OlkSpeechRecognizer*)sharedInstance
{
	if(sSharedInstance_ == nil)
	{
		sSharedInstance_ = [[OlkSpeechRecognizer alloc] init];
	}
	return sSharedInstance_;
}


-(void) listenToCommands:(NSArray *)commands onRecognizerCallback:completionBlock;
{
	// release previous block.
	if(callback)
	{
		Block_release(callback);
        [cmds release];
	}
	
	callback = Block_copy(completionBlock);
    cmds = [commands copy];

    [recognizer setCommands:commands];
    [recognizer setListensInForegroundOnly:NO];
    [recognizer startListening];
    [recognizer setBlocksOtherRecognizers:YES];
}

- (void)speechRecognizer:(NSSpeechRecognizer *)sender didRecognizeCommand:(id)aCmd
{
    callback(aCmd);
}

-(void) stopListening
{
    [recognizer stopListening];
}


@end
