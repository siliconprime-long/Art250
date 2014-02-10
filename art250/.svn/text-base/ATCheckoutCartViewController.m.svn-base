//
//  ATCheckoutCartViewController.m
//  art250
//
//  Created by Winfred Raguini on 7/3/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCheckoutCartViewController.h"
#import "ATArtManager.h"
#import "ATPaymentManager.h"
#import "ATCollectionManager.h"

#define TABLEVIEW_TOP_OFFSET 20.0f
#define REMOVE_LABEL_HEIGHT 20.0f

#define ARTWORK_ROW_LENGTH 335.0f
#define CART_ROW_HEIGHT 50.0f
#define PRICE_ROW_LENGTH 70.0f
#define SHIPPING_TOTAL_ROW_LENGTH 200.0f
#define SHIPPING_TOTAL_ROW_HEIGHT 30.0f

#define TITLE_TAG 1
#define ARTIST_NAME_TAG 2
#define DIMS_TAG 3
#define PRICE_TAG 4
#define SHIPPING_TOTAL_TAG 5
#define TOTAL_PRICE_TAG 6
#define FREE_TAG 6

@interface ATCheckoutCartViewController ()
@property (nonatomic, assign) BOOL giftCardLinePrinted;
@property (nonatomic, assign) BOOL promoCodeLinePrinted;
@end

@implementation ATCheckoutCartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _displayCollection = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    if (self.displayCollection) {
        self.collectionContainerView = [[UIView alloc] initWithFrame:CGRectMake(34.0f, 150.0f, 469.0f, 442.0f)];
        [self.collectionContainerView setBackgroundColor:[UIColor clearColor]];
        
        self.itemsInCollectionLabel = [[ATCustomProximaNovaSBoldLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 469.0f, 29.0f)];
        [self.itemsInCollectionLabel setBackgroundColor:[UIColor clearColor]];
        self.itemsInCollectionLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:18.0f];
        [self.itemsInCollectionLabel setTextColor:[UIColor whiteColor]];
        
        self.collectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 39.0f, 469.0f, 413.0f) style:UITableViewStylePlain];
        [self.collectionTableView setBackgroundColor:[UIColor clearColor]];
        [self.collectionTableView setSeparatorColor:[UIColor clearColor]];
        [self.collectionTableView setRowHeight:126.0f];
        [self.collectionContainerView addSubview:self.itemsInCollectionLabel];
        [self.collectionContainerView addSubview:self.collectionTableView];
        [self.view addSubview:self.collectionContainerView];
    }
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[[ATArtManager sharedManager] cart] count] > 0) {
        return [[[ATArtManager sharedManager] cart] count] + 1;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"simpleTableItem";
    static NSString *totalTableIdentifier = @"totalTableIdentifier";
    static NSString *discountTableIdentifier = @"discountTableIdentifier";
    
    UITableViewCell *cell;
    
    if (indexPath.row >= [[[ATArtManager sharedManager] cart] count]) {
        NSString *valueString;
        NSString *titleString;
        NSString *identifier;
        
        if (indexPath.row == [[[ATArtManager sharedManager] cart] count] + 2) {
            identifier = discountTableIdentifier;
            titleString = @"TOTAL";
            valueString = [NSString stringWithFormat:@"$%.2f",[[ATArtManager sharedManager] cartTotal] - [[ATPaymentManager sharedManager] discount] - [[ATPaymentManager sharedManager] effectiveGiftCardValue]];
        } else if (indexPath.row == [[[ATArtManager sharedManager] cart] count] + 1) {
            //Total or Gift card
            if ([[ATPaymentManager sharedManager] giftCardRemainingValue] > 0 && !self.giftCardLinePrinted) {
                self.giftCardLinePrinted = YES;
                identifier = discountTableIdentifier;
                titleString = @"Gift Card";
                valueString = [NSString stringWithFormat:@"- $%.2f",[[ATPaymentManager sharedManager] effectiveGiftCardValue]];
            } else {
                identifier = discountTableIdentifier;
                titleString = @"TOTAL";
                valueString = [NSString stringWithFormat:@"$%.2f",[[ATArtManager sharedManager] cartTotal] - [[ATPaymentManager sharedManager] discount] - [[ATPaymentManager sharedManager] effectiveGiftCardValue] ];
            }
        } else if (indexPath.row == [[[ATArtManager sharedManager] cart] count]) {
            //Total or Gift Card or Promo code
            if ([[ATPaymentManager sharedManager] discount] > 0) {
                identifier = discountTableIdentifier;
                titleString = @"Promo Discount";
                valueString = [NSString stringWithFormat:@"- $%.2f",[[ATPaymentManager sharedManager] discount]];
            } else if ([[ATPaymentManager sharedManager] giftCardRemainingValue] > 0) {
                self.giftCardLinePrinted = YES;
                identifier = discountTableIdentifier;
                titleString = @"Gift Card";
                valueString = [NSString stringWithFormat:@"- $%.2f",[[ATPaymentManager sharedManager] effectiveGiftCardValue]];
            } else {
                identifier = discountTableIdentifier;
                titleString = @"TOTAL";
                valueString = [NSString stringWithFormat:@"$%.2f",[[ATArtManager sharedManager] cartTotal] - [[ATPaymentManager sharedManager] discount] - [[ATPaymentManager sharedManager] effectiveGiftCardValue] ];
            }
        }
        
        return [self createLineItem:tableView withCell:cell withIdentifier:totalTableIdentifier withTitle:titleString withValue:valueString];
    } else {
        return [self createArtworkRow:tableView withCell:cell withIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    }
}

- (UIFont*)fontForRowText
{
    return [UIFont fontWithName:@"ProximaNova-Semibold" size:16.0f];
}

#pragma mark
#pragma mark Private

- (UITableViewCell*)createLineItem:(UITableView*)tableView withCell:(UITableViewCell*)cell withIdentifier:(NSString*)identifier withTitle:(NSString*)titleString withValue:(NSString*)valueString
{
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    UILabel *totalLabel, *totalPriceLabel;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        
        UIView *totalContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.cartTableView.frame.size.width, 30.0f)];
        totalContainerView.backgroundColor = [UIColor clearColor];
        
        
        totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 300.0f, 30.0f)];
        totalLabel.tag = SHIPPING_TOTAL_TAG;
        totalLabel.backgroundColor = [UIColor clearColor];
        totalLabel.textAlignment = NSTextAlignmentRight;
        totalLabel.textColor = [UIColor whiteColor];
        totalLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:18.0f];
        [cell.contentView addSubview:totalLabel];
//        
        totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalLabel.frame.size.width, 5.0f, self.cartTableView.frame.size.width - totalLabel.frame.size.width, 30.0f)];
        totalPriceLabel.tag = TOTAL_PRICE_TAG;
        totalPriceLabel.backgroundColor = [UIColor clearColor];
        totalPriceLabel.textAlignment = NSTextAlignmentRight;
        totalPriceLabel.textColor = [UIColor whiteColor];
        totalPriceLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:18.0f];
        [cell.contentView addSubview:totalPriceLabel];
        
        //[cell.contentView addSubview:totalContainerView];
    } else {
        totalLabel = (UILabel*)[cell.contentView viewWithTag:SHIPPING_TOTAL_TAG];
        totalPriceLabel = (UILabel*)[cell.contentView viewWithTag:TOTAL_PRICE_TAG];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    totalLabel.text = titleString;
    totalPriceLabel.text = valueString;
    
    return cell;
}

- (UITableViewCell*)createArtworkRow:(UITableView*)tableView withCell:(UITableViewCell*)cell withIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath
{
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    UILabel *artworkTitleLabel, *priceLabel;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *artworkView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ARTWORK_ROW_LENGTH, tableView.rowHeight)];
        
        artworkTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, ARTWORK_ROW_LENGTH, 30.0f)];
        artworkTitleLabel.tag = TITLE_TAG;
        artworkTitleLabel.backgroundColor = [UIColor clearColor];
        artworkTitleLabel.textColor = [UIColor whiteColor];
        artworkTitleLabel.font = [self fontForRowText];
        artworkTitleLabel.numberOfLines = 0;
        artworkTitleLabel.textAlignment = NSTextAlignmentLeft;
        [artworkView addSubview:artworkTitleLabel];
        
        
        [cell.contentView addSubview:artworkView];
 
        
        UIView *priceContainerView = [[UIView alloc] initWithFrame:CGRectMake(ARTWORK_ROW_LENGTH + 20.0f, 0.0f, PRICE_ROW_LENGTH, tableView.rowHeight)];
        priceContainerView.backgroundColor = [UIColor clearColor];
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, PRICE_ROW_LENGTH, 30.0f)];
        priceLabel.tag = PRICE_TAG;
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.font = [self fontForRowText];
        priceLabel.textAlignment = NSTextAlignmentRight;
        [priceContainerView addSubview:priceLabel];
        
        [cell.contentView addSubview:priceContainerView];
        
        UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.cartTableView.rowHeight - 1.0f, self.cartTableView.frame.size.width, 1.0f)];
        horizontalView.backgroundColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        [cell.contentView addSubview:horizontalView];
    } else {
        artworkTitleLabel = (UILabel *)[cell.contentView viewWithTag:TITLE_TAG];
        priceLabel = (UILabel*)[cell.contentView viewWithTag:PRICE_TAG];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    Artwork *artwork = [[[ATArtManager sharedManager] cart] objectAtIndex:indexPath.row];
    
    artworkTitleLabel.text = artwork.title;
    //NSLog(@"artworkTitle %@", artObject.title);
    priceLabel.text = [NSString stringWithFormat:@"$%.2f", [artwork.price floatValue]];
    
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [[[ATArtManager sharedManager] cart] count]) {
        CGSize maximumSize = CGSizeMake(ARTWORK_ROW_LENGTH, 999999999);
        ATArtObject *artObject = [[[ATArtManager sharedManager] cart] objectAtIndex:indexPath.row];
        CGRect boundingRect = [artObject.title boundingRectWithSize:maximumSize
                                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                 attributes:@{ NSFontAttributeName : [self fontForRowText] }
                                                    context:nil];
        return MAX(boundingRect.size.height, CART_ROW_HEIGHT);
    } else {
        return SHIPPING_TOTAL_ROW_HEIGHT;
    }
}

@end
