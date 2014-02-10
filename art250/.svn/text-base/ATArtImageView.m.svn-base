//
//  ATArtImageView.m
//  art250
//
//  Created by Winfred Raguini on 8/25/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATArtImageView.h"
#import "ATArtObject.h"

@interface ATArtImageView ()
@property (nonatomic, retain, readwrite) UIImageView *artImageView;
@property (nonatomic, retain, readwrite) UIImage *artImage;
@end

@implementation ATArtImageView
@synthesize artImage = artImage_;
@synthesize artImageView = artImageView_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithATArtObject:(ATArtObject*)artObject
{
    if (self = [self initWithFrame:CGRectMake(0.0f, 0.0f, 140.0f, 140.0f)]) {
        self.artObject = artObject;
    }
    return self;
}

- (void)layoutSubviews
{
    if ([self.artImageView superview]) {
        [self.artImageView removeFromSuperview];
    }
    if (self.artObject) {
        self.artImageView = [[UIImageView alloc] initWithImage:self.artObject.artImage];
        CGRect artImageViewFrame = self.artImageView.frame;
        artImageViewFrame.size.height = self.frame.size.height;
        artImageViewFrame.size.width = self.frame.size.width;
        self.artImageView.frame = artImageViewFrame;
        //NSLog(@"width %1.2f", self.artImageView.frame.size.width);
//        self.artImageView.center = self.center;
        [self addSubview:self.artImageView];
    }
    
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
//    [self.artButton addTarget:target action:action forControlEvents:controlEvents];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)artButtonSelected:(id)sender
{

}

@end
