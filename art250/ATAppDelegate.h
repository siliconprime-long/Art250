//
//  ATAppDelegate.h
//  art250
//
//  Created by Winfred Raguini on 8/9/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navigationController;
+ (BOOL)systemGreaterThanVersion:(NSString*)reqSysVer;
@end
