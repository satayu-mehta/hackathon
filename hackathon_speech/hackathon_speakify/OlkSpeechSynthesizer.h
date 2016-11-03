//
//  OlkSpeechSynthesizer.h
//  outlook
//
//  Created by nevin on 11/2/16.
//
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "ISpeakEventObserver.h"
#import "OlkSpeakEvent.h"

@class ECRecordUID;
@interface OlkSpeechSynthesizer : NSSpeechSynthesizer

+ (OlkSpeechSynthesizer *)sharedInstance;

- (BOOL)playNewMessageNotification:(NSString *) sender;
- (void)readNewMessage:(ECRecordUID *) inRecordUID;

@end
