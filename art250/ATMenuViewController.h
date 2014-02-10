//
//  ATMenuViewController.h
//  art250
//
//  Created by Winfred Raguini on 11/25/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATMenuViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) id delegate;

@property (nonatomic, strong) IBOutlet UIView *fakeSlideOutView;

//Login stuff
@property (nonatomic, strong) IBOutlet UIImageView *loggedInImageView;
@property (nonatomic, strong) IBOutlet UILabel *loginLabel;
@property (nonatomic, strong) IBOutlet UIButton *logoutButton;


@property (nonatomic, strong) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) IBOutlet UIButton *newsFeedBtn;
@property (nonatomic, strong) IBOutlet UIButton *collectionsBtn;
@property (nonatomic, strong) IBOutlet UIButton *favoritesBtn;
@property (nonatomic, strong) IBOutlet UIButton *artistsBtn;
@property (nonatomic, strong) IBOutlet UIButton *priceBtn;
@property (nonatomic, strong) IBOutlet UIButton *roomBtn;
@property (nonatomic, strong) IBOutlet UIButton *infoBtn;

//Blurred background image
@property (nonatomic, strong) UIImage *blurredBackgroundImage;
- (IBAction)menuButtonSelected:(id)sender;
- (void)hideSlideOutView;
- (void)showFakeSlideOutView;
- (void)didShowSlideOutView;
- (void)didHideSlideOutView;
- (void)showFirstTimeUserNavMenu;
- (void)showArtistDirectory;
@end
