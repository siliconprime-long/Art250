//
//  ATPaymentInfoViewController.h
//  art250
//
//  Created by Winfred Raguini on 5/2/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATArtworkButtonsViewController.h"
#import "CardIO.h"
#import "ATStatePickerController.h"
#import "ATCreditCardExpiryPickerViewController.h"
#import "CustomKeyboard.h"

@interface ATPaymentInfoViewController : ATArtworkButtonsViewController <CardIOPaymentViewControllerDelegate, UIPopoverControllerDelegate, UITextFieldDelegate, CustomKeyboardDelegate>
@property (nonatomic, retain, readwrite) ATStatePickerController *statePickerController;
@property (nonatomic, retain, readwrite) UIPopoverController *pickerPopoverController;

@property (nonatomic, strong) IBOutlet UITableView *addressTableViewChooser;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) ATCreditCardExpiryPickerViewController *creditCardExpiryController;

//Shipping summary
@property (nonatomic, strong) IBOutlet UILabel *shippingAddress1Label;
@property (nonatomic, strong) IBOutlet UILabel *shippingAddress2Label;
@property (nonatomic, strong) IBOutlet UILabel *shippingCityStateZipLabel;

//Card info
@property (nonatomic, strong) IBOutlet UITextField *cardNameOnCard;
@property (nonatomic, strong) IBOutlet UITextField *cardNumber;
@property (nonatomic, strong) IBOutlet UITextField *cardExpiry;
@property (nonatomic, strong) IBOutlet UITextField *cardCVV;

//Promo Code
@property (nonatomic, strong) IBOutlet UITextField *promoCodeField;

//Gift Card
@property (nonatomic, strong) IBOutlet UITextField *giftCardField;

//Billing info
//Billing info
@property (nonatomic, retain, readwrite) IBOutlet UITextField *billingInfoFirstNameField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *billingInfoLastNameField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *billingInfoAddress1Field;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *billingInfoAddress2Field;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *billingInfoCityField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *billingInfoZipField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *billingInfoCountryField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *billingInfoStateField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *billingInfoPhoneNumberField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *billingInfoEmailField;

//Confirm email
@property (nonatomic, retain, readwrite) IBOutlet UITextField *confirmEmailField;
@property (nonatomic, retain, readwrite) IBOutlet UILabel *confirmEmailLabel;

@property (nonatomic, assign) int expiryMonth;
@property (nonatomic, assign) int expiryYear;

@property (nonatomic, strong) IBOutlet UIView *creditCardView;
@property (nonatomic, strong) IBOutlet UIView *bottomCheckoutView;

- (IBAction)reviewPurchaseButtonSelected:(id)selector;
- (IBAction)expiryButtonSelected:(id)sender;
@end
