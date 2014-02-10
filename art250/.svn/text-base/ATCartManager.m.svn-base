//
//  ATCartManager.m
//  art250
//
//  Created by Winfred Raguini on 9/3/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//


#import "ATCartManager.h"
#import "ATArtManager.h"

@implementation ATCartManager
+ (ATCartManager*)sharedManager
{
    static ATCartManager *_theManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theManager = [[ATCartManager alloc] init];
    });
    return _theManager;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ATArtManager sharedManager] cart] count];
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *addressCellIdentifier = @"simpleTableItem";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    Artwork *artwork = [[[ATArtManager sharedManager] cart] objectAtIndex:indexPath.row];
    
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"row_bg.png"]]];
    } else {
        [cell setBackgroundView:nil];
    }
    
    UIFont *titlePriceFont = [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f];
    
    
    UIImageView *artworkImageView = [[UIImageView alloc] initWithImage:artwork.croppedImage];
    CGRect artworkImageViewFrame = artworkImageView.frame;
    artworkImageViewFrame.origin.x = 13.0f;
    artworkImageViewFrame.origin.y = 15.0f;
    [artworkImageView setFrame:artworkImageViewFrame];
    [cell.contentView addSubview:artworkImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f * 2 + artworkImageView.frame.size.width , 15.0f, 225.0f, 40.0f)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:titlePriceFont];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setNumberOfLines:2];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f * 2 + artworkImageView.frame.size.width + titleLabel.frame.size.width + 20.0f , 15.0f, 50.0f, 30.0f)];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    [priceLabel setFont:titlePriceFont];
    [priceLabel setTextColor:[UIColor whiteColor]];
    [priceLabel setNumberOfLines:1];
    [cell.contentView addSubview:priceLabel];
    
    UIFont *dimsFont = [UIFont fontWithName:@"ProximaNova-Light" size:14.0f];
    
    UILabel *dimensionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f * 2 + artworkImageView.frame.size.width , titleLabel.frame.origin.y + titleLabel.frame.size.height, 225.0f, 30.0f)];
    [dimensionsLabel setBackgroundColor:[UIColor clearColor]];
    [dimensionsLabel setFont:dimsFont];
    [dimensionsLabel setTextColor:[UIColor whiteColor]];
    [dimensionsLabel setNumberOfLines:1];
    [cell.contentView addSubview:dimensionsLabel];
    
    
//    cell.backgroundColor = [UIColor whiteColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    titleLabel.text = [artwork title];
    priceLabel.text = [NSString stringWithFormat:@"$%1.0f", [artwork.price floatValue]];
    dimensionsLabel.text = [artwork dimensionsString];
    return cell;
    
}


@end
