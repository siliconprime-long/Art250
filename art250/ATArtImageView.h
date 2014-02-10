//
//  ATArtImageView.h
//  art250
//
//  Created by Winfred Raguini on 8/25/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATArtObject;
@interface ATArtImageView : UIView
@property (nonatomic, strong) UIButton *artButton;
@property (nonatomic, retain, readonly) UIImage *artImage;
@property (nonatomic, retain, readonly) UIImageView *artImageView;
@property (nonatomic, strong) ATArtObject *artObject;
- (id)initWithATArtObject:(ATArtObject*)artObject;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
