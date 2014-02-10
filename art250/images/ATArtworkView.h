//
//  ATArtworkButtonView.h
//  art250
//
//  Created by Winfred Raguini on 4/11/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Artwork;
@interface ATArtworkView : UIView
@property (nonatomic, strong) UIImageView *artworkImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) Artwork *artObject;

@end
