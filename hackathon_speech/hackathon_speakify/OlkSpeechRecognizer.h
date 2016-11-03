//
//  OlkSpeechRecognizer.h
//  outlook
//
//  Created by satayu on 11/2/16.
//
//

#import <AppKit/AppKit.h>
#import "OlkSpeakEvent.h"


@interface OlkSpeechRecognizer : NSObject <NSSpeechRecognizerDelegate>

+ (OlkSpeechRecognizer *)sharedInstance;

-(void) listenToCommands:(NSArray *)commands onRecognizerCallback:completionBlock;

-(void) stopListening;

@end
