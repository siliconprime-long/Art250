//
//  ATMenuTableViewController.m
//  art250
//
//  Created by Winfred Raguini on 12/1/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATMenuTableViewController.h"

@interface ATMenuTableViewController ()
@property (nonatomic, strong) UIColor *lightGrayColor;
@end

@implementation ATMenuTableViewController

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
    self.lightGrayColor = [[UIColor alloc] initWithRed:47.0f/255.0f green:47.0f/255.0f blue:47.0f/255.0f alpha:1.0f];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"ProximaNova-Semibold" size:17.0f], NSFontAttributeName, nil]];
    
    //[[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    NSString *cellIdentifier;
    UITableViewCell *cell;
    
    cellIdentifier = simpleTableIdentifier;
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
//    CALayer *topBorder = [CALayer layer];
//    topBorder.frame = CGRectMake(0.0f, 0.0f, cell.frame.size.width, 1.0f);
//    topBorder.backgroundColor = [UIColor whiteColor].CGColor;
//    [cell.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, cell.frame.size.height, cell.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = self.lightGrayColor.CGColor;
    [cell.layer addSublayer:bottomBorder];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    [cell.textLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:17.0f]];
    cell.textLabel.text = [self.menuArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 1.0f)];
    [headerView setBackgroundColor:self.lightGrayColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuArray count];
}

@end
