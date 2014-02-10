//
//  ATArtContainerViewController.h
//  art250
//
//  Created by Winfred Raguini on 8/24/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATSlotView.h"

@class ATSearchViewController;
@class ATWishlistViewController;
@class ATArtDetailView;
@class ATHangitContainerViewController;
@interface ATArtContainerViewController : UIViewController <UIGestureRecognizerDelegate, ATSlotViewDelegate, UIPopoverControllerDelegate>
@property (nonatomic, readonly, strong) ATArtDetailView *detailView;
@property (nonatomic, strong) ATWishlistViewController *wishlistController;
//@property (nonatomic, strong) ATSearchViewController* searchController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) ATHangitContainerViewController *hangItController;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIView *darkeningView;
@property (nonatomic, strong) UIView *darkeningViewContainerView;
@property (nonatomic, strong) UIView *signUpSignInContainerView;
- (void)profileButtonSelected;
- (void)clearBackground;
@end
