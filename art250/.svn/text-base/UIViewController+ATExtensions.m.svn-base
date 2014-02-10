//
//  UIViewController+ATExtensions.m
//  art250
//
//  Created by Winfred Raguini on 3/4/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "UIViewController+ATExtensions.h"

@implementation UIViewController (ATExtensions)
+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}
@end
