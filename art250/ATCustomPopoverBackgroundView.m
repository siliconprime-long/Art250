//
//  ATCustomPopoverBackgroundView.m
//  art250
//
//  Created by Winfred Raguini on 4/1/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCustomPopoverBackgroundView.h"
#import <QuartzCore/QuartzCore.h>

#define CONTENT_INSET 0.0f

@implementation ATCustomPopoverBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _borderImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg_settings.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(44.0f, 44.0f, 44.0f, 44.0f)]];
        [self addSubview:_borderImageView];
//        self.layer.cornerRadius = 0.0f;
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

- (CGFloat) arrowOffset {
    return _arrowOffset;
}

- (void) setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
}

- (UIPopoverArrowDirection)arrowDirection {
    return _arrowDirection;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
}


+(UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(CONTENT_INSET, CONTENT_INSET, CONTENT_INSET, CONTENT_INSET);
}

+(CGFloat)arrowHeight{
    return ARROW_HEIGHT;
}

+(CGFloat)arrowBase{
    return ARROW_BASE;
}

- (void)layoutSubviews
{
    CGFloat _height = self.frame.size.height;
    CGFloat _width = self.frame.size.width;
    CGFloat _left = 0.0;
    CGFloat _top = -5.0;
    
    _borderImageView.frame =  CGRectMake(_left, _top, _width, _height);
}

@end
