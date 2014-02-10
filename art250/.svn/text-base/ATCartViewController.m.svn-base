//
//  ATCartViewController.m
//  art250
//
//  Created by Winfred Raguini on 2/28/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCartViewController.h"
#import "ATShippingInfoViewController.h"
#import "ATArtManager.h"
#import "ATArtworkButtonView.h"
#import "ATArtObject.h"
#import "ATArtistObject.h"
#import "ATCollectionManager.h"

#define CHECKOUT_TIME 600

@interface ATCartViewController ()
- (void)repositionArtworkButtons;
//- (void)descreaseCheckoutTimer:(NSTimer*)timer;
- (UITableViewCell*)createTotalCartRow:(UITableView*)tableView withCell:(UITableViewCell*)cell withIdentifier:(NSString*)identifier;
- (UITableViewCell*)createShippingRow:(UITableView*)tableView withCell:(UITableViewCell*)cell withIdentifier:(NSString*)identifier;
- (UITableViewCell*)createArtworkRow:(UITableView*)tableView withCell:(UITableViewCell*)cell withIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath;
@property (nonatomic, strong) Artwork *bufferedArtwork;
@end

@implementation ATCartViewController

int secondsToCompleteCheckout = CHECKOUT_TIME;

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
    
    if ([[[ATArtManager sharedManager] cart] count] > 0) {
        [self.checkoutButton setEnabled:YES];
    } else {
        [self.checkoutButton setEnabled:NO];
    }
    
    self.itemsInCartLabel.text = @"SUMMARY:";
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"CLOSE" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    
    [[self navigationItem] setRightBarButtonItem:closeButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(closeButtonSelected:)];
    
    
    self.cartTableView.separatorColor = [UIColor clearColor];
    [self.cartTableView setBackgroundColor:[UIColor clearColor]];
    
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"topbar_logo.png"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"ProximaNova-Semibold" size:17.0f], NSFontAttributeName, nil]];
    
    //[[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [self updateItemsInCartLabel];
    
    if ([[[ATArtManager sharedManager] cart] count] == 0) {
        [self hideCheckoutTimer];
        [self.checkoutButton setEnabled:NO];
    } else {
        [[ATArtManager sharedManager] restartCheckoutTimer];
        [self.checkoutButton setEnabled:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.collectionTableView setDelegate:[ATCollectionManager sharedManager]];
    [self.collectionTableView setDataSource:[ATCollectionManager sharedManager]];
    
    [[ATCollectionManager sharedManager] setBuyNowEnabled:YES];
    [[ATCollectionManager sharedManager] setDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[ATCollectionManager sharedManager] setBuyNowEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateItemsInCartLabel
{
    //self.itemsInCollectionLabel.text = [NSString stringWithFormat:@"%d ITEMS IN YOUR CART", [[[ATArtManager sharedManager] cart] count]];
}



#pragma mark
#pragma mark Private

- (IBAction)closeButtonSelected:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidDismissCartViewNotification object:nil];
    }];
}

- (IBAction)checkoutButtonSelected:(id)sender
{
    [[ATTrackingManager sharedManager] trackEvent:FL_ARTWORK_FOR_CART_SELECTED];
    
    ATShippingInfoViewController *billingInfoController = [[ATShippingInfoViewController alloc] initWithNibName:@"ATShippingInfoViewController" bundle:nil];
    [self.navigationController pushViewController:billingInfoController animated:YES];
}

#pragma mark
#pragma mark Private

- (void)repositionArtworkButtons
{
    
}

- (void)addArtwork:(Artwork*)artwork
{
    if (secondsToCompleteCheckout == CHECKOUT_TIME) {
        [[ATArtManager sharedManager] restartCheckoutTimer];
    }
    
    
    [[ATArtManager sharedManager] addArtObjectToCart:artwork];
    [self.cartTableView reloadData];
    [self.collectionTableView reloadData];
    
    [self updateItemsInCartLabel];
    [self.checkoutButton setEnabled:YES];
}

- (void)removeArtwork:(Artwork*)artwork
{
    self.bufferedArtwork = artwork;
    UIAlertView *removeArtworkAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This will be removed from your cart. Forever!" delegate:self cancelButtonTitle:@"Nevermind" otherButtonTitles:@"Yes, I'm sure.", nil];
    [removeArtworkAlert show];
}

- (void)removeArtworkFromCart
{
    [[ATArtManager sharedManager] removeArtObjectFromCart:self.bufferedArtwork];
    [self.cartTableView reloadData];
    [self.collectionTableView reloadData];
    
    [self updateItemsInCartLabel];
    
    if ([[[ATArtManager sharedManager] cart] count] == 0) {
        [[ATArtManager sharedManager] stopTimer];
        
        [self hideCheckoutTimer];
        [self.checkoutButton setEnabled:NO];
    }
    self.bufferedArtwork = nil;
}

#pragma mark
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            self.bufferedArtwork = nil;
            break;
            
        case 1:
            [self removeArtworkFromCart];
            break;
    }
}


@end
