//
//  UIColor+WRExtensions.m
//  art250
//
//  Created by Winfred Raguini on 12/30/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "UIColor+WRExtensions.h"

@implementation UIColor (WRExtensions)
- (UIColor*)complementaryColor
{
    CGFloat red = 0.0f, green = 0.0f, blue = 0.0f, alpha = 0.0f;
    if ([self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        return [UIColor colorWithRed:1.0 - red green:1.0 - green blue:1.0 - blue alpha:1.0];
    } 
    return self;
}

-(NSString *) uiColorToHexString {
    CGFloat red,green,blue,alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    NSString *hexString  = [NSString stringWithFormat:@"#%02x%02x%02x%02x",
                            ((int)alpha),((int)red),((int)green),((int)blue)];
    return hexString;
}

@end
