//
//  ATCollectionManager.m
//  art250
//
//  Created by Winfred Raguini on 9/2/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCollectionManager.h"
#import "ATArtManager.h"


@interface ATCollectionManager ()
- (NSArray*)collectionArray;
@end

@implementation ATCollectionManager
+ (ATCollectionManager*)sharedManager
{
    static ATCollectionManager* _theManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theManager = [[ATCollectionManager alloc] init];
    });
    return _theManager;
}

- (id)init
{
    if (self = [super init]) {
        _buyNowEnabled = NO;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ATArtManager sharedManager] cart] count];
}


- (int)collectionCount
{
    if (self.buyNowEnabled) {
        return [[ATArtManager sharedManager] collectionCount] + [[ATArtManager sharedManager] cartOnlyCount];
    } else {
        return [[ATArtManager sharedManager] collectionCount];
    }
}

- (NSArray*)collection
{
    return [self collectionArray];
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
    
     
    UIButton *artworkButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [artworkButton setImage:[UIImage imageNamed:@"selected_outline.png"] forState:UIControlStateSelected];
    [artworkButton setBackgroundImage:artwork.croppedImage forState:UIControlStateNormal];
    [artworkButton setTag:indexPath.row];
    
    
    CGRect artworkButtonFrame = artworkButton.frame;
    artworkButtonFrame.origin.x = 13.0f;
    artworkButtonFrame.origin.y = 15.0f;
    artworkButtonFrame.size.width = 128.0f;
    artworkButtonFrame.size.height = 97.0f;
    [artworkButton setFrame:artworkButtonFrame];
    [cell.contentView addSubview:artworkButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f * 2 + artworkButton.frame.size.width , 15.0f, 225.0f, 40.0f)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:titlePriceFont];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setNumberOfLines:2];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f * 2 + artworkButton.frame.size.width + titleLabel.frame.size.width + 20.0f , 15.0f, 50.0f, 30.0f)];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    [priceLabel setFont:titlePriceFont];
    [priceLabel setTextColor:[UIColor whiteColor]];
    [priceLabel setNumberOfLines:1];
    [cell.contentView addSubview:priceLabel];
    
    UIFont *dimsFont = [UIFont fontWithName:@"ProximaNova-Light" size:14.0f];
    
    UILabel *dimensionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f * 2 + artworkButton.frame.size.width , titleLabel.frame.origin.y + titleLabel.frame.size.height, 225.0f, 30.0f)];
    [dimensionsLabel setBackgroundColor:[UIColor clearColor]];
    [dimensionsLabel setFont:dimsFont];
    [dimensionsLabel setTextColor:[UIColor whiteColor]];
    [dimensionsLabel setNumberOfLines:1];
    [cell.contentView addSubview:dimensionsLabel];
    
    if (![artwork sold]) {
        UIButton *addRemoveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect addRemoveButtonFrame = addRemoveButton.frame;
        addRemoveButtonFrame.origin.x = priceLabel.frame.origin.x;
        addRemoveButtonFrame.origin.y = 50.0f;
        addRemoveButtonFrame.size.width = 40.0f;
        addRemoveButtonFrame.size.height = 40.0f;
        [addRemoveButton setFrame:addRemoveButtonFrame];
        [addRemoveButton setImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
        [addRemoveButton setImage:[UIImage imageNamed:@"btn_delete.png"] forState:UIControlStateSelected];
        [addRemoveButton setTag:indexPath.row];
        [cell.contentView addSubview:addRemoveButton];
        
        if ([artwork.inCart boolValue]) {
            [artworkButton addTarget:self action:@selector(removeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
            [addRemoveButton addTarget:self action:@selector(removeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [artworkButton addTarget:self action:@selector(addButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
            [addRemoveButton addTarget:self action:@selector(addButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [addRemoveButton setSelected:[artwork.inCart boolValue]];
        [artworkButton setSelected:[artwork.inCart boolValue]];
    } else {
        [artworkButton setUserInteractionEnabled:NO];
        UIImageView *soldImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sold_in_collection.png"]];
        CGRect soldImageFrame = soldImageView.frame;
        soldImageFrame.origin.x = artworkButton.frame.size.width - soldImageFrame.size.width - 5.0f;
        soldImageFrame.origin.y = artworkButton.frame.size.height - soldImageFrame.size.height - 5.0f;
        [soldImageView setFrame:soldImageFrame];
        [artworkButton addSubview:soldImageView];
    }
    
//    cell.backgroundColor = [UIColor whiteColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    

    titleLabel.text = [artwork title];
    priceLabel.text = [NSString stringWithFormat:@"$%1.0f", [artwork.price floatValue]];
    dimensionsLabel.text = [artwork dimensionsString];
    return cell;

}

- (NSArray*)collectionArray
{
    if (self.buyNowEnabled) {
        NSArray *cartOnly = [[ATArtManager sharedManager] cartOnly];
        return [cartOnly arrayByAddingObjectsFromArray:[[ATArtManager sharedManager] collectionArray]];
    } else {
        return [[ATArtManager sharedManager] collectionArray];
    }
}

- (Artwork*)randomArtwork
{
    //NSLog(@"collection number is %d", [[[ATArtManager sharedManager] collectionArray] count]);
    int randomArtworkIndex = arc4random() % [[[ATArtManager sharedManager] collectionArray] count];
    return [[[ATArtManager sharedManager] collectionArray] objectAtIndex:randomArtworkIndex];
}

- (void)removeButtonSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(removeArtwork:)]) {
        UIButton *button = (UIButton*)sender;
        Artwork *artwork = [[[ATArtManager sharedManager] cart] objectAtIndex:button.tag];
        [self.delegate performSelector:@selector(removeArtwork:) withObject:artwork];
    }
}

- (void)addButtonSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(addArtwork:)]) {
        UIButton *button = (UIButton*)sender;
        Artwork *artwork = [[[ATArtManager sharedManager] cart] objectAtIndex:button.tag];
        [self.delegate performSelector:@selector(addArtwork:) withObject:artwork];
    }
}

@end
