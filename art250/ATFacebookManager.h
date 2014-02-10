//
//  ATFacebookManager.h
//  art250
//
//  Created by Winfred Raguini on 3/5/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATFacebookManager : NSObject
+(id)sharedManager;
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *userData;
- (void)checkAccount;
- (void)shareWithImage:(UIImage*)image text:(NSString*)text;
- (void)getUserData;
@end

