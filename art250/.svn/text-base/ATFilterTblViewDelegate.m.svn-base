//
//  ATFilterTblViewDelegate.m
//  art250
//
//  Created by Winfred Raguini on 9/10/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATFilterTblViewDelegate.h"
#import "ATFilterButtonView.h"

#define kReuseIdentifier @"kReuseIdentifier"

@implementation ATFilterTblViewDelegate

- (id)init
{
    if (self = [super init]) {
        selectedRowsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([selectedRowsArray containsObject:[NSNumber numberWithInt:indexPath.row]]) {
        [selectedRowsArray removeObject:[NSNumber numberWithInt:indexPath.row]];
    } else {
        [selectedRowsArray addObject:[NSNumber numberWithInt:indexPath.row]];
    }
    [tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0f;
}

#pragma mark
#pragma mark UITableDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
    }
    
    if ([[cell.contentView subviews] count] > 0) {
        for (UIView *subView in [cell.contentView subviews]) {
            [subView removeFromSuperview];
        }
    }
    
    ATFilterButtonView *filterButtonView = [[ATFilterButtonView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 140.0f, 140.0f)];
    filterButtonView.buttonImage = [UIImage imageNamed:@"blueSearchFilterBtn.png"];
    
    
    if ([selectedRowsArray containsObject:[NSNumber numberWithInt:indexPath.row]]) {
        [filterButtonView setHighlighted:YES];
    } else {
        [filterButtonView setHighlighted:NO];
    }
    
    [filterButtonView setNeedsLayout];
    
    [cell.contentView addSubview:filterButtonView];
    
    //    cell.imageView.image = [UIImage imageNamed:img];
    //    cell.textLabel.text = text;
    cell.textLabel.textColor = [UIColor colorWithRed:(196/255.0) green:(204/255.0) blue:(218/255.0) alpha:1.0f];
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


@end
