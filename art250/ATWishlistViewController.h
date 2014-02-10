//
//  ATWishlistViewController.h
//  art250
//
//  Created by Winfred Raguini on 8/24/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATWalkThroughViewController.h"

@class ATCameraOverlayViewController;
@class ATImagePickerViewController;
@class ATSettingsNavigationController;
@interface ATWishlistViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate, ATWalkThroughViewControllerDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

//Menu dock buttons
@property (nonatomic, strong) IBOutlet UIButton *menuBtn;
@property (nonatomic, strong) IBOutlet UIButton *collectionsBtn;
@property (nonatomic, strong) IBOutlet UIButton *heartBtn;
@property (nonatomic, strong) IBOutlet UIButton *shareBtn;
@property (nonatomic, strong) IBOutlet UIButton *checkoutBtn;
@property (nonatomic, strong) IBOutlet UIButton *addToCartBtn;




@property (nonatomic, strong) IBOutlet UILabel *artworkTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *artistLocationLabel;
@property (nonatomic, strong) IBOutlet UILabel *portfolioLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *freeShippingLabel;


@property (nonatomic, strong) IBOutlet UIView *infoDockView;


@property (nonatomic, strong) IBOutlet UIButton *photoButton;
@property (nonatomic, strong) ATSettingsNavigationController *settingsNavController;
@property (nonatomic, strong) UIPopoverController *pickerPopoverController;
@property (nonatomic, strong) UIPopoverController *photoPickerPopoverController;
@property (nonatomic, strong) ATCameraOverlayViewController *cameraOverlayController;
@property (nonatomic, readwrite, weak) id delegate;
@property (nonatomic, readonly, strong) UITableView *tableView;
@property (nonatomic, assign, readonly) BOOL showingCollection;
- (void)takePhoto:(BOOL)animated;
- (void)disablePhotoButton;
- (void)enablePhotoButton;
- (IBAction)infoCollectionButtonSelected:(id)sender;
- (IBAction)menuButtonSelected:(id)sender;
- (void)displayCollectionDock;
- (IBAction)changeSizeButtonSelected:(id)sender;
- (IBAction)newPhotoButtonSelected:(id)sender;
- (IBAction)importPhotoButtonSelected:(id)sender;
- (IBAction)samplePhotoButtonSelected:(id)sender;
- (IBAction)tutorialButtonSelected:(id)sender;
- (IBAction)settingsButtonSelected:(id)sender;
- (IBAction)feedbackButtonSelected:(id)sender;
- (IBAction)heartButtonSelected:(id)sender;
- (IBAction)addToCartButtonSelected:(id)sender;
- (IBAction)signInButtonSelected:(id)sender;
- (IBAction)menuDockBuyButtonSelected:(id)sender;
- (IBAction)buyNowButtonSelected:(id)sender;
- (IBAction)collectionsChooserButtonSelected:(id)sender;
@end
