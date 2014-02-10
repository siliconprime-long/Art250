//
//  BPManager.m
//  art250
//
//  Created by Winfred Raguini on 6/5/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "BPManager.h"

#define kBPCardURIKey @"cardURI"
#define kBPCardLastFourDigitsKey @"cardLastFourDigits"

@implementation BPManager

+ (BPManager*)sharedManager {
    static BPManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[BPManager alloc] init];
    });
    
    return _sharedManager;
}

- (void)setCardURI:(NSString *)cardURI
{
    [[NSUserDefaults standardUserDefaults] setValue:cardURI forKey:kBPCardURIKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)cardURI
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kBPCardURIKey];
}

- (void)setCardLastFourDigits:(NSString *)cardLastFourDigits
{
    [[NSUserDefaults standardUserDefaults] setValue:cardLastFourDigits forKey:kBPCardLastFourDigitsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)cardLastFourDigits
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kBPCardLastFourDigitsKey];
}

@end
