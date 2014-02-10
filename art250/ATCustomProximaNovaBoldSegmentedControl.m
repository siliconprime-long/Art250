//
//  ATCustomProximaNovaBoldSegmentedControl.m
//  art250
//
//  Created by Winfred Raguini on 8/27/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCustomProximaNovaBoldSegmentedControl.h"

@implementation ATCustomProximaNovaBoldSegmentedControl

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    - (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
    NSDictionary *textDict = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont fontWithName:@"ProximaNova-Bold" size:12.0f], NSFontAttributeName, nil];
    [self setTitleTextAttributes:textDict forState:UIControlStateNormal];
    
        //self.font = [UIFont fontWithName:@"ProximaNova-Light" size:self.font.pointSize];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
