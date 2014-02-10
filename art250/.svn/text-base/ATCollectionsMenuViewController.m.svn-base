//
//  ATCollectionsMenuViewController.m
//  art250
//
//  Created by Winfred Raguini on 12/1/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCollectionsMenuViewController.h"
#import <QuartzCore/CALayer.h>
#import "ATArtManager.h"

@interface ATCollectionsMenuViewController ()

@end

@implementation ATCollectionsMenuViewController

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
    
    [self.navigationItem setTitle:@"Collections"];
    
    self.menuArray = [NSArray arrayWithObjects:@"Recommendations", @"Favorites", nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [[ATArtManager sharedManager] loadRecommendations];
            break;
            
        case 1:
            [[ATArtManager sharedManager] loadFavorites];
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeHideMenuDockNotification object:nil];
    
}

@end
