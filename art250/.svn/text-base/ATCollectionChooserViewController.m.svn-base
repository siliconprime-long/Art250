//
//  ATCollectionChooserViewController.m
//  art250
//
//  Created by Winfred Raguini on 11/21/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCollectionChooserViewController.h"

@interface ATCollectionChooserViewController ()
@property (nonatomic, strong) NSArray *collectionsArray;
@end

@implementation ATCollectionChooserViewController

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
    self.collectionsArray = [[NSArray alloc] initWithObjects:@"Recommendations", @"Favorites", @"Artists", nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGSize)preferredContentSize
{
    return CGSizeMake(210.0f, 145.0f);
}

#pragma mark
#pragma mark UITableViewDataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.collectionsArray count];
}



// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    NSString *cellIdentifier;
    UITableViewCell *cell;

    cellIdentifier = simpleTableIdentifier;
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    

    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
    cell.textLabel.text = [self.collectionsArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

#pragma mark
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:indexPath.row], @"collectionChoice", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseCollectionFromPickerNotification object:nil userInfo:userInfo];
}

@end
