//
//  ATShareCelebrationViewController.m
//  art250
//
//  Created by Winfred Raguini on 7/30/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATShareCelebrationViewController.h"
#import "Artwork.h"
#import "ATArtManager.h"
#import "ATAppDelegate.h"

#define DEFAULT_TITLE_STRING @"CELEBRATE BEING ORIGINAL"

@interface ATShareCelebrationViewController () {
    NSArray *_artworkImageBtnArray;
}
@property (nonatomic, strong) Artwork *currentArtObject;
@end

@implementation ATShareCelebrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shareMessageString = @"Check out my new art from @ARTtwo50! #BeOriginal";
        _shareTitleString = DEFAULT_TITLE_STRING;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.artworkButtonContainerView removeFromSuperview];
    
    self.emailBtn.enabled = YES;
    
    
    
    // Do any additional setup after loading the view from its nib.
    self.currentArtObject = [self.artworkArray objectAtIndex:0];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"CLOSE" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setRightBarButtonItem:closeButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(cancelButtonSelected:)];
    
    if (self.shouldShowThumbnails) {
        _artworkImageBtnArray = [[NSArray alloc] initWithObjects:self.shareCroppedImageBtn1, self.shareCroppedImageBtn2, self.shareCroppedImageBtn3, self.shareCroppedImageBtn4, nil];
        
        int btnIndex = 0;
        for (ATArtObject *artObject in self.artworkArray) {
            UIButton *button = [_artworkImageBtnArray objectAtIndex:btnIndex];
            [button setBackgroundImage:artObject.croppedImage forState:UIControlStateNormal];
            [button setHidden:NO];
            btnIndex += 1;
        }
        
    }
    

    
    Artwork *firstArtObject = [self.artworkArray objectAtIndex:0];
    self.shareImageView.image = [[ATArtManager sharedManager] hangItImageForArtObject:firstArtObject];
    
    if ([ATAppDelegate systemGreaterThanVersion:@"7.0"]) {
        self.artworkArtonWallCtrl.tintColor = [UIColor whiteColor];
    }
    
    [self.shareTxtView setText:self.shareMessageString];
    [self.shareTitleLabel setText:self.shareTitleString];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)mailSubject
{
    // TODO: need a better way to detect sharing vs purchased
    if ([self.shareTitleString isEqualToString:DEFAULT_TITLE_STRING]) {
        return NSLocalizedString(@"Check out the new piece of art I bought!",nil);
    } else {
        return [super mailSubject];
    }
}

- (void)artworkFramingTypeChanged:(id)sender
{
    [self displayArtworkImageForArtObject:self.currentArtObject];
}

- (void)changeArtworkToShareSelected:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    for (UIButton *shareButton in _artworkImageBtnArray) {
        if (shareButton == button) {
            shareButton.selected = YES;
            self.currentArtObject = [self.artworkArray objectAtIndex:shareButton.tag];
            [self displayArtworkImageForArtObject:self.currentArtObject];
        } else {
            shareButton.selected = NO;
        }
    }
}

- (void)displayArtworkImageForArtObject:(Artwork*)artObject
{
    if (self.artworkArtonWallCtrl.selectedSegmentIndex == 0) {
        self.shareImageView.image = [[ATArtManager sharedManager] hangItImageForArtObject:artObject];
    } else {
        self.shareImageView.image = artObject.artImage;
    }
}

- (void)cancelButtonSelected:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        
    }];
}

- (void)sendEmailMessage
{
    [self sendMailWithImage:self.shareImageView.image];
}

- (void)toggleShareAndEmailButtons
{
    if (self.twitterSwitch.on || self.fbSwitch.on) {
        self.shareBtn.enabled = YES;
    } else {
        self.shareBtn.enabled = NO;
    }
}

- (UIImage*)imageToShare
{
    return self.shareImageView.image;
}

@end
