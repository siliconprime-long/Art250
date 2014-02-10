//
//  ATShippingInfoViewController.h
//  art250
//
//  Created by Winfred Raguini on 3/20/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATCountryPickerController.h"
#import "ATStatePickerController.h"
#import "ATCheckoutTimerViewController.h"
#import "CustomKeyboard.h"

@interface ATShippingInfoViewController : ATCheckoutTimerViewController <ATStatePickerDelegate, CustomKeyboardDelegate>
@property (nonatomic, retain, readwrite) ATCountryPickerController *countryPickerController;
@property (nonatomic, retain, readwrite) ATStatePickerController *statePickerController;
@property (nonatomic, retain, readwrite) UIPopoverController *pickerPopoverController;
@property (nonatomic, retain, readwrite) IBOutlet UIScrollView *scrollView;


//Shipping info
@property (nonatomic, retain, readwrite) IBOutlet UITextField *shippingInfoFirstNameField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *shippingInfoLastNameField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *shippingInfoAddress1Field;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *shippingInfoAddress2Field;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *shippingInfoCityField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *shippingInfoZipField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *shippingInfoCountryField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *shippingInfoStateField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *shippingInfoEmailAddressField;
@property (nonatomic, retain, readwrite) IBOutlet UITextField *shippingInfoPhoneNumberField;

@property (nonatomic, retain, readwrite) IBOutlet UITextField *confirmEmailField;


//Button
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

- (IBAction)countryPickerButtonSelected:(id)sender;
- (IBAction)sameAsBillingButtonSelected:(id)sender;
- (IBAction)submitPaymentButtonSelected:(id)sender;
- (IBAction)cancelButtonSelected:(id)sender;
- (IBAction)scanCard:(id)sender;
@end

