//
//  ATMenuTableViewController.h
//  art250
//
//  Created by Winfred Raguini on 12/1/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATMenuTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, assign) id delegate;
@end
