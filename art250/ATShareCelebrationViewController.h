//
//  ATShareCelebrationViewController.h
//  art250
//
//  Created by Winfred Raguini on 7/30/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATShareViewController.h"

@interface ATShareCelebrationViewController : ATShareViewController

@property (nonatomic, strong) NSArray *artworkArray;
@property (nonatomic, strong) IBOutlet UILabel *shareTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *shareImageView;
@property (nonatomic, assign) BOOL shouldShowThumbnails;
//@property (nonatomic, strong) IBOutlet UITextView *shareMsgView;
//
//@property (nonatomic, strong) IBOutlet UISwitch *fbSwitch;
//@property (nonatomic, strong) IBOutlet UISwitch *twitterSwitch;
//
//@property (nonatomic, strong) IBOutlet UIButton *shareBtn;
//@property (nonatomic, strong) IBOutlet UIButton *emailBtn;

@property (nonatomic, strong) IBOutlet UIView *shareCroppedBtnContainerView;
@property (nonatomic, strong) IBOutlet UIButton *shareCroppedImageBtn1;
@property (nonatomic, strong) IBOutlet UIButton *shareCroppedImageBtn2;
@property (nonatomic, strong) IBOutlet UIButton *shareCroppedImageBtn3;
@property (nonatomic, strong) IBOutlet UIButton *shareCroppedImageBtn4;

@property (nonatomic, strong) IBOutlet UISegmentedControl *artworkArtonWallCtrl;
@property (nonatomic, strong) NSString *shareMessageString;
@property (nonatomic, strong) NSString *shareTitleString;

- (IBAction)changeArtworkToShareSelected:(id)sender;
- (IBAction)artworkFramingTypeChanged:(id)sender;
@end
