//
//  ATShareViewController.h
//  art250
//
//  Created by Winfred Raguini on 2/6/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATArtObject.h"
#import "ATTwitterManager.h"
#import <MessageUI/MessageUI.h>
#import "ATCustomNavViewController.h"
#import "ATArtworkButtonView.h"
#import "ATArtworkButtonsViewController.h"
#import "CustomKeyboard.h"
#import "ATCheckoutCartViewController.h"

@class FBLoginView;
@interface ATShareViewController : ATCheckoutCartViewController <ATTwitterManagerDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, CustomKeyboardDelegate, UITextViewDelegate>
@property (nonatomic, retain) NSMutableArray *selectedPaintingToShareArray;
@property (nonatomic, retain) NSMutableArray *selectedPaintingArray;
@property (nonatomic, strong) IBOutlet UIView *messageContainerView;

@property (nonatomic, retain) IBOutlet UILabel *numArtworkToShareLbl;
@property (nonatomic, strong) IBOutlet UILabel *characterCountLbl;

@property (nonatomic, retain) IBOutlet UIButton *shareBtn;
@property (nonatomic, retain) IBOutlet UIButton *emailBtn;
@property (nonatomic, retain) IBOutlet UIButton *cancelBtn;

@property (nonatomic, retain) IBOutlet UITextView *shareTxtView;

@property (nonatomic, retain) IBOutlet UISwitch *fbSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *twitterSwitch;

@property (nonatomic, retain) Artwork *artObject1;
@property (nonatomic, retain) Artwork *artObject2;
@property (nonatomic, retain) Artwork *artObject3;
@property (nonatomic, retain) Artwork *artObject4;

@property (nonatomic, retain) UIImage *shareImage;

- (IBAction)shareButtonSelected:(id)sender;
- (IBAction)cancelButtonSelected:(id)sender;
- (IBAction)toggleSwitch:(id)sender;
- (IBAction)emailButtonSelected:(id)sender;
- (void)sendMailWithImage:(UIImage*)image;

- (NSString *)mailSubject;
@end
