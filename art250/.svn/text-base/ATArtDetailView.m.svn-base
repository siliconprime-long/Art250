//
//  ATArtDetailView.m
//  art250
//
//  Created by Winfred Raguini on 8/26/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATArtDetailView.h"



@implementation ATArtDetailView
@synthesize delegate = delegate_;
@synthesize artObject = artObject_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.artObject = [[ATArtObject alloc] init];
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

- (void)layoutSubviews
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    //background view
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    [backgroundView setAlpha:0.6f];
    [self addSubview:backgroundView];
    
    
    //Background Close button
    UIButton *backgroundCloseButton = [[UIButton alloc] initWithFrame:self.frame];
    [backgroundCloseButton addTarget:self.delegate action:@selector(closeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backgroundCloseButton];
    
    //left button
    UIButton *leftArrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 34.0f, 82.0f)];
    [leftArrowBtn setBackgroundImage:[UIImage imageNamed:@"leftArrowBtnLrgArtImg.png"] forState:UIControlStateNormal];
    [leftArrowBtn setAlpha:1.0f];
    CGRect leftArrowBtnFrame = leftArrowBtn.frame;
    leftArrowBtnFrame.origin.y = self.frame.size.height / 2.5f;
    leftArrowBtnFrame.origin.x = 80.0f;
    [leftArrowBtn setFrame:leftArrowBtnFrame];
    [self addSubview:leftArrowBtn];
    
    //right button
    UIButton *rightArrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 34.0f, 82.0f)];
    [rightArrowBtn setBackgroundImage:[UIImage imageNamed:@"rightArrowBtnLrgArtImg.png"] forState:UIControlStateNormal];
    [rightArrowBtn setAlpha:1.0f];
    CGRect rightArrowBtnFrame = rightArrowBtn.frame;
    rightArrowBtnFrame.origin.y = self.frame.size.height / 2.5f;
    rightArrowBtnFrame.origin.x = self.frame.size.width - (80.0f + rightArrowBtnFrame.size.width);
    [rightArrowBtn setFrame:rightArrowBtnFrame];
    [self addSubview:rightArrowBtn];
    
    //detail container frame
    UIView *detailContainerView = [[UIView alloc] initWithFrame:self.frame];
    [detailContainerView setBackgroundColor:[UIColor blackColor]];
    CGRect detailContainerFrame = detailContainerView.frame;
    detailContainerFrame.size.width = 700.0f;
    detailContainerFrame.origin.x = (self.frame.size.width - detailContainerFrame.size.width)/2.0f;
    detailContainerView.frame = detailContainerFrame;
    [self addSubview:detailContainerView];
//    //close button
//    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 23.0f, 23.0f)];
//    [closeButton setImage:[UIImage imageNamed:@"artDetailCloseImg.png"] forState:UIControlStateNormal];
//    [closeButton addTarget:self.delegate action:@selector(closeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
//    CGRect closeButtonFrame = closeButton.frame;
//    closeButtonFrame.origin.x = self.frame.size.width - 40.0f;
//    closeButtonFrame.origin.y = 20.0f;
//    [closeButton setFrame:closeButtonFrame];
//    [self addSubview:closeButton];
    //art image
    UIImageView *artImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"artLargeImage1.png"]];
    artImageView.center = CGPointMake(detailContainerFrame.size.width/2.0f, detailContainerFrame.size.height/2.0f);
    CGRect artImageViewFrame = artImageView.frame;
    artImageViewFrame.origin.y = 20.0f;
    [artImageView setFrame:artImageViewFrame];
    [detailContainerView addSubview:artImageView];
    
    //title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(artImageView.frame.origin.x, artImageView.frame.origin.x + artImageView.frame.size.height + 0.0f, artImageView.frame.size.width, 50.0f)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:35.0f];
    titleLabel.text = @"";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [detailContainerView addSubview:titleLabel];
}

@end
