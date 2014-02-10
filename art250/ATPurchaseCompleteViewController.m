//
//  ATPurchaseCompleteViewController.m
//  art250
//
//  Created by Winfred Raguini on 3/22/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATPurchaseCompleteViewController.h"
#import "ATArtObject.h"
#import "ATArtManager.h"
#import "ATPaymentManager.h"
#import "BPHTTPClient.h"
#import "BPCustomer.h"
#import "AFHTTPRequestOperation.h"
#import "BPCard.h"
#import "MBProgressHUD.h"
#import "ATAPIClient.h"
#import "ATUserManager.h"
#import "ATCartManager.h"
#import "ATAppDelegate.h"
#import "NSString+ATExtensions.h"

#define TABLEVIEW_TOP_OFFSET 20.0f

#define TITLE_TAG 1
#define ARTIST_NAME_TAG 2
#define DIMS_TAG 3
#define PRICE_TAG 4
#define SHIPPING_TOTAL_TAG 5
#define TOTAL_PRICE_TAG 6
#define FREE_TAG 6

#define APPEARS_ON_STATEMENT_PARAM @"appears_on_statement_as"
#define AMOUNT_PARAM @"amount"
#define DESCRIPTION_PARAM @"description"
#define SOURCE_PARAM @"source_uri"

#define BP_RESP_DEBIT_URI @"uri"

#define TEST @"test"
typedef enum {
    ATCartRowTypeSubTotal = 0,
    ATCartRowTypeGiftCard,
    ATCartRowTypeShipping
} ATCartRowType;

@interface ATPurchaseCompleteViewController ()

@end

@implementation ATPurchaseCompleteViewController

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
    
    CGRect collectionContainerViewFrame = self.collectionContainerView.frame;
    if ([ATAppDelegate systemGreaterThanVersion:@"7.0"])
    {
        collectionContainerViewFrame.origin.y = 145.0f;
    } else {
        collectionContainerViewFrame.origin.y = 105.0f;
    }
    
    collectionContainerViewFrame.size.height = 397.0f;
    [self.collectionContainerView setFrame:collectionContainerViewFrame];
    
    CGRect collectionTableViewFrame = self.collectionTableView.frame;
    collectionTableViewFrame.size.height = 350.0f;
    [self.collectionTableView setFrame:collectionTableViewFrame];
    
    self.itemsInCollectionLabel.text = [NSString stringWithFormat:@"%d ITEMS IN YOUR CART", [[[ATArtManager sharedManager] cart] count]];
    
    [self updateShippingAndBillingInfo];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.collectionTableView setDelegate:[ATCartManager sharedManager]];
    [self.collectionTableView setDataSource:[ATCartManager sharedManager]];
    
    if ([[ATPaymentManager sharedManager] currentBPCard] == nil) {
        [self.chargedToView setHidden:YES];
    } else {
        [self.chargedToView setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureButtonViews
{
    //Do Nothing
}


- (IBAction)cancelButtonSelected:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)completePurchaseButtonSelected:(id)selector
{
    [[ATTrackingManager sharedManager] trackEvent:FL_PURCHASE_COMPLETION_BUTTON_SELECTED];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = NSLocalizedString(@"Purchasing your new art...",nil);
    
    BPCard *card = [[ATPaymentManager sharedManager] currentBPCard];
    //NSLog(@"card %@", card);
    //NSLog(@"cardURI %@", card.URI);
    
    
    NSMutableArray *artworkArray = [[NSMutableArray alloc] init];
    for (Artwork *artObject in [[ATArtManager sharedManager] cart]) {
        NSDictionary *artPurchase = [[NSDictionary alloc] initWithObjectsAndKeys:artObject.artworkID, @"artwork_id", nil];
        [artworkArray addObject:artPurchase];
    }
    
    NSMutableDictionary *purchaseInfoDictOld = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[ATPaymentManager sharedManager] shippingAddress1], @"address_1", [[ATPaymentManager sharedManager] shippingAddress2], @"address_2", [[ATPaymentManager sharedManager] shippingCity], @"city",
        [[ATPaymentManager sharedManager] shippingState],@"state", [[ATPaymentManager sharedManager] shippingZipCode], @"postal_code", [[ATPaymentManager sharedManager] shippingFullName], @"name", [[ATPaymentManager sharedManager] shippingEmailAddress], @"email", [[ATPaymentManager sharedManager] shippingPhoneNumber], @"phone",
        artworkArray, @"purchase_items_attributes", nil];

    NSMutableDictionary *purchaseInfoDict = [[NSMutableDictionary alloc] init];
//    [NSNumber numberWithFloat:[[ATArtManager sharedManager] cartTotal]], @"total_price",
    if ([NSNumber numberWithFloat:[[ATArtManager sharedManager] cartTotal]] > 0) {
        [purchaseInfoDict setObject:[NSNumber numberWithFloat:[[ATArtManager sharedManager] cartTotal]] forKey:@"total_price"];
    }
    if (![NSString stringIsNilOrEmpty:[[ATPaymentManager sharedManager] shippingAddress1]]) {
        [purchaseInfoDict setObject:[[ATPaymentManager sharedManager] shippingAddress1] forKey:@"address_1"];
    }
    if (![NSString stringIsNilOrEmpty:[[ATPaymentManager sharedManager] shippingAddress2]]) {
        [purchaseInfoDict setObject:[[ATPaymentManager sharedManager] shippingAddress2] forKey:@"address_2"];
    }
    if (![NSString stringIsNilOrEmpty:[[ATPaymentManager sharedManager] shippingCity]]) {
        [purchaseInfoDict setObject:[[ATPaymentManager sharedManager] shippingCity] forKey:@"city"];
    }
    if (![NSString stringIsNilOrEmpty:[[ATPaymentManager sharedManager] shippingState]]) {
        [purchaseInfoDict setObject:[[ATPaymentManager sharedManager] shippingState] forKey:@"state"];
    }
    if (![NSString stringIsNilOrEmpty:[[ATPaymentManager sharedManager] shippingZipCode]]) {
        [purchaseInfoDict setObject:[[ATPaymentManager sharedManager] shippingZipCode] forKey:@"postal_code"];
    }
    if (![NSString stringIsNilOrEmpty:[[ATPaymentManager sharedManager] shippingFullName]]) {
        [purchaseInfoDict setObject:[[ATPaymentManager sharedManager] shippingFullName] forKey:@"name"];
    }
    if (![NSString stringIsNilOrEmpty:[[ATPaymentManager sharedManager] shippingEmailAddress]]) {
        [purchaseInfoDict setObject:[[ATPaymentManager sharedManager] shippingEmailAddress] forKey:@"email"];
    }
    if (![NSString stringIsNilOrEmpty:[[ATPaymentManager sharedManager] shippingPhoneNumber]]) {
        [purchaseInfoDict setObject:[[ATPaymentManager sharedManager] shippingPhoneNumber] forKey:@"phone"];
    }
    if ([artworkArray count] > 0) {
        [purchaseInfoDict setObject:artworkArray forKey:@"purchase_items_attributes"];
    }

    NSMutableDictionary *purchaseDict = [[NSMutableDictionary alloc] init];

    BPCustomer *currentCustomer = [[ATPaymentManager sharedManager] currentBPCustomer];
    if ([[ATUserManager sharedManager] hasBuyerAccount]) {
        [purchaseDict setValue:[[ATUserManager sharedManager] buyerAccountId] forKey:@"buyer_id"];
    } else {
        NSDictionary *buyerInfoDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[ATPaymentManager sharedManager] billingEmailAddress],@"email", [[ATPaymentManager sharedManager] billingFullName], @"name", [[ATPaymentManager sharedManager] billingPhoneNumber], @"phone", [currentCustomer URI], @"bp_customer_uri", nil];
        [purchaseDict setValue:buyerInfoDict forKey:@"buyer"];
    }

    if ([[ATPaymentManager sharedManager] discount] > 0) {
        [purchaseInfoDict setValue:[NSNumber numberWithInt:[[ATPaymentManager sharedManager] promoCodeId]] forKey:@"promo_code_id"];
    }

    if ([[ATPaymentManager sharedManager] giftCardRemainingValue] > 0) {
        [purchaseInfoDict setObject:[[ATPaymentManager sharedManager] giftCardId] forKey:@"gift_card_id"];
    }


    [purchaseDict setValue:purchaseInfoDict forKey:@"purchase"];

    //params = { :buyer_id => 1,
    //  :promo_code => CODE,
    //
    //  :purchase => {
    //  :total_price => 500, :bp_debit_uri => 'adsfads/debits/askdjfk', :address_1 => '946 Geary St.',
    // :address_2 => 'Apt 3', :city => 'San Francisco', :state => 'Ca', :postal_code => '23464', :purchase_items_attributes => [
    //  {:artwork_id => 100},
    //  {:artwork_id => 101}
    //  ]
    //}}
    // or
    // params = {:buyer => {:email => 'win.raguini@gmail.com', :bp_account_uri => 'dfajafd/accounts/ksdafjlj' :name => 'Ben Franklin', :phone => '7574953248'},
    // :purchase => { ... }
    //}

    [[ATAPIClient sharedClient] postPath:@"purchases.json" parameters:purchaseDict success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSDictionary *purchaseDict = JSON;
        //NSLog(@"json is %@",purchaseDict);
        //Now save the buyer id
        NSDictionary *purchaseInfoDict  = [purchaseDict objectForKey:@"purchase"];
        NSDictionary *buyerInfoDict = [purchaseInfoDict objectForKey:@"buyer"];
        NSString *purchaseState = [purchaseInfoDict objectForKey:@"purchase_state"];
        
        if ([purchaseState isEqualToString:@"billed"]) {
            [[ATUserManager sharedManager] setBuyerAccountId:[NSNumber numberWithInt:[[buyerInfoDict objectForKey:@"id"] intValue]]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = NSLocalizedString(@"Congratulations your artwork has been purchased.",nil);
            [self performSelector:@selector(didCompletePurchaseSuccessfully) withObject:nil afterDelay:3.0f];
        } else {
            [self performSelectorOnMainThread:@selector(purchaseDidFail) withObject:nil waitUntilDone:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"operation: %@ error: %@", operation, [error localizedDescription]);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Dang!" message:@"Something bad happened. Please try again or call 415-228-0842 with the app in-hand." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [errorAlert show];
    }];
   
    
}

- (void)didCompletePurchaseSuccessfully
{
    [[ATTrackingManager sharedManager] trackEvent:FL_PURCHASE_COMPLETED];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //Reset shipping and billing info
    [[ATPaymentManager sharedManager] clearBillingInfo];
    [[ATPaymentManager sharedManager] clearShippingInfo];
    
    //Reset discount
    [[ATPaymentManager sharedManager] setDiscount:0.0f];
    
    //Reset Gift Card
    [[ATPaymentManager sharedManager] setGiftCardId:nil];
    [[ATPaymentManager sharedManager] setGiftCardRemainingValue:0.0f];
    
    //
    [[ATPaymentManager sharedManager] setCurrentBPCard:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidDismissCompletedPurchaseScreenNotification object:nil];
}

- (void)purchaseDidFail
{
    UIAlertView *purchaseFail = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"Our system had a brain fART. Please try again later or call us at 415-228-0842." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [purchaseFail show];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark
#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[[ATArtManager sharedManager] cart] count] > 0) {
        int cartLineItems = [[[ATArtManager sharedManager] cart] count] + 1;
        
        if ([[ATPaymentManager sharedManager] discount] > 0) {
            cartLineItems++;
        }
        
        if ([[ATPaymentManager sharedManager] giftCardRemainingValue] > 0) {
            cartLineItems++;
        }
        
        return cartLineItems;
    } else {
        return 0;
    }
}

#pragma mark
#pragma mark Private

- (IBAction)exitToMainScreenButtonSelected:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateShippingAndBillingInfo
{
    self.shippingNameLabel.text = [[ATPaymentManager sharedManager] shippingFullName];
    self.shippingAddress1Label.text = [[ATPaymentManager sharedManager] shippingAddress1];
    self.shippingAddress2Label.text = [[ATPaymentManager sharedManager] shippingAddress2];
    self.shippingCityStateZipLabel.text = [NSString stringWithFormat:@"%@, %@ %@", [[ATPaymentManager sharedManager] shippingCity], [[ATPaymentManager sharedManager] shippingState], [[ATPaymentManager sharedManager] shippingZipCode]];
    
    //NSLog(@"billing name is %@", [[ATPaymentManager sharedManager] billingFullName]);
    //NSLog(@"billing address is %@", [[ATPaymentManager sharedManager] billingAddress1]);
    
    self.billingNameLabel.text = [[ATPaymentManager sharedManager] billingFullName];
    self.billingAddress1Label.text = [[ATPaymentManager sharedManager] billingAddress1];
    self.billingAddress2Label.text = [[ATPaymentManager sharedManager] billingAddress2];
    self.billingCityStateZipLabel.text = [NSString stringWithFormat:@"%@, %@ %@", [[ATPaymentManager sharedManager] billingCity], [[ATPaymentManager sharedManager] billingState], [[ATPaymentManager sharedManager] billingZipCode]];
    
    self.contactEmailLabel.text = [[ATPaymentManager sharedManager] shippingEmailAddress];
    self.contactPhoneNumberLabel.text = [[ATPaymentManager sharedManager] shippingPhoneNumber];
    
    self.creditCardImgView.image = [[ATPaymentManager sharedManager] currentCreditCardImage];
    BPCard *currCard = [[ATPaymentManager sharedManager] currentBPCard];
    self.creditCardEndingInLabel.text = [NSString stringWithFormat:@"ending in *%@", currCard.lastFourDigits];
}

@end
