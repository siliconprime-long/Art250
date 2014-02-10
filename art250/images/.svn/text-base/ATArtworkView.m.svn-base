//
//  ATArtworkButtonView.m
//  art250
//
//  Created by Winfred Raguini on 4/11/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATArtworkView.h"
#import "ArtistProfile.h"
#import "Artist.h"
#import "Artwork.h"
#import <QuartzCore/QuartzCore.h>

#define IMAGEVIEW_LEFT_OFFSET 8.0f
#define IMAGEVIEW_RIGHT_OFFSET 8.0f
#define IMAGEVIEW_TOP_OFFSET 8.0f
#define IMAGEVIEW_BOTTOM_OFFSET 49.0f

#define ARTIST_NAME_LABEL_HEIGHT 21.0f
#define ARTWORK_TITLE_LABEL_HEIGHT 21.0f

@implementation ATArtworkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setHidden:YES];
        [self setBackgroundColor:[[UIColor alloc] initWithRed:20.0f/255.0f green:39.0f/255.0f blue:45.0f/255.0f alpha:1.0f]];
        self.layer.cornerRadius = 4.0f;
        
        self.artworkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGEVIEW_LEFT_OFFSET, IMAGEVIEW_TOP_OFFSET, self.frame.size.width - (IMAGEVIEW_LEFT_OFFSET + IMAGEVIEW_RIGHT_OFFSET), self.frame.size.height - (IMAGEVIEW_BOTTOM_OFFSET))];
        [self addSubview:self.artworkImageView];
        [self.artworkImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        self.artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - ARTIST_NAME_LABEL_HEIGHT, self.frame.size.width, ARTIST_NAME_LABEL_HEIGHT)];
        self.artistLabel.textColor = [UIColor whiteColor];
        self.artistLabel.backgroundColor = [UIColor clearColor];
        self.artistLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.artistLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - (self.artistLabel.frame.size.height + ARTWORK_TITLE_LABEL_HEIGHT), self.frame.size.width, ARTWORK_TITLE_LABEL_HEIGHT)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        

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

- (void)setArtObject:(Artwork *)artObject
{
    _artObject = artObject;
    if (artObject != nil) {
        [self setHidden:NO];
        Artist *artist = _artObject.artist;
        ArtistProfile *profile = artist.profile;
        self.artistLabel.text = [profile fullName];
        self.titleLabel.text = artObject.title;
        self.artworkImageView.image = _artObject.artImage;
    }
}


@end
