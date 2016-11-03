//
//  OlkSpeechSynthesizer.h
//  outlook
//
//  Created by nevin on 11/2/16.
//
//

#import <AppKit/AppKit.h>
#import "ISpeakEventObserver.h"
#import "OlkSpeakEvent.h"


@interface OlkSpeechSynthesizer : NSObject <NSSpeechSynthesizerDelegate>

+ (OlkSpeechSynthesizer *)sharedInstance;

-(void) playMessage:(NSString *)message onSynthesizerCallback:completionBlock;

@end
