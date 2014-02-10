//
//  ATLongPressImageView.h
//  art250
//
//  Created by Winfred Raguini on 12/16/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATDelegatedUIImageView.h"

typedef enum
{
    ATArtworkImageTypePreview = 0,
    ATArtworkImageTypePrevious,
    ATArtworkImageTypeNext
} ATArtworkImageType;

typedef enum
{
    ATArtworkEventTypeUnknown = 0,
    ATArtworkEventTypeAddedToCollection,
    ATArtworkEventTypePreview
} ATArtworkEventType;
@class ATInactiveArtworkProxy;
@class Artwork;
@interface ATLongPressImageView : ATDelegatedUIImageView
@property (nonatomic, strong) Artwork *artwork;
@property (nonatomic, strong) UIActivityIndicatorView *spinnerView;
@property (nonatomic, assign) ATArtworkEventType eventType;
- (void)updateWithArtObject:(Artwork *)artObject withRatio:(CGFloat)pixInchRatio forEventType:(ATArtworkEventType)eventType;
- (void)updateArtworkStatus;
- (void)updateWithInactiveArtworkProxy:(ATInactiveArtworkProxy*)artworkProxy;
@end
