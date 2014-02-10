//
//  ATSearchFilterButtonView.m
//  art250
//
//  Created by Winfred Raguini on 8/16/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATFilterButtonView.h"

@interface ATFilterButtonView ()
@property (nonatomic, retain, readwrite) UIImageView *buttonImageView;
@end

@implementation ATFilterButtonView
@synthesize buttonImageView = buttonImageView_;
@synthesize buttonImage = buttonImage_;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    if ([self.buttonImageView superview]) {
        [self.buttonImageView removeFromSuperview];
    }
    self.buttonImageView = [[UIImageView alloc] initWithImage:self.buttonImage];
    self.buttonImageView.center = self.center;
    [self addSubview:self.buttonImageView];
}

//- (void)toggleHighlight
//{
//    self.highlighted = !self.highlighted;
//    if (self.highlighted) {
//        [self setBackgroundColor:[UIColor whiteColor]];
//    } else {
//        [self setBackgroundColor:[UIColor clearColor]];
//    }
//}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        [self setBackgroundColor:[UIColor whiteColor]];
    } else {
        [self setBackgroundColor:[UIColor clearColor]];
    }
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
