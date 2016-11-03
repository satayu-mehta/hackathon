//
//  OlkSpeechSynthesizer.h
//  outlook
//
//  Created by nevin on 11/2/16.
//
//

#import <Foundation/Foundation.h>
#import "ISpeakEventObserver.h"
#import "OlkSpeakEvent.h"


@interface OlkSpeechSynthesizer : NSObject

+ (OlkSpeechSynthesizer *)sharedInstance;

@end
