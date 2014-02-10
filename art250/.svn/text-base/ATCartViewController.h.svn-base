//
//  ATCartViewController.h
//  art250
//
//  Created by Winfred Raguini on 2/28/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATCustomNavViewController.h"
#import "ATArtworkButtonView.h"
#import "ATArtworkButtonsViewController.h"
#import "ATCheckoutCartViewController.h"

@interface ATCartViewController : ATCheckoutCartViewController <ATArtworkButtonDelegate> {
    NSTimer *checkoutTimer;
}
@property (nonatomic, retain, readwrite) IBOutlet UILabel *itemsInCartLabel;

@property (nonatomic, retain, readwrite) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain, readwrite) IBOutlet UIButton *checkoutButton;
@property (nonatomic, strong) IBOutlet UILabel *subtotalLabel;

@property (nonatomic, strong) ATArtworkButtonView *artworkButton1;
@property (nonatomic, strong) ATArtworkButtonView *artworkButton2;
@property (nonatomic, strong) ATArtworkButtonView *artworkButton3;
@property (nonatomic, strong) ATArtworkButtonView *artworkButton4;

- (IBAction)cancelButtonSelected:(id)sender;
- (IBAction)checkoutButtonSelected:(id)sender;
@end
