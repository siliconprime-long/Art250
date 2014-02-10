//
//  ATHitTestView.m
//  art250
//
//  Created by Winfred Raguini on 12/16/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATHitTestView.h"

@interface ATHitTestView ()
@property (nonatomic, strong, readwrite) UIButton *underButton;
@end

@implementation ATHitTestView
@synthesize underButton = _underButton;
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



@end
