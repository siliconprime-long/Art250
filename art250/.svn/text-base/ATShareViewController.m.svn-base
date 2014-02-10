//
//  ATShareViewController.m
//  art250
//
//  Created by Winfred Raguini on 2/6/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATShareViewController.h"
#import "ATArtManager.h"
#import "ATTwitterManager.h"
#import "MBProgressHUD.h"
#import "ATFacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ATArtworkButtonView.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import "UIViewController+ATExtensions.h"
#import "ATCollectionManager.h"
#import "ATAppDelegate.h"

#define MAX_MESSAGE_LENGTH 140


#define BRANDING_IMG_HEIGHT 59.0f
#define SHAREABLE_PHOTO_OFFSET 2.0f
#define IMAGE_TAG_OFFSET 10.0f
#define IMAGE_TAG_LENGTH 30.0f


#define ARTWORK_BUTTON_CONTAINER_Y 103.0f

typedef enum {
	ATFacebookSwitch = 0,
	ATTwitterSwitch
} ATSocialSwitch;


@interface ATShareViewController ()
@property (nonatomic, strong) ACAccount *facebookAccount;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, assign) BOOL fbSettingsSaved;
@property (nonatomic, strong) NSArray *twitterAccounts;
@property (nonatomic, strong) CustomKeyboard *customKeyBoard;
- (void)showSelectedPaintings;
- (UIImage*)hangItImageForArtObject:(Artwork*)artObject;
- (UIImage*)createShareableImage;
- (void)imageShareSuccessful;
- (void)imageShareDidFail;
@end



@implementation ATShareViewController
@synthesize numArtworkToShareLbl = _numArtworkToShareLbl;
@synthesize selectedPaintingArray = _selectedPaintingArray;

@synthesize shareBtn = _shareBtn;
@synthesize cancelBtn = _cancelBtn;

@synthesize shareTxtView = _shareTxtView;

@synthesize fbSwitch = _fbSwitch;
@synthesize twitterSwitch = _twitterSwitch;

int _numNetworksTried;
int _numNetworksCompleted;
int _numNetworksSuccessful;
int _numNetworksFailed;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.customKeyBoard = [[CustomKeyboard alloc] init];
    self.customKeyBoard.delegate = self;
    
    [[ATFacebookManager sharedManager] setDelegate:self];
    [[ATTwitterManager sharedManager] setDelegate:self];
    
    [self addObserver:self forKeyPath:@"fbSettingsSaved" options:NSKeyValueObservingOptionNew context:nil];
    
    self.accountStore = [[ACAccountStore alloc] init];
    
    [self.messageContainerView.layer setCornerRadius:5.0f];
    [self.shareTxtView.layer setCornerRadius:5.0f];
    self.shareTxtView.delegate = self;
    self.numArtworkToShareLbl.text = @"0";
    _numNetworksCompleted = 0;
    _numNetworksSuccessful = 0;
    _numNetworksTried = 0;
    
    self.shareBtn.enabled = NO;
    self.emailBtn.enabled = NO;
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"CLOSE" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setRightBarButtonItem:closeButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(cancelButtonSelected:)];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SHKShareDidFinish:) name:@"SHKSendDidFinish" object:nil];
    
    if (![ATAppDelegate systemGreaterThanVersion:@"7.0"]) {
        //Move the share switches to the left a little bit for 6.0 and lower
        CGRect fbSwitchFrame = self.fbSwitch.frame;
        fbSwitchFrame.origin.x = fbSwitchFrame.origin.x - 20.0f;
        [self.fbSwitch setFrame:fbSwitchFrame];
        
        CGRect twitterSwitchFrame = self.twitterSwitch.frame;
        twitterSwitchFrame.origin.x = twitterSwitchFrame.origin.x - 20.0f;
        [self.twitterSwitch setFrame:twitterSwitchFrame];
    }
    
    
    self.fbSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:FACEBOOK_ENABLED];
    self.twitterSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:TWITTER_ENABLED];
    
    
    
    [self updateCharacterCount:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCharacterCount:) name:UITextViewTextDidChangeNotification object:self.shareTxtView];
    
    [self.collectionTableView setDelegate:self];
    [self.collectionTableView setDataSource:self];
    
    self.selectedPaintingArray = [[NSMutableArray alloc] init];
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"topbar_logo.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"ProximaNova-Semibold" size:17.0f], NSFontAttributeName, nil]];
    
    //[[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
}


- (void)viewDidUnload
{
    [self removeObserver:self forKeyPath:@"fbSettingsSaved"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeShareAndInvokePurchaseScreen:) name:kdidInvokeBuyOnShareScreenNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"fbSettingsSaved"]) {
//        if (![[change objectForKey:NSKeyValueChangeNewKey] boolValue]) {
//            
//        }
//    }
//}

#pragma mark
#pragma mark Private

- (void)updateCharacterCount:(NSNotification*)note
{
    NSUInteger charCount = [self.shareTxtView.text length];
    int shareCountNet = MAX_MESSAGE_LENGTH - charCount;
    self.characterCountLbl.text = [NSString stringWithFormat:@"%d", shareCountNet];
    
    if (shareCountNet < 0) {
        self.characterCountLbl.textColor = [UIColor redColor];
    } else {
        self.characterCountLbl.textColor = [UIColor whiteColor];
    }
}

- (void)shareImageWithFacebook:(UIImage*)image text:(NSString*)text
{
    [[ATFacebookManager sharedManager] shareWithImage:self.shareImage text:text];
}

-(void)shareImageWithTwitter:(UIImage*)image text:(NSString*)text account:(ACAccount*)account
{
    
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                [self performSelectorOnMainThread:@selector(successfulPost:) withObject:@"Twitter" waitUntilDone:NO];
                
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                [[ATTrackingManager sharedManager] trackEvent:USER_SHARED_SUCCESS];
                [[ATTrackingManager sharedManager] trackEvent:FL_TWITTER_SHARE_SUCCESS];
            }
            else {
                [self performSelectorOnMainThread:@selector(failedPost:) withObject:@"Twitter" waitUntilDone:NO];
                
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,[NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                [[ATTrackingManager sharedManager] trackEvent:FL_TWITTER_SHARE_FAIL];
            }
        }
        else {
            [self performSelectorOnMainThread:@selector(failedPost:) withObject:@"Twitter" waitUntilDone:NO];
            //NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            
            [self performSelectorOnMainThread:@selector(beginPostingTo:) withObject:@"Twitter" waitUntilDone:NO];
            
            
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status" : text};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            [request setAccount:account];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",[error localizedDescription]);
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
}

- (void)shareImageWithTwitter:(UIImage*)image text:(NSString*)text
{

    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    self.twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
    
    if ([self.twitterAccounts count] > 1) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Which Twitter account would you like to use?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        
        for (ACAccount *account in self.twitterAccounts) {
            [actionSheet addButtonWithTitle:[account username]];
        }
        [actionSheet showInView:self.view];
        
    } else {
        [self shareImageWithTwitter:image text:text account:[self.twitterAccounts lastObject]];
 
    }
}


- (void)beginPostingTo:(NSString*)socialNetwork
{
    //Showing HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [NSString stringWithFormat:@"Posting to %@", socialNetwork];
}

- (void)failedPost:(NSString*)socialNetwork
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = [NSString stringWithFormat:@"Failed posting to %@", socialNetwork];
    [hud show:YES];
    [hud hide:YES afterDelay:2.0f];
    
    if ([socialNetwork isEqualToString:@"Facebook"]) {
        [self performSelector:@selector(postToTwitter) withObject:nil afterDelay:2.0f];
    }
}

- (void)postToTwitter
{
    if (self.twitterSwitch.on) {
        [self shareImageWithTwitter:self.shareImage text:self.shareTxtView.text];
    }
}

- (void)successfulPost:(NSString*)socialNetwork
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [NSString stringWithFormat:@"Successfully posted to %@", socialNetwork];
    [hud show:YES];
    [hud hide:YES afterDelay:2.0f];
    
    if ([socialNetwork isEqualToString:@"Facebook"]) {
        [self performSelector:@selector(postToTwitter) withObject:nil afterDelay:2.0f];
    }
}

- (void)doSomething
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (IBAction)shareButtonSelected:(id)sender
{
    self.shareImage = [self imageToShare];
    
    UIImageWriteToSavedPhotosAlbum(self.shareImage, nil, nil, nil);
    
    sleep(3);

   
//    //Sending tweet
    if (!self.twitterSwitch.on && !self.fbSwitch.on) {
        UIAlertView *chooseNetworkAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Choose at least one network to share to" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [chooseNetworkAlert show];
        return;
    }
//
    if (self.shareImage != nil) {
        if (self.fbSwitch.on) {
            
            [self shareImageWithFacebook:self.shareImage text:self.shareTxtView.text];
            
            //_numNetworksTried += 1;
            //    _shareToFbBtn.enabled = NO; //for not allowing multiple hits
        } else if (self.twitterSwitch.on) {
            [self shareImageWithTwitter:self.shareImage text:self.shareTxtView.text];
        }
        

    } else {
        UIAlertView *chooseImageAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"Choose at least one image to share",nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [chooseImageAlert show];
    }
//    //Sending Facebook status
    
}



- (void)fbSettingsAlert
{
    UIAlertView *fbSettingsAlert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Please log into your Facebook account in the your Settings",nil) delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [fbSettingsAlert show];
}

- (IBAction)cancelButtonSelected:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidDismissShareScreenNotification object:nil];
    }];
}

- (void)didPressArtworkButton:(id)sender
{
    UIButton *paintingBtn = (UIButton*)sender;
    NSNumber *paintingNumber = [NSNumber numberWithInt:paintingBtn.tag];
    if ([self.selectedPaintingArray containsObject:paintingNumber]) {
        [self.selectedPaintingArray removeObject:paintingNumber];
    } else {
        [self.selectedPaintingArray addObject:paintingNumber];
    }
    [self showSelectedPaintings];
    [self toggleShareAndEmailButtons];
}

- (void)toggleShareAndEmailButtons
{
    if ([self.selectedPaintingArray count] > 0) {
        self.emailBtn.enabled = YES;
        if (self.twitterSwitch.on || self.fbSwitch.on) {
            self.shareBtn.enabled = YES;
        }
    } else {
        self.emailBtn.enabled = NO;
        self.shareBtn.enabled = NO;
    }
}

- (IBAction)toggleSwitch:(id)sender
{
    UISwitch *socialSwitch = (UISwitch*)sender;
    if (socialSwitch.on) {
        switch (socialSwitch.tag) {
            case ATFacebookSwitch:
                //NSLog(@"turned on facebook");
                [[ATFacebookManager sharedManager] checkAccount];
                break;
            default:
                //NSLog(@"turned on twitter");
                [[ATTwitterManager sharedManager] checkAccount];
                break;
        }
    } else {
        switch (socialSwitch.tag) {
            case ATFacebookSwitch:
                //NSLog(@"turned off facebook");
                break;
            default:
                //NSLog(@"turned off twitter");
                break;
        }
    }
    [self toggleShareAndEmailButtons];
}

- (UIImage*)imageToShare
{
    return [self createShareableImage];
}

- (void)fbAccountDoesNotExist
{
    [self.fbSwitch setOn:NO animated:NO];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FACEBOOK_ENABLED];
}

- (void)twitterAccountDoesNotExist
{
    [self.twitterSwitch setOn:NO animated:NO];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TWITTER_ENABLED];
}

- (IBAction)emailButtonSelected:(id)sender
{
    [self sendEmailMessage];
}

- (void)sendEmailMessage
{
    [self sendMailWithImage:[self createShareableImage]];
}

- (void)showSelectedPaintings
{
    //NSLog(@"selectedPaintings %@", self.selectedPaintingArray);

    self.numArtworkToShareLbl.text = [NSString stringWithFormat:@"%d", [self.selectedPaintingArray count]];
}

-(void) SHKShareDidFinish: (NSNotification *)notification
{
    //NSLog(@"did finish b");
}


- (UIImage*)hangItImageForArtObject:(Artwork*)artObject
{
    return [[ATArtManager sharedManager] hangItImageForArtObject:artObject];
}

- (void)showHUDMessage:(NSString*)message
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
    //NSLog(@"sending tweet");
}

- (UIImage*)createShareableImage
{
    CGSize itemSize;
    CGRect imageRect1 = CGRectMake(0.0 - SHAREABLE_PHOTO_OFFSET, 0.0 - SHAREABLE_PHOTO_OFFSET + BRANDING_IMG_HEIGHT, 512.0f, 375.0f);
    CGRect imageRect2 = CGRectMake(512.0 + SHAREABLE_PHOTO_OFFSET, 0.0 - SHAREABLE_PHOTO_OFFSET + BRANDING_IMG_HEIGHT, 512.0f, 375.0f);
    CGRect imageRect3 = CGRectMake(0.0 - SHAREABLE_PHOTO_OFFSET, 375.0 + SHAREABLE_PHOTO_OFFSET + BRANDING_IMG_HEIGHT, 512.0f, 375.0f);
    CGRect imageRect4 = CGRectMake(512.0 + SHAREABLE_PHOTO_OFFSET, 375.0 + SHAREABLE_PHOTO_OFFSET + BRANDING_IMG_HEIGHT, 512.0f, 375.0f);
    
    CGRect brandingRect1 = CGRectMake(0.0f, 0.0f, 1024.0f, BRANDING_IMG_HEIGHT);
    
    UIImage *brandingImage = [UIImage imageNamed:@"share_1-2-4_brand_original.png"];
    
    UIImage *newImage;
    
    CGRect imageTagRect1 = CGRectMake(IMAGE_TAG_OFFSET, 375.0f - IMAGE_TAG_LENGTH - IMAGE_TAG_OFFSET + BRANDING_IMG_HEIGHT, IMAGE_TAG_LENGTH, IMAGE_TAG_LENGTH);
    CGRect imageTagRect2 = CGRectMake(512.0 + SHAREABLE_PHOTO_OFFSET + IMAGE_TAG_OFFSET, 375.0f - IMAGE_TAG_LENGTH - IMAGE_TAG_OFFSET + BRANDING_IMG_HEIGHT, IMAGE_TAG_LENGTH, IMAGE_TAG_LENGTH);
    CGRect imageTagRect3 = CGRectMake(IMAGE_TAG_OFFSET, 750.0f - IMAGE_TAG_LENGTH + BRANDING_IMG_HEIGHT + SHAREABLE_PHOTO_OFFSET, IMAGE_TAG_LENGTH, IMAGE_TAG_LENGTH);
    CGRect imageTagRect4 = CGRectMake(512.0 + SHAREABLE_PHOTO_OFFSET + SHAREABLE_PHOTO_OFFSET + IMAGE_TAG_OFFSET, 750.0f - IMAGE_TAG_LENGTH + BRANDING_IMG_HEIGHT + SHAREABLE_PHOTO_OFFSET, IMAGE_TAG_LENGTH, IMAGE_TAG_LENGTH);
    
    
    UIImage *image1Tag = [UIImage imageNamed:@"image1tag.png"];
    UIImage *image2Tag = [UIImage imageNamed:@"image2tag.png"];
    UIImage *image3Tag = [UIImage imageNamed:@"image3tag.png"];
    UIImage *image4Tag = [UIImage imageNamed:@"image4tag.png"];
        

    switch ([self.selectedPaintingArray count]) {
        case 2:
            itemSize = CGSizeMake(1024, 434);
            break;
        case 3:
            itemSize = CGSizeMake(1024, 750.0f + SHAREABLE_PHOTO_OFFSET);
            imageRect1 = CGRectMake(0.0 - SHAREABLE_PHOTO_OFFSET, 0.0 - SHAREABLE_PHOTO_OFFSET, 512.0f, 375.0f);
            imageRect2 = CGRectMake(512.0 + SHAREABLE_PHOTO_OFFSET, 0.0 - SHAREABLE_PHOTO_OFFSET, 512.0f, 375.0f);
            imageRect3 = CGRectMake(0.0 - SHAREABLE_PHOTO_OFFSET, 375.0 + SHAREABLE_PHOTO_OFFSET, 512.0f, 375.0f);
            imageTagRect1 = CGRectMake(IMAGE_TAG_OFFSET, 375.0f - IMAGE_TAG_LENGTH - IMAGE_TAG_OFFSET, IMAGE_TAG_LENGTH, IMAGE_TAG_LENGTH);
            imageTagRect2 = CGRectMake(512.0 + SHAREABLE_PHOTO_OFFSET + IMAGE_TAG_OFFSET, 375.0f - IMAGE_TAG_LENGTH - IMAGE_TAG_OFFSET, IMAGE_TAG_LENGTH, IMAGE_TAG_LENGTH);
            imageTagRect3 = CGRectMake(IMAGE_TAG_OFFSET, 750.0f - IMAGE_TAG_LENGTH + SHAREABLE_PHOTO_OFFSET, IMAGE_TAG_LENGTH, IMAGE_TAG_LENGTH);
            
            break;
        default:
            itemSize = CGSizeMake(1024, 809);
            break;
    }
    
    // Display the action sheet
    
    
    if ([self.selectedPaintingArray count] > 1) {
        
        UIGraphicsBeginImageContextWithOptions(itemSize, YES, [UIScreen mainScreen].scale);
        int imageIterator = 0;
        if ([self.selectedPaintingArray count] == 3) {
            
        } else {
            [brandingImage drawInRect:brandingRect1];
        }
        for (Artwork *artwork in self.selectedPaintingArray) {
            imageIterator = imageIterator + 1;
            UIImage *shareImage = [self hangItImageForArtObject:artwork];
            [self.selectedPaintingToShareArray addObject:shareImage];
            switch (imageIterator) {
                case 1:
                    [shareImage drawInRect:imageRect1];
                    [image1Tag drawInRect:imageTagRect1];
                    break;
                case 2:
                    [shareImage drawInRect:imageRect2];
                    [image2Tag drawInRect:imageTagRect2];
                    break;
                case 3:
                    [shareImage drawInRect:imageRect3];
                    [image3Tag drawInRect:imageTagRect3];
                    break;
                case 4:
                    [shareImage drawInRect:imageRect4];
                    [image4Tag drawInRect:imageTagRect4];
                    break;
                default:
                    break;
            }
        }
        
        UIImage *brandingImage = [UIImage imageNamed:@"share_3_brand_original.png"];
        
        if ([self.selectedPaintingArray count] == 3) {
            CGRect imageRect5 = CGRectMake(512.0 + SHAREABLE_PHOTO_OFFSET, 375.0f + SHAREABLE_PHOTO_OFFSET, 510.0f, 374.0f);
            [brandingImage drawInRect:imageRect5];
        }
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();  // UIImage returned.
        UIGraphicsEndImageContext();
    } else if ([self.selectedPaintingArray count] == 1) {
        UIGraphicsBeginImageContextWithOptions(itemSize, YES, [UIScreen mainScreen].scale);
        [brandingImage drawInRect:brandingRect1];
        UIImage *hangitImage = [self hangItImageForArtObject:[self.selectedPaintingArray objectAtIndex:0]];
        [hangitImage drawInRect:CGRectMake(0.0f, 59.0f, 1024.0f, 725.0f)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();  // UIImage returned.
    }
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)sendMailWithImage:(UIImage*)image
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[self mailSubject]];
        NSArray *toRecipients = nil;//[NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
        [mailer setToRecipients:toRecipients];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
        [mailer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"arttwo50shareImage"];
        NSString *emailBody = self.shareTxtView.text;
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (NSString*)mailSubject
{
    return NSLocalizedString(@"Considering these paintings from ARTtwo50",nil);
}

- (void)imageShareSuccessful
{
    _numNetworksSuccessful += 1;
    [self checkOverallSuccess:nil];
}

- (void)imageShareDidFail:(NSError*)error
{
    _numNetworksFailed += 1;
    [self checkOverallSuccess:error];
}

- (void)checkOverallSuccess:(NSError*)error
{
    if (_numNetworksCompleted == _numNetworksTried) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (_numNetworksSuccessful == _numNetworksTried) {
            MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud2.mode = MBProgressHUDModeText;
            hud2.labelText = NSLocalizedString(@"Shared artwork successfully",nil);
            [hud2 hide:YES afterDelay:1.5];
            [self performSelector:@selector(hideShareScreen) withObject:nil afterDelay:1.5];
        } else {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[error description]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [errorAlertView show];
        }
        
    }
    _numNetworksCompleted = 0;
}

- (void)hideShareScreen
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        
    }];
}

#pragma mark
#pragma mark ATTwitterManagerDelegate
- (void)willSendTweet
{
//    [self performSelectorOnMainThread:@selector(showHUDMessage:) withObject:@"Sending tweet." waitUntilDone:YES];
}


- (void)didSendTweet
{
    _numNetworksCompleted += 1;

    [self performSelectorOnMainThread:@selector(imageShareSuccessful) withObject:nil waitUntilDone:YES];
}

- (void)tweetDidFail:(NSError*)error
{
    _numNetworksCompleted += 1;
    [self performSelectorOnMainThread:@selector(imageShareDidFail:) withObject:error waitUntilDone:YES];
}

#pragma mark
#pragma mark MFMailComposeSheetViewDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            [[ATTrackingManager sharedManager] trackEvent:FL_EMAIL_SHARE];
            [[ATTrackingManager sharedManager] trackEvent:USER_SHARED_SUCCESS];
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            //NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark - FBLoginView delegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // Upon login, transition to the main UI by pushing it onto the navigation stack.
//    SCAppDelegate *appDelegate = (SCAppDelegate *)[UIApplication sharedApplication].delegate;
//    [self.navigationController pushViewController:((UIViewController *)appDelegate.mainViewController) animated:YES];
    //NSLog(@"Show the logged-in view here B!");
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error{
    NSString *alertMessage, *alertTitle;
    
    // Facebook SDK * error handling *
    // Error handling is an important part of providing a good user experience.
    // Since this sample uses the FBLoginView, this delegate will respond to
    // login failures, or other failures that have closed the session (such
    // as a token becoming invalid). Please see the [- postOpenGraphAction:]
    // and [- requestPermissionAndPost] on `SCViewController` for further
    // error handling on other operations.
    
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        //NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        //NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // Facebook SDK * login flow *
    // It is important to always handle session closure because it can happen
    // externally; for example, if the current session's access token becomes
    // invalid. For this sample, we simply pop back to the landing page.
//    SCAppDelegate *appDelegate = (SCAppDelegate *)[UIApplication sharedApplication].delegate;
//    if (appDelegate.isNavigating) {
//        // The delay is for the edge case where a session is immediately closed after
//        // logging in and our navigation controller is still animating a push.
//        [self performSelector:@selector(logOut) withObject:nil afterDelay:.5];
//    } else {
//        [self logOut];
//    }
    //NSLog(@"Should do some sort of logOut UI thing here");
}

- (void)logOut {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //NSLog(@"performing logOut");
}

#pragma mark
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        [self shareImageWithTwitter:self.shareImage text:self.shareTxtView.text account:[self.twitterAccounts objectAtIndex:buttonIndex]];
    }
}

UITextView *_activeTextView;

#pragma mark
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _activeTextView = textView;
    [textView setInputAccessoryView:[self.customKeyBoard getToolbarWithDone]];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

}

#pragma mark
#pragma mark CustomKeyboardDelegate

-(void)doneClicked:(NSUInteger)selectedId{
    [_activeTextView resignFirstResponder];
}


#pragma mark
#pragma mark UITableViewDelegate


#pragma mark
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ATArtManager sharedManager] collectionCount];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146.0f;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *addressCellIdentifier = @"simpleTableItem";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    Artwork *artwork = [[self collectionArray] objectAtIndex:indexPath.row];
    
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"row_bg.png"]]];
    } else {
        [cell setBackgroundView:nil];
    }
    
    UIFont *titlePriceFont = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f];
    
    
    UIButton *artworkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [artworkButton setImage:[UIImage imageNamed:@"selected_outline.png"] forState:UIControlStateSelected];
    [artworkButton setBackgroundImage:artwork.croppedImage forState:UIControlStateNormal];
    [artworkButton setTag:indexPath.row];
    
    
    CGRect artworkButtonFrame = artworkButton.frame;
    artworkButtonFrame.origin.x = 13.0f;
    artworkButtonFrame.origin.y = 15.0f;
    artworkButtonFrame.size.width = 128.0f;
    artworkButtonFrame.size.height = 97.0f;
    [artworkButton setFrame:artworkButtonFrame];
    [cell.contentView addSubview:artworkButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f * 2 + artworkButton.frame.size.width , 15.0f, 225.0f, 40.0f)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:titlePriceFont];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setNumberOfLines:2];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f * 2 + artworkButton.frame.size.width + titleLabel.frame.size.width + 20.0f , 15.0f, 50.0f, 30.0f)];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    [priceLabel setFont:titlePriceFont];
    [priceLabel setTextColor:[UIColor whiteColor]];
    [priceLabel setNumberOfLines:1];
    [cell.contentView addSubview:priceLabel];
    
    UIFont *dimsFont = [UIFont fontWithName:@"ProximaNova-Light" size:14.0f];
    
    UILabel *dimensionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f * 2 + artworkButton.frame.size.width , titleLabel.frame.origin.y + titleLabel.frame.size.height, 225.0f, 30.0f)];
    [dimensionsLabel setBackgroundColor:[UIColor clearColor]];
    [dimensionsLabel setFont:dimsFont];
    [dimensionsLabel setTextColor:[UIColor whiteColor]];
    [dimensionsLabel setNumberOfLines:1];
    [cell.contentView addSubview:dimensionsLabel];
    
    UIButton *addRemoveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect addRemoveButtonFrame = addRemoveButton.frame;
    addRemoveButtonFrame.origin.x = priceLabel.frame.origin.x;
    addRemoveButtonFrame.origin.y = 50.0f;
    addRemoveButtonFrame.size.width = 40.0f;
    addRemoveButtonFrame.size.height = 40.0f;
    [addRemoveButton setFrame:addRemoveButtonFrame];
    [addRemoveButton setImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
    [addRemoveButton setImage:[UIImage imageNamed:@"btn_delete.png"] forState:UIControlStateSelected];
    [addRemoveButton setTag:indexPath.row];
    [cell.contentView addSubview:addRemoveButton];
    
    cell.backgroundColor = [UIColor clearColor];
    
    
    if ([self.selectedPaintingArray containsObject:artwork]) {
        [artworkButton addTarget:self action:@selector(removeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [artworkButton setSelected:YES];
        [addRemoveButton addTarget:self action:@selector(removeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [addRemoveButton setSelected:YES];
    } else {
        [artworkButton addTarget:self action:@selector(addButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [artworkButton setSelected:NO];
        [addRemoveButton addTarget:self action:@selector(addButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [addRemoveButton setSelected:NO];
    }
    
    
    
    titleLabel.text = [artwork title];
    priceLabel.text = [NSString stringWithFormat:@"$%1.0f", [artwork.price floatValue]];
    dimensionsLabel.text = [artwork dimensionsString];
    return cell;
    
}

- (NSArray*)collectionArray
{
    return [[ATArtManager sharedManager] collectionArray];
}

- (void)removeButtonSelected:(id)sender
{
    UIButton *button = (UIButton*)sender;
    Artwork *artwork = [[self collectionArray] objectAtIndex:button.tag];
    [self.selectedPaintingArray removeObject:artwork];
    
    [self.collectionTableView reloadData];
    [self showSelectedPaintings];
    [self toggleShareAndEmailButtons];
}

- (void)addButtonSelected:(id)sender
{
    if ([self.selectedPaintingArray count] >= 4) {
        UIAlertView *selectedArtMaxAlert = [[UIAlertView alloc] initWithTitle:@"Sorry." message:NSLocalizedString(@"CANNOT_SHARE_MORE_THAN_4_PIECES",nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [selectedArtMaxAlert show];
    } else {
        UIButton *button = (UIButton*)sender;
        Artwork *artwork = [[self collectionArray] objectAtIndex:button.tag];
        [self.selectedPaintingArray addObject:artwork];
        
        [self.collectionTableView reloadData];
        [self showSelectedPaintings];
        [self toggleShareAndEmailButtons];
    }
    
}



- (void)closeShareAndInvokePurchaseScreen:(NSNotification*)note
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokePurchaseScreenNotification object:nil];
    }];
}




@end
