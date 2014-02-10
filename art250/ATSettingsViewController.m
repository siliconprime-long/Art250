//
//  ATSettingsViewController.m
//  art250
//
//  Created by Winfred Raguini on 4/1/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATSettingsViewController.h"
#import "ATWebViewController.h"
#import "ATAboutViewController.h"
#import "ATFAQViewController.h"
#import "ATContactUsController.h"
#import "ATReturnPolicyViewController.h"
#import "ATPrivacyPolicyViewController.h"
#import "ATTermsOfUseViewController.h"
#import "ATBlogViewController.h"
#import "ATFacebookManager.h"
#import "ATTwitterManager.h"
#import "ATAppDelegate.h"

typedef enum {
    ATShareSwitchTypeFacebook = 0,
    ATShareSwitchTypeTwitter
} ATShareSwitchType;

@interface ATSettingsViewController ()
- (void)shareSwitchChanged:(id)sender;
@property (nonatomic, strong) UISwitch *facebookShareSwitch;
@property (nonatomic, strong) UISwitch *twitterShareSwitch;

@property (nonatomic, strong) NSArray *tutorialsOptions;
@property (nonatomic, strong) NSArray *purchasingArtOptions;
@property (nonatomic, strong) NSArray *sharingOptions;
@property (nonatomic, strong) NSArray *moreInformationOptions;
@property (nonatomic, strong) NSArray *privacyAndTermsOptions;
@end

@implementation ATSettingsViewController

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
    
    [[ATTwitterManager sharedManager] setDelegate:self];
    [[ATFacebookManager sharedManager] setDelegate:self];
    // Do any additional setup after loading the view from its nib.
    self.tutorialsOptions = [[NSArray alloc] initWithObjects: @"App Tour", nil];
    self.purchasingArtOptions = [[NSArray alloc] initWithObjects:@"Return Policy", @"Frequently Asked Questions", nil];
    self.sharingOptions = [[NSArray alloc] initWithObjects:@"Facebook",@"Twitter", nil];
    self.moreInformationOptions = [[NSArray alloc] initWithObjects:@"About", @"Blog",@"Contact Us", nil];
    self.privacyAndTermsOptions = [[NSArray alloc] initWithObjects:@"Privacy Policy", @"Terms of Use", nil];
    self.preferredContentSize = SETTINGS_POPOVER_SIZE;
    self.title = @"Settings";

    if ([ATAppDelegate systemGreaterThanVersion:@"7.0"]) {
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];

    }

    self.tableView.separatorColor = [[UIColor alloc] initWithRed:183.0f/255.0f green:185.0f/255.0f blue:198.0f/255.0f alpha:1.0f];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}// Default is 1 if not implemented

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Tutorials";
            break;
        case 1:
            return @"Purchasing Art";
            break;
        case 2:
            return @"Sharing";
            break;
        case 3:
            return @"More Information";
            break;
        default:
            return @"Privacy & Terms";
            break;
    }
}// fixed font style. use custom view (UILabel) if you want something different




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.tutorialsOptions count];
            break;
        case 1:
            return [self.purchasingArtOptions count];
            break;
        case 2:
            return [self.sharingOptions count];
            break;
        case 3:
            return [self.moreInformationOptions count];
            break;
        default:
            return [self.privacyAndTermsOptions count];
            break;
    }

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return nil;
    } else {
        return indexPath;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    static NSString *toggleTableIdentifier = @"ToggleTableItem";
    
    NSString *cellIdentifier;
    UITableViewCell *cell;
    if (indexPath.section == 2) {
        cellIdentifier = toggleTableIdentifier;
        cell = [tableView dequeueReusableCellWithIdentifier:toggleTableIdentifier];
    } else {
        cellIdentifier = simpleTableIdentifier;
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
        
    NSArray *settingsArray;
    if (indexPath.section == 0) {
        //Tutorials
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        settingsArray = self.tutorialsOptions;
    } else if (indexPath.section == 1) {
        //Purchasing Art
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        settingsArray = self.purchasingArtOptions;
    } else if (indexPath.section == 2) {
        //Sharing
        UISwitch *shareSwitch;
        if ([ATAppDelegate systemGreaterThanVersion:@"7.0"]) {
            shareSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(380.0f, 5.0f, 0.0f, 0.0f)];
        } else {
            shareSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(280.0f, 5.0f, 0.0f, 0.0f)];
        }

        [shareSwitch addTarget:self action:@selector(shareSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        BOOL isSwitchOn;
        if  (indexPath.row == 0) {
            self.facebookShareSwitch = shareSwitch;
            shareSwitch.tag = ATShareSwitchTypeFacebook;
            isSwitchOn =   [[NSUserDefaults standardUserDefaults] boolForKey:FACEBOOK_ENABLED];
        } else {
            self.twitterShareSwitch = shareSwitch;
            shareSwitch.tag = ATShareSwitchTypeTwitter;
            isSwitchOn = [[NSUserDefaults standardUserDefaults] boolForKey:TWITTER_ENABLED];
        }
//        if (isSwitchOn) {
//            if (indexPath.row == 0) {
//                if ([[ATFacebookManager sharedManager] name] == nil) {
//                    [[ATFacebookManager sharedManager] getUserData];
//                } else {
//                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(155.0f, 0.0f, 200.0f, self.tableView.rowHeight)];
//                    [nameLabel setTextAlignment:NSTextAlignmentRight];
//                    [nameLabel setBackgroundColor:[UIColor clearColor]];
//                    [nameLabel setText:[[ATFacebookManager sharedManager] name]];
//                    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
//                    [cell.contentView addSubview:nameLabel];
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                }
//            } else {
//                [[ATTwitterManager sharedManager] getUserData];
//                cell.detailTextLabel.text = [[ATTwitterManager sharedManager] name];
//            }
//        } else {
            [shareSwitch setOn:isSwitchOn];
            [cell.contentView addSubview:shareSwitch];
//        }
        
        settingsArray = self.sharingOptions;
    } else if (indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        settingsArray = self.moreInformationOptions;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        settingsArray = self.privacyAndTermsOptions;
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
    cell.textLabel.text = [settingsArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,0,self.view.frame.size.width, 30)];
    CGRect labelFrame = headerView.frame;
    if ([ATAppDelegate systemGreaterThanVersion:@"7.0"]) {
        labelFrame.origin.x = 17.0f;
    } else {
        labelFrame.origin.x = 34.0f;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
    label.textColor = [[UIColor alloc] initWithRed:101.f/255.0f green:101.0f/255.0f blue:101.0f/255.0f alpha:1.0f];
    label.backgroundColor = [UIColor clearColor];
    switch (section) {
        case 0:
            label.text = @"How to Navigate";
            break;
        case 1:
            label.text = @"Purchasing Art";
            break;
        case 2:
            label.text = @"Sharing";
            break;
        case 3:
            label.text = @"More Information";
            break;
        default:
            label.text = @"Privacy & Terms";
            break;
    }
    
    [headerView addSubview:label];
    return headerView;
}// custom view for header. will be adjusted to default or specified header height

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self.facebookShareSwitch setOn:!self.facebookShareSwitch.on animated:YES];
        } else {
            [self.twitterShareSwitch setOn:!self.twitterShareSwitch.on animated:YES];
        }
    } else if (indexPath.section == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeAppTourNotification object:nil];
        [[ATTrackingManager sharedManager] trackEvent:FL_FTD_TOUR_VIEWED];
    } else if (indexPath.section == 1) {
        ATWebViewController *webController;
        switch (indexPath.row) {
            case 0:
                webController = [[ATReturnPolicyViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
                [[ATTrackingManager sharedManager] trackEvent:FL_RETURN_POLICY_VIEWED];
                break;
            default:
                webController = [[ATFAQViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
                [[ATTrackingManager sharedManager] trackEvent:FL_FAQ_VIEWED];
                break;
        }
        [self.navigationController pushViewController:webController animated:YES];
    
    } else if (indexPath.section == 3) {
        ATWebViewController *webController;
        switch (indexPath.row) {
            case 0:
                webController = [[ATAboutViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
                [[ATTrackingManager sharedManager] trackEvent:FL_ABOUT_US_VIEWED];
                break;
            case 1:
                webController = [[ATBlogViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
                [[ATTrackingManager sharedManager] trackEvent:FL_BLOG_VIEWED];
                break;
            default:
                webController = [[ATContactUsController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
                [[ATTrackingManager sharedManager] trackEvent:FL_CONTACT_US_VIEWED];
                break;
        }
        [self.navigationController pushViewController:webController animated:YES];
        
    } else {
        ATWebViewController *webController;
        switch (indexPath.row) {
            case 0:
                webController = [[ATPrivacyPolicyViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
                [[ATTrackingManager sharedManager] trackEvent:FL_PRIVACY_POLICY_VIEWED];
                break;
            default:
                webController = [[ATTermsOfUseViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
                [[ATTrackingManager sharedManager] trackEvent:FL_TOS_VIEWED];
                break;
        }
        
        [self.navigationController pushViewController:webController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 60.0f;
    } else {
        return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.0f)];
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, self.tableView.frame.size.width, 30.0f)];
        [versionLabel setTextAlignment:NSTextAlignmentCenter];
        [versionLabel setText:[NSString stringWithFormat:@"ARTtwo50 version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
        [versionLabel setBackgroundColor:[UIColor clearColor]];
        [versionLabel setTextColor:[UIColor darkGrayColor]];
        [footerView addSubview:versionLabel];
        return footerView;
    } else {
        return nil;
    }
}

#pragma mark
#pragma mark Private

- (void)shareSwitchChanged:(id)sender
{
    [[ATFacebookManager sharedManager] setDelegate:self];
    UISwitch *shareSwitch = (UISwitch*)sender;
    switch (shareSwitch.tag) {
        case ATShareSwitchTypeFacebook:
            if (shareSwitch.on) {
                [[ATFacebookManager sharedManager] checkAccount];
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FACEBOOK_ENABLED];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            break;
        default:
            if (shareSwitch.on) {
                [[ATTwitterManager sharedManager] checkAccount];
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TWITTER_ENABLED];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            break;
    }
    
}
- (void)didGetFacebookData
{
    [self.tableView reloadData];
}


- (void)fbAccountDoesExist
{
    //
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FACEBOOK_ENABLED];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)twitterAccountDoesExist
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TWITTER_ENABLED];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)fbAccountDoesNotExist
{
    [self.facebookShareSwitch setOn:NO animated:NO];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FACEBOOK_ENABLED];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)twitterAccountDoesNotExist
{
    [self.twitterShareSwitch setOn:NO animated:NO];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TWITTER_ENABLED];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
