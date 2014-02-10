//
//  ATSlotView.h
//  art250
//
//  Created by Winfred Raguini on 3/27/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SLOTVIEW_RECOGNIZER_KEY @"recognizer"
#define SLOTVIEW_ARTOBJECT_KEY @"artObject"

@class Artwork;
@interface ATSlotView : UIImageView
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, retain) Artwork *artObject;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) id delegate;
- (void)displaySavedCollectionObject;
- (void)reset;
- (void)updateSoldDisplay;
@end

@protocol ATSlotViewDelegate
@optional
- (void)slotView:(ATSlotView*)slotView didPanWithUserInfo:(NSDictionary*)userInfo;
@end