//
//  ATProgressHUD.h
//  art250
//
//  Created by Winfred Raguini on 3/4/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ATProgressHUDManager : NSObject
+(id)sharedManager;
- (void)showHUDMessage:(NSString*)message;
- (void)showHUDMessage:(NSString*)message withMode:(MBProgressHUDMode)mode;
+ (BOOL)hideCurrentHUD;
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;
@end
