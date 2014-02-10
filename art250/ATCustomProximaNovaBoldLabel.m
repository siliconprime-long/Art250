//
//  ATCustomProximaNovaBoldLabel.m
//  art250
//
//  Created by Winfred Raguini on 8/27/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCustomProximaNovaBoldLabel.h"

@implementation ATCustomProximaNovaBoldLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"ProximaNova-Bold" size:self.font.pointSize];
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