//
//  ATProgressHUD.m
//  art250
//
//  Created by Winfred Raguini on 3/4/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATProgressHUDManager.h"
#import "MBProgressHUD.h"
#import "UIViewController+ATExtensions.h"

@implementation ATProgressHUDManager
+(id)sharedManager
{
    static dispatch_once_t pred;
    static ATProgressHUDManager *_sharedManager = nil;
    dispatch_once(&pred, ^{
        _sharedManager = [[ATProgressHUDManager alloc] init];
    });
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    // implement -dealloc & remove abort() when refactoring for
    // non-singleton use.
    abort();
}

#pragma mark
- (void)showHUDMessage:(NSString*)message
{
    [self showHUDMessage:message withMode:MBProgressHUDModeText];
}

- (void)showHUDMessage:(NSString*)message withMode:(MBProgressHUDMode)mode
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIViewController topMostController].view animated:YES];
    hud.mode = mode;
    hud.labelText = message;
}

+ (BOOL)hideCurrentHUD
{
    return [self hideHUDForView:[UIViewController topMostController].view animated:YES];
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated
{
    return [MBProgressHUD hideHUDForView:view animated:animated];
}

@end
