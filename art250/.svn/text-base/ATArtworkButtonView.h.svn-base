//
//  ATArtworkButtonView.h
//  art250
//
//  Created by Winfred Raguini on 4/11/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  ATArtworkButtonStateNormal = 0,
  ATArtworkButtonStateFaded
} ATArtworkButtonState;

@protocol ATArtworkButtonDelegate <NSObject>
@optional
- (void)didPressArtworkButton:(id)sender;
@end

@class Artwork;

@interface ATArtworkButtonView : UIView
@property (nonatomic, assign) id<ATArtworkButtonDelegate> delegate;
@property (nonatomic, strong) UIButton *artworkButton;
@property (nonatomic, strong) UIImageView *artworkImageView;
@property (nonatomic, strong) UIImageView *soldImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) Artwork *artObject;
@property (nonatomic, assign) ATArtworkButtonState fadedState;
@property (nonatomic, assign) BOOL isFadeable;
@property (nonatomic, assign) BOOL selected;
- (void)updateStatus;
@end
