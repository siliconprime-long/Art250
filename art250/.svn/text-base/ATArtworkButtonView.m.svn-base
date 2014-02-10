//
//  ATArtworkButtonView.m
//  art250
//
//  Created by Winfred Raguini on 4/11/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATArtworkButtonView.h"
#import "Artwork.h"
#import "Artist.h"
#import "ArtistProfile.h"

#define FADED_STATE_ALPHA 0.4f

@interface ATArtworkButtonView ()
- (void)buttonSelected:(id)sender;
@end

@implementation ATArtworkButtonView

BOOL _selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fadedState = ATArtworkButtonStateNormal;
        self.isFadeable = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.artworkButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        [self.artworkButton setBackgroundImage:[UIImage imageNamed:@"thumb_back_off.png"] forState:UIControlStateNormal];
        [self.artworkButton setBackgroundImage:[UIImage imageNamed:@"thumb_back.png"] forState:UIControlStateSelected];
        [self.artworkButton addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.artworkButton];
        
        
        self.artworkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.0f, 20.0f, 216.0f, 139.0f)];
        [self.artworkImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.artworkImageView];
        
        self.soldImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sold_share_cart.png"]];
        [self.artworkImageView addSubview:self.soldImageView];
        [self.soldImageView setHidden:YES];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 164.0f, self.frame.size.width, 14.0f)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 184.0f, self.frame.size.width, 21.0f)];
        self.artistLabel.textColor = [UIColor whiteColor];
        self.artistLabel.backgroundColor = [UIColor clearColor];
        self.artistLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.artistLabel];
        
        
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
#pragma mark
#pragma mark Private
- (void)setSelected:(BOOL)selected
{
    self.artworkButton.selected = selected;
}

- (BOOL)selected
{
    return self.artworkButton.selected;
}

- (void)setFadedState:(ATArtworkButtonState)fadedState
{
    _fadedState = fadedState;
    switch (fadedState) {
        case ATArtworkButtonStateNormal:
            self.alpha = 1.0;
            break;
        default:
            self.alpha = FADED_STATE_ALPHA;
            break;
    }
}

- (void)buttonSelected:(id)sender
{
    if (self.artObject != nil && ![self.artObject sold]) {
        if (self.isFadeable) {
            [self toggleFade];
        }
        self.artworkButton.selected = !self.artworkButton.selected;
        //NSLog(@"Button selected");
        if ([self.delegate respondsToSelector:@selector(didPressArtworkButton:)]) {
            [self.delegate performSelector:@selector(didPressArtworkButton:) withObject:self];
        }
    }
}

- (void)setArtObject:(Artwork *)artObject
{
    _artObject = artObject;
    _artObject.delegate = self;
    Artist *artist = _artObject.artist;
    ArtistProfile *profile = artist.profile;
    self.artistLabel.text = [profile fullName];
    self.titleLabel.text = artObject.title;
    self.artworkImageView.image = _artObject.artImage;
    if ([_artObject sold]) {
        CGRect soldImageViewFrame = self.soldImageView.frame;
        soldImageViewFrame.origin.x = self.artworkImageView.frame.size.width - soldImageViewFrame.size.width;
        soldImageViewFrame.origin.y = self.artworkImageView.frame.size.height - soldImageViewFrame.size.height;
        [self.soldImageView setFrame:soldImageViewFrame];
        [self.soldImageView setHidden:NO];
    } else {
        [self.soldImageView setHidden:YES];
    }
}

- (void)updateStatus
{
    [self.artObject updateStatus];
}

- (void)didCompleteUpdate:(Artwork*)artObject
{
    if ([self.artObject sold]) {
        [self.soldImageView setHidden:NO];
    } else {
        [self.soldImageView setHidden:YES];
    }
}

- (void)toggleFade
{
    switch (self.fadedState) {
        case ATArtworkButtonStateNormal:
            self.fadedState = ATArtworkButtonStateFaded;
            break;
            
        default:
            self.fadedState = ATArtworkButtonStateNormal;
            break;
    }
}

@end
