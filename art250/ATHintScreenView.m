//
//  ATHintScreenView.m
//  art250
//
//  Created by Winfred Raguini on 5/31/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATHintScreenView.h"

@implementation ATHintScreenView

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
  //  [[NSNotificationCenter defaultCenter] postNotificationName:kdidDismissHintsView object:nil];
    if (CGRectContainsPoint(self.currentArtworkViewCopy.frame, point)) {
        //NSLog(@"Passing all touches to the next view (if any), in the view stack.");
        return NO;
    } else {
    
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidDismissHintsView object:nil];
        return YES;
    }
}

@end
