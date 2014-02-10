//
//  ATPanningImageView.m
//  art250
//
//  Created by Winfred Raguini on 12/16/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATPanningImageView.h"

@interface ATPanningImageView (Private)
- (void)enablePanGestureRecognizer;
@end

@implementation ATPanningImageView
@synthesize delegate = _delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self enablePanGestureRecognizer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self enablePanGestureRecognizer];
    }
    return self;
}

- (void)enablePanGestureRecognizer
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panningDetected:)];
    [panRecognizer setCancelsTouchesInView:NO];
    [self addGestureRecognizer:panRecognizer];
    [self setUserInteractionEnabled:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)panningDetected:(UIPanGestureRecognizer*)recognizer
{
    if ([self.delegate respondsToSelector:@selector(panningDetected:)]) {
        [self.delegate performSelector:@selector(panningDetected:) withObject:recognizer];
    }
}

@end
