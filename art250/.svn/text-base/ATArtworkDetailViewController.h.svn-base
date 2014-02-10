//
//  ATArtworkDetailViewController.h
//  art250
//
//  Created by Winfred Raguini on 12/24/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Artwork;
@class Artist;
@interface ATArtworkDetailViewController : UIViewController <UIScrollViewDelegate, UIPopoverControllerDelegate>
@property (nonatomic, strong, readwrite) IBOutlet UIImageView* fullScreenImageView;
@property (nonatomic, assign) id delegate;

@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *spinnerView;


//Add to Collection/Buy Now buttons
@property (nonatomic,strong) IBOutlet UIButton *addToCollectionButton;
@property (nonatomic,strong) IBOutlet UIButton *buyNowButton;
@property (nonatomic, strong) IBOutlet UILabel *inOtherCollections;

//Title View
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *artistCityStateLabel;

@property (nonatomic, strong) IBOutlet UITextView *artistStatementView;

@property (nonatomic, strong, readwrite) Artwork *lastArtObject;
@property (nonatomic, strong, readwrite) Artwork *artObject;
@property (nonatomic, strong) Artist *artistObject;

@property (nonatomic, strong, readwrite) IBOutlet UIView *detailView;
//@property (nonatomic, strong, readwrite) UIButton *infoButton;
@property (nonatomic, strong, readwrite) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) IBOutlet UIButton *mainActionButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UISegmentedControl *detailBioControl;

@property (nonatomic, strong) IBOutlet UIView *detailContainerView;
@property (nonatomic, strong) IBOutlet UIView *infoContainerView;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

//Artwork data
@property (nonatomic, strong) IBOutlet UILabel *genreLabel;
@property (nonatomic, strong) IBOutlet UILabel *mediaLabel;

//Dimensions
@property (nonatomic, strong) IBOutlet UILabel *widthLabel;
@property (nonatomic, strong) IBOutlet UILabel *heightLabel;
@property (nonatomic, strong) IBOutlet UILabel *depthLabel;

@property (nonatomic, strong) IBOutlet UITextView *descriptionView;

@property (nonatomic, strong) IBOutlet UIButton *checkoutBtn;
@property (nonatomic, strong) IBOutlet UIButton *heartBtn;
@property (nonatomic, strong) IBOutlet UIButton *addToCartBtn;
- (IBAction)detailBioControlChanged;
- (void)showDetailView;
- (void)showBioView;
- (IBAction)backButtonSelected:(id)sender;
- (IBAction)closeButtonSelected:(id)sender;
- (IBAction)mainActionButtonSelected:(id)sender;
- (IBAction)likeDislikeButtonSelected;
- (IBAction)addToCollectionButtonSelected:(id)sender;
- (IBAction)buyNowButtonSelected:(id)sender;
- (IBAction)removeFromeCollectionButtonSelected:(id)sender;
//Bottom bar actions
- (IBAction)shareButtonSelected:(id)sender;
- (IBAction)heartButtonSelected:(id)sender;
- (IBAction)cartButtonSelected:(id)sender;
- (IBAction)addToCartButtonSelected:(id)sender;

@end
