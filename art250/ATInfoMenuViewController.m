//
//  ATInfoMenuViewController.m
//  art250
//
//  Created by Winfred Raguini on 12/1/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATInfoMenuViewController.h"
#import "ATHowToNavigateViewController.h"
#import "ATAboutViewController.h"
#import "ATBlogViewController.h"
#import "ATContactUsController.h"
#import "ATFAQViewController.h"
#import "ATReturnPolicyViewController.h"
#import "ATPrivacyPolicyViewController.h"
#import "ATTermsOfUseViewController.h"


@interface ATInfoMenuViewController ()

@end

@implementation ATInfoMenuViewController

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
    
    [self.navigationItem setTitle:@"Info"];
    
    self.menuArray = [NSArray arrayWithObjects:@"How to Navigate", @"About", @"Blog", @"Contact Us", @"Frequently Asked Questions", @"Return Policy", @"Privacy Policy", @"Terms of Use", nil];
    

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *nextController;
    switch (indexPath.row) {
        case 0:
            nextController = [[ATHowToNavigateViewController alloc] initWithNibName:@"ATHowToNavigateViewController" bundle:nil];
            break;
            
        case 1:
            nextController = [[ATAboutViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
            break;
            
        case 2:
            nextController = [[ATBlogViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
            break;
        case 3:
            nextController = [[ATContactUsController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
            break;
        case 4:
            nextController = [[ATFAQViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
            break;
        case 5:
            nextController = [[ATReturnPolicyViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
            break;
        case 6:
            nextController = [[ATPrivacyPolicyViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
            break;
        case 7:
            nextController = [[ATTermsOfUseViewController alloc] initWithNibName:@"ATWebViewController" bundle:nil];
            break;
    }
    //[[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeHideMenuDockNotification object:nil];
    
    [self.navigationController pushViewController:nextController animated:YES];
}

#pragma mark
#pragma mark Public

- (void)showHowToNavigateController
{
    UIViewController *howToNavController = [[ATHowToNavigateViewController alloc] initWithNibName:@"ATHowToNavigateViewController" bundle:nil];
    [self.navigationController pushViewController:howToNavController animated:NO];
}



@end
