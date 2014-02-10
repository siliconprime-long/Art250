//
//  ATArtistsDirectoryViewController.h
//  art250
//
//  Created by Winfred Raguini on 11/29/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMenuTableViewController.h"

@interface ATArtistsDirectoryViewController : UIViewController
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end
