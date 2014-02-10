//
//  ATTouchPassThroughView.m
//  art250
//
//  Created by Winfred Raguini on 4/23/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATTouchPassThroughView.h"

@implementation ATTouchPassThroughView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //NSLog(@"Passing all touches to the next view (if any), in the view stack.");
    return NO;
}

@end
