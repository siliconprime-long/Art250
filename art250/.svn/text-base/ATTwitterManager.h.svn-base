//
//  ATTwitterEngine.h
//  art250
//
//  Created by Winfred Raguini on 3/4/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ATTwitterManager;
@protocol ATTwitterManagerDelegate <NSObject>
@optional
- (void)willSendTweet;
- (void)didSendTweet;
- (void)tweetDidFail:(NSError*)error;
@end

@interface ATTwitterManager : NSObject
+(id)sharedManager;
- (void)postImage:(UIImage *)image withStatus:(NSString *)status;
- (void)checkAccount;
- (void)getUserData;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) id<ATTwitterManagerDelegate> delegate;
@end
