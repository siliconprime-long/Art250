//
//  ATPaymentInfoViewController.m
//  art250
//
//  Created by Winfred Raguini on 5/2/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATPaymentInfoViewController.h"
#import "ATPurchaseCompleteViewController.h"
#import "ATPaymentManager.h"
#import "ATCreditCardExpiryPickerViewController.h"
#import "MBProgressHUD.h"
#import "Balanced.h"
#import "NSString+ATExtensions.h"
#import "BPCustomer.h"
#import "ATTextField.h"
#import "ATAPIClient.h"
#import "ATArtManager.h"

typedef enum {
    ATStateButtonNone = 0,
    ATStateButtonBillingType,
    ATStateBUttonShippingType
} ATStateButtonType;

#define BOTTOM_CHECKOUT_BAR_HEIGHT 104.0f

@interface ATPaymentInfoViewController ()
@property (nonatomic, strong) CustomKeyboard *customKeyboard;
- (void)reviewPurchaseButtonSelected:(id)selector;
- (void)didValidateCreditCardSuccessfully:(NSNotification*)note;
- (void)didValidateCreditCardFailed:(NSNotification*)note;
- (void)validateCreditCard;
- (BOOL)validatePaymentInfo;
- (void)duplicateShippingInfo;
@end

@implementation ATPaymentInfoViewController

int _selectedRow;
ATTextField *activeField;

ATStateButtonType stateButtonType = ATStateButtonNone;

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
    
    self.customKeyboard = [[CustomKeyboard alloc] init];
    self.customKeyboard.delegate = self;
    
    _selectedRow = 0;
    self.creditCardView.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didValidateCreditCardSuccessfully:)
                                                 name:kDidValidateCreditCardSuccessfully object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didValidateCreditCardFailed:)
                                                 name:kDidValidateCreditCardFailed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creditCardAssociationFailed:) name:kCreditCardAssociationFailedNotification object:nil];
    
    
    [self updateShippingLabel];
    [self duplicateShippingInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifyEmailConfirmation:) name:UITextFieldTextDidChangeNotification object:self.billingInfoEmailField];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.scrollView addGestureRecognizer:tapRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateCustomerSuccessfully:) name:kDidCreateNewCustomerSuccessfullyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailCreatingCustomer:) name:kDidCreateNewCustomerFailedNotification object:nil];
    
    [[ATPaymentManager sharedManager] setGiftCardRemainingValue:0.0f];
    [[ATPaymentManager sharedManager] setGiftCardId:nil];
    
    [[ATPaymentManager sharedManager] setCurrentBPCard:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [self addObserver:self forKeyPath:@"expiryMonth" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"expiryYear" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"expiryMonth"];
    [self removeObserver:self forKeyPath:@"expiryYear"];
}

- (void)configureButtonViews
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark
#pragma mark Private
- (void)tapDetected:(UITapGestureRecognizer*)recognizer
{
    //[activeField resignFirstResponder];
    NSIndexPath *shippingIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *shippingAddressCell = [self.addressTableViewChooser cellForRowAtIndexPath:shippingIndexPath];
    
    NSIndexPath *billingIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *billingAddressCell = [self.addressTableViewChooser cellForRowAtIndexPath:billingIndexPath];
    
    CGPoint tapPoint = [recognizer locationInView:self.addressTableViewChooser];
    
    if (CGRectContainsPoint(shippingAddressCell.frame, tapPoint)) {
        [self.addressTableViewChooser selectRowAtIndexPath:shippingIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.addressTableViewChooser didSelectRowAtIndexPath:shippingIndexPath];
    } else if (CGRectContainsPoint(billingAddressCell.frame, tapPoint)) {
        [self.addressTableViewChooser selectRowAtIndexPath:billingIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.addressTableViewChooser didSelectRowAtIndexPath:billingIndexPath];
    } else {
        [activeField resignFirstResponder];
    }
}


- (void)didValidateCreditCardSuccessfully:(NSNotification*)note
{
    [self pushCompletePurchaseScreen];
}

- (void)pushCompletePurchaseScreen
{
    [[ATTrackingManager sharedManager] trackEvent:FL_CREDIT_CARD_VALIDATED];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    ATPurchaseCompleteViewController *purchaseCompleteController = [[ATPurchaseCompleteViewController alloc] initWithNibName:@"ATPurchaseCompleteViewController" bundle:nil];
    [self.navigationController pushViewController:purchaseCompleteController animated:YES];
}

- (void)didValidateCreditCardFailed:(NSNotification*)note
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Looks like something's wrong with your credit card.";
    [hud hide:YES afterDelay:3.0f];
}


- (void)creditCardAssociationFailed:(NSNotification*)note
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    UIAlertView *ccAssociationFailed = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:NSLocalizedString(@"Your credit card could not be processed. Please try again or call us at 415-228-0842.",nil) delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [ccAssociationFailed show];

}

- (BOOL)validatePaymentInfo
{
    //Card info
    NSMutableArray *errorsArray = [[NSMutableArray alloc] init];

    
    if ([self.billingInfoFirstNameField.text length] == 0)
    {
        [errorsArray addObject:NSLocalizedString(@"* First name is required.", nil)];
    }
    
    if ([self.billingInfoEmailField.text length] == 0) {
        [errorsArray addObject:NSLocalizedString(@"* Email is required.", nil)];
    } else {
        if (![NSString isValidEmail:self.billingInfoEmailField.text]) {
            UIAlertView *shippingValidationAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid email", nil) message:NSLocalizedString(@"Use a valid email so I can email you cool stuff",nil) delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [shippingValidationAlert show];
            return NO;
        } else if (![self.billingInfoEmailField.text isEqualToString:self.confirmEmailField.text]) {
            UIAlertView *shippingValidationAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm email", nil) message:NSLocalizedString(@"Your emails should match.",nil) delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [shippingValidationAlert show];
            return NO;
        }
    }
    
    if ([self.billingInfoPhoneNumberField.text length] == 0) {
        [errorsArray addObject:NSLocalizedString(@"* Phone number is required", nil)];
    } 
    
    if ([self.billingInfoLastNameField.text length] == 0) {
        [errorsArray addObject:NSLocalizedString(@"* Last name is required.", nil)];
    }
    
    if ([self.billingInfoAddress1Field.text length] == 0) {
        [errorsArray addObject:NSLocalizedString(@"* Address is required.", nil)];
    }
    
    if ([self.billingInfoCityField.text length] == 0) {
        [errorsArray addObject:NSLocalizedString(@"* City is required.", nil)];
    }
    
    if ([self.billingInfoZipField.text length] == 0) {
        [errorsArray addObject:NSLocalizedString(@"* Zip code is required.", nil)];
    } 

    if ([self.billingInfoStateField.text length] == 0) {
        [errorsArray addObject:NSLocalizedString(@"* State is required.", nil)];
    } 
    
    
    if ([errorsArray count] > 0) {
        [self displayErrorMessageForErrors:errorsArray];
        return NO;
    } else {
        [[ATPaymentManager sharedManager] setBillingFirstName:self.billingInfoFirstNameField.text];
        [[ATPaymentManager sharedManager] setBillingEmailAddress:self.billingInfoEmailField.text];
        [[ATPaymentManager sharedManager] setBillingPhoneNumber:self.billingInfoPhoneNumberField.text];
        [[ATPaymentManager sharedManager] setBillingLastName:self.billingInfoLastNameField.text];
        [[ATPaymentManager sharedManager] setBillingAddress1:self.billingInfoAddress1Field.text];
        [[ATPaymentManager sharedManager] setBillingAddress2:self.billingInfoAddress2Field.text];
        [[ATPaymentManager sharedManager] setBillingCity:self.billingInfoCityField.text];
        [[ATPaymentManager sharedManager] setBillingZipCode:self.billingInfoZipField.text];
        [[ATPaymentManager sharedManager] setBillingState:self.billingInfoStateField.text];
        return YES;
    }
}

- (void)displayErrorMessageForErrors:(NSArray*)errorsArray
{
    NSString* errorString = @"";
    for (NSString* error in errorsArray) {
        //NSLog(@"error: %@", error);
        errorString = [errorString stringByAppendingFormat:@"%@ \n", error];
        //NSLog(@"errorString is %@",errorString);
    }
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing required fields",nil) message:errorString delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [errorAlertView show];
}


- (void)validateGiftCard
{
    
//    var giftCardData = {
//    code: $form_payment.find('.gift-card').val()
//    };
//    var gift_card_request;
//    gift_card_request = $.ajax({
//    type: 'GET',
//    beforeSend: function(xhr){
//        //append a loading message here too
//        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
//    },
//    contentType: "application/json; charset=utf-8",
//    url: "/gift_cards/show.json",
//    dataType: 'json',
//    data: giftCardData
//    });
//    
//
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(@"Validating gift card...",nil);
    [hud show:YES];
    
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.giftCardField.text, @"code", nil];
    
    [[ATAPIClient sharedClient] getPath:@"gift_cards/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON){
        NSDictionary *giftCardDict = [JSON objectForKey:@"gift_card"];
        //Now save the buyer id

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        
        if ([giftCardDict objectForKey:@"remaining_value"]) {
            
            if ([[giftCardDict objectForKey:@"remaining_value"] floatValue] > 0.00) {
                
                NSString *giftCardId = [giftCardDict objectForKey:@"id"];
                CGFloat remainingValue = [[giftCardDict objectForKey:@"remaining_value"] floatValue];
                
                [[ATPaymentManager sharedManager] setGiftCardRemainingValue:remainingValue];
                [[ATPaymentManager sharedManager] setGiftCardId:giftCardId];
                
                hud.labelText = NSLocalizedString(@"Gift card accepted.",nil);
                
                //Now if remaining value is equal to or more than the price of the cart - promo code then
                //go straight to last screen
                //Otherwise,
                //validate the credit card
                
                CGFloat subTotal = [[ATArtManager sharedManager] cartTotal] - [[ATPaymentManager sharedManager] discount];
                
                if (remainingValue >= subTotal) {
                    //Go to last screen
                    
                    
                    //Set up a customer
                    if ([[ATPaymentManager sharedManager] bpCustomerExistsForEmail:self.billingInfoEmailField.text]) {
                        //Try and match the credit card with one that already exists
                        //Check to see if the current card has already been used
                        //If the card is one of the ones saved locally - if it is then just
                        BPCustomer *customer = [BPCustomer retrieveCustomerForEmail:self.billingInfoEmailField.text];
                        
                        [[ATPaymentManager sharedManager] setCurrentBPCustomer:customer];

                        [self pushCompletePurchaseScreen];
                        //If the card has NOT been used befre
                    } else {
                        NSString *name = [NSString stringWithFormat:@"%@ %@", self.billingInfoFirstNameField.text, self.billingInfoLastNameField.text];
                        
                        [BPCustomer addNewCustomerWithEmailAddress:self.billingInfoEmailField.text name:name];
                        
                        
                    }

                    
                } else {
                    //Otherwise, validate the credit card
                    NSLog(@"Going to validateCreditCard now");
                    [self validateCreditCard];
                }
                
            } else {
                hud.labelText = NSLocalizedString(@"Gift card has no remaining balance.",nil);
            }
            
        } else {
            
            hud.labelText = NSLocalizedString(@"Could not find your gift card.",nil);
            
            [self validateCreditCard];
        }
        [hud hide:YES afterDelay:2.0f];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.labelText = NSLocalizedString(@"Could not process your gift card.",nil);
        [hud hide:YES afterDelay:2.0f];
    }];
    
    
}

- (void)validatePromoCode
{
    //This will give you the discount based on the promo code
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(@"Validating promo code...",nil);
    [hud show:YES];
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.promoCodeField.text, @"code", [NSNumber numberWithFloat:[[ATArtManager sharedManager] cartTotal]], @"price", nil];
    
    [[ATAPIClient sharedClient] getPath:@"promo_codes/query.json" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON){
        NSDictionary *promoCodeDict = JSON;
        //NSLog(@"json is %@",purchaseDict);
        //Now save the buyer id
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        
        
        NSDictionary *promoInfoDict;
        
        if ([promoCodeDict objectForKey:@"promo_code"] == nil) {
            hud.labelText = NSLocalizedString(@"Promo code not accepted.",nil);
            
        } else {
            
            promoInfoDict = [promoCodeDict objectForKey:@"promo_code"];
            hud.labelText = NSLocalizedString(@"Promo code accepted.",nil);
            
            NSDictionary *promoInfoDict = [promoCodeDict objectForKey:@"promo_code"];
            
            CGFloat discount = [[promoInfoDict objectForKey:@"discount"] floatValue];
            int promoCodeId = [[promoInfoDict objectForKey:@"id"] intValue];
            
            [[ATPaymentManager sharedManager] setDiscount:discount];
            [[ATPaymentManager sharedManager] setPromoCodeId:promoCodeId];
            
            if ([self.giftCardField.text length] > 0) {
                [self validateGiftCard];
            } else {
                [self validateCreditCard];
            }
            
        }
        [hud hide:YES afterDelay:2.0f];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.labelText = NSLocalizedString(@"Dang. Something happened. Dunno what.",nil);
        [hud hide:YES afterDelay:2.0f];
    }];

}



- (void)validateCreditCard
{
    NSMutableArray *errorsArray = [[NSMutableArray alloc] init];
    
    if ([self.cardNameOnCard.text length] == 0) {
        [errorsArray addObject:NSLocalizedString(@"* Name on card is required.", nil)];
    }
    if ([self.cardNumber.text length] == 0) {
        [errorsArray addObject:NSLocalizedString(@"* Credit card number is required.", nil)];
    }
    if ([self.cardExpiry.text length] == 0) {
        [errorsArray addObject:NSLocalizedString(@"* Card expiration is required.", nil)];
    }
    if ([self.cardCVV.text length] == 0) {
        [errorsArray addObject:NSLocalizedString(@"* Security code is required.", nil)];
    }
    
    
    if ([errorsArray count] > 0) {
        [self displayErrorMessageForErrors:errorsArray];
    } else {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = NSLocalizedString(@"Validating credit card...",nil);
        
        NSArray *expiryArray = [self.cardExpiry.text componentsSeparatedByString:@"/"];
        int expiryMonth = 0;
        int expiryYear = 0;
        if ([expiryArray count] == 2) {
            expiryMonth = [[expiryArray objectAtIndex:0] intValue];
            expiryYear = [[expiryArray objectAtIndex:1] intValue];
        } else {
            //NSLog(@"ERROR IN CC EXPIRY DATA");
        }
        
        
        NSDictionary *optionalFields = @{
                                         BPCardOptionalParamNameKey:[[ATPaymentManager sharedManager] billingFullName],
                                         BPCardOptionalParamPhoneNumberKey:[[ATPaymentManager sharedManager] billingPhoneNumber],
                                         BPCardOptionalParamStateKey:[[ATPaymentManager sharedManager] billingState],
                                         BPCardOptionalParamCityKey:[[ATPaymentManager sharedManager] billingCity],
                                         BPCardOptionalParamPostalCodeKey:[[ATPaymentManager sharedManager] billingZipCode],
                                         BPCardOptionalParamStreetAddressKey:[NSString stringWithFormat:@"%@ %@", [[ATPaymentManager sharedManager] billingAddress1], [[ATPaymentManager sharedManager] billingAddress2]],
                                         BPCardOptionalParamPostalCodeKey:[[ATPaymentManager sharedManager] billingZipCode],
                                         BPMetaShippingStreetAddress: [NSString stringWithFormat:@"%@ %@", [[ATPaymentManager sharedManager] shippingAddress1], [[ATPaymentManager sharedManager] shippingAddress2]],
                                         BPMetaShippingCity: [[ATPaymentManager sharedManager] shippingCity],
                                         BPMetaShippingRegion: [[ATPaymentManager sharedManager] shippingState]
                                         };
        
        //What if card already exists?
        if ([[ATPaymentManager sharedManager] bpCustomerExistsForEmail:self.billingInfoEmailField.text]) {
            
            //Try and match the credit card with one that already exists
            //Check to see if the current card has already been used
            //If the card is one of the ones saved locally - if it is then just
            BPCustomer *customer = [BPCustomer retrieveCustomerForEmail:self.billingInfoEmailField.text];
            
            [[ATPaymentManager sharedManager] setCurrentBPCustomer:customer];
            
            NSArray *cardsArray = [customer cardsURIArray];
            
            BOOL cardFound = NO;
            for (BPCard *card in cardsArray) {
                //NSLog(@"card: %@", [card description]);
                if ([card isEqualToCardNumber:self.cardNumber.text expMonth:self.expiryMonth expYear:self.expiryYear]) {
                    cardFound = YES;
//                    NSLog(@"card was found");
                    [[ATPaymentManager sharedManager] setCurrentBPCard:card];
                    [self pushCompletePurchaseScreen];
                }
            }
            
            if (!cardFound) {
//                NSLog(@"card not found");
                [[ATPaymentManager sharedManager] tokenizeCardWithNumber:self.cardNumber.text expirationMonth:expiryMonth expirationYear:expiryYear securityCode:self.cardCVV.text optionalFields:optionalFields];
            }
            
            
            //If the card has NOT been used befre
        } else {
            
            NSLog(@"gonna tokenize this bitch");
            [[ATPaymentManager sharedManager] tokenizeCardWithNumber:self.cardNumber.text expirationMonth:expiryMonth expirationYear:expiryYear securityCode:self.cardCVV.text optionalFields:optionalFields];
        }

    }
    
    
}

- (void)updateExpiry
{
    self.cardExpiry.text = [NSString stringWithFormat:@"%02i/%d",self.expiryMonth, self.expiryYear];
}


- (void)verifyEmailConfirmation:(NSNotification*)note
{
    //NSLog(@"userinfo %@", [note userInfo]);
    NSString *textFieldText = self.billingInfoEmailField.text;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"^%@",textFieldText] options:0 error:NULL];
    NSString *shippingEmailAddress = [[ATPaymentManager sharedManager] shippingEmailAddress];
    NSTextCheckingResult *match = [regex firstMatchInString:shippingEmailAddress options:0 range:NSMakeRange(0, [shippingEmailAddress length])];
    
    if (!match) {
        self.confirmEmailField.text = @"";
        [self showEmailConfirmationFields];
    } else {
        self.confirmEmailField.text = [[ATPaymentManager sharedManager] shippingEmailAddress];
        [self hideEmailConfirmationFields];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"expiryMonth"] || [keyPath isEqualToString:@"expiryYear"])
    {
        [self updateExpiry];
    } else {
        //NSLog(@"thats what im talking about %@", [change objectForKey:NSKeyValueChangeNewKey]);
//        
//        [[ATPaymentManager sharedManager] setBillingFirstName:self.billingInfoFirstNameField.text];
//        [[ATPaymentManager sharedManager] setBillingLastName:self.billingInfoLastNameField.text];
//        [[ATPaymentManager sharedManager] setBillingAddress1:self.billingInfoAddress1Field.text];
//        [[ATPaymentManager sharedManager] setBillingAddress2:self.billingInfoAddress2Field.text];
//        [[ATPaymentManager sharedManager] setBillingCity:self.billingInfoCityField.text];
//        [[ATPaymentManager sharedManager] setBillingState:self.billingInfoStateField.text];
//        [[ATPaymentManager sharedManager] setBillingZipCode:self.billingInfoZipField.text];
    }
    
    
}

- (IBAction)expiryButtonSelected:(id)sender
{
    UIButton *expiryButton = (UIButton*)sender;
    
    if (_creditCardExpiryController == nil) {

        
        self.creditCardExpiryController = [[ATCreditCardExpiryPickerViewController alloc] initWithNibName:@"ATCreditCardExpiryPickerViewController" bundle:nil];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 240.0f)];
        [pickerView setUserInteractionEnabled:YES];
        [self.creditCardExpiryController setView:pickerView];
        pickerView.delegate = (id)self.creditCardExpiryController;
        pickerView.dataSource = (id)self.creditCardExpiryController;
        pickerView.showsSelectionIndicator = YES;
        self.creditCardExpiryController.delegate = self;
        self.creditCardExpiryController.preferredContentSize = CGSizeMake(320, 200);
        self.pickerPopoverController = [[UIPopoverController alloc]
                                        initWithContentViewController:self.creditCardExpiryController];
        self.pickerPopoverController.delegate = self;
        self.expiryMonth = 1;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        self.expiryYear = [dateComponents year];
    }
    [self.pickerPopoverController presentPopoverFromRect:expiryButton.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)showEmailConfirmationFields
{
    self.confirmEmailField.hidden = NO;
    self.confirmEmailLabel.hidden = NO;
}

- (void)hideEmailConfirmationFields
{
    self.confirmEmailField.hidden = YES;
    self.confirmEmailLabel.hidden = YES;
}

#pragma mark - UITextFieldDelegate protocol method

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    activeField = (ATTextField*)textField;
    
    if (activeField.previousField == nil) {
        [textField setInputAccessoryView:[self.customKeyboard getToolbarWithPrevNextDone:FALSE :TRUE]];
    } else if (activeField.nextField == nil) {
        [textField setInputAccessoryView:[self.customKeyboard getToolbarWithPrevNextDone:TRUE :FALSE]];
    } else {
        [textField setInputAccessoryView:[self.customKeyboard getToolbarWithPrevNextDone:TRUE :TRUE]];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField

{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL didResign = [textField resignFirstResponder];
    if (!didResign) return NO;
    
    if ([textField isKindOfClass:[ATTextField class]])
        [[(ATTextField *)textField nextField] performSelectorInBackground:@selector(becomeFirstResponder) withObject:nil];

    return YES;
}


//Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbSize.width - BOTTOM_CHECKOUT_BAR_HEIGHT), 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.width;
    CGPoint origin = activeField.frame.origin;
    origin.y += self.scrollView.frame.origin.y;
    
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (activeField.frame.origin.y + 43.0f + self.scrollView.frame.origin.y) -(aRect.size.height));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"index row is %d and section is %d", indexPath.row, indexPath.section);
    _selectedRow = indexPath.row;
    if (_selectedRow == 1) {
        CGRect creditCardViewFrame = self.creditCardView.frame;
        creditCardViewFrame.size.height = (self.scrollView.frame.size.height * 2) - 45.0f;
        [self.creditCardView setFrame:creditCardViewFrame];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.creditCardView.frame.size.height);
        //NSLog(@"the height is %1.2f", self.creditCardView.frame.size.height);
        
        [self clearBillingInfo];
        
        CGPoint scrollPoint = self.billingInfoFirstNameField.frame.origin;
        scrollPoint.x = 0.0f;
        scrollPoint.y -= 50.0f;
        [self.scrollView setContentOffset:scrollPoint animated:YES];
        
        
    } else {
        CGRect creditCardViewFrame = self.creditCardView.frame;
        creditCardViewFrame.size.height = self.scrollView.frame.size.height;
        [self.creditCardView setFrame:creditCardViewFrame];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self duplicateShippingInfo];
        
    }
    [self.addressTableViewChooser reloadData];
}

- (void)clearBillingInfo
{
    [[ATPaymentManager sharedManager] clearBillingInfo];
    self.billingInfoFirstNameField.text = @"";
    self.billingInfoLastNameField.text = @"";
    self.billingInfoAddress1Field.text = @"";
    self.billingInfoAddress2Field.text = @"";
    self.billingInfoZipField.text = @"";
    self.billingInfoCityField.text = @"";
    self.billingInfoStateField.text = @"";
}

- (void)duplicateShippingInfo
{
    self.billingInfoFirstNameField.text = [[ATPaymentManager sharedManager] shippingFirstName];
    self.billingInfoLastNameField.text = [[ATPaymentManager sharedManager] shippingLastName];
    self.billingInfoAddress1Field.text = [[ATPaymentManager sharedManager] shippingAddress1];
    self.billingInfoAddress2Field.text = [[ATPaymentManager sharedManager] shippingAddress2];
    self.billingInfoCityField.text = [[ATPaymentManager sharedManager] shippingCity];
    self.billingInfoZipField.text = [[ATPaymentManager sharedManager] shippingZipCode];
    self.billingInfoCountryField.text = [[ATPaymentManager sharedManager] shippingCountry];
    self.billingInfoStateField.text = [[ATPaymentManager sharedManager] shippingState];
    self.billingInfoEmailField.text = [[ATPaymentManager sharedManager] shippingEmailAddress];
    self.confirmEmailField.text = [[ATPaymentManager sharedManager] shippingEmailAddress];
    self.billingInfoPhoneNumberField.text = [[ATPaymentManager sharedManager] shippingPhoneNumber];
}

#pragma mark
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *addressCellIdentifier = @"simpleTableItem";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor whiteColor];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Use Shipping Address",nil);
            if (_selectedRow == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        default:
            cell.textLabel.text = NSLocalizedString(@"Add Billing Address",nil);
            if (_selectedRow == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
    }
    
    return cell;
}

- (IBAction)reviewPurchaseButtonSelected:(id)selector
{
    if ([self validatePaymentInfo])
    {
        if ([self.promoCodeField.text length] > 0) {
            
            [self validatePromoCode];
            
        } else if ([self.giftCardField.text length] > 0) {
            [self validateGiftCard];
        
        } else {
            [[ATPaymentManager sharedManager] setDiscount:0.0f];
            [self validateCreditCard];
        }
        
    }
}


#pragma mark
#pragma mark CardIO

- (IBAction)scanCard:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"95603db56da443a8a3bf39b3b2e632ff"; // get your app token from the card.io website
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    //NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
    //NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    
    // Use the card info...
    self.cardNumber.text = info.cardNumber;
    self.cardExpiry.text = [NSString stringWithFormat:@"%02i/%i", info.expiryMonth, info.expiryYear];
    self.cardCVV.text = info.cvv;
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)statePickerButtonSelected:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (_statePickerController == nil) {
        self.statePickerController = [[ATStatePickerController alloc] initWithNibName:@"ATStatePickerController" bundle:nil];
        self.statePickerController.delegate = self;
        self.pickerPopoverController = [[UIPopoverController alloc]
                                        initWithContentViewController:self.statePickerController];
    }
    [self.pickerPopoverController presentPopoverFromRect:button.frame inView:self.scrollView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    //    [self.pickerPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark
#pragma mark ATStatePickerDelegate

- (void)didSelectState:(NSString*)stateString
{
    self.billingInfoStateField.text = stateString;
    [self.pickerPopoverController dismissPopoverAnimated:YES];
}

- (void)updateShippingLabel
{
    self.shippingAddress1Label.text = [[ATPaymentManager sharedManager] shippingAddress1];
    self.shippingAddress2Label.text = [[ATPaymentManager sharedManager] shippingAddress2];
    self.shippingCityStateZipLabel.text = [NSString stringWithFormat:@"%@, %@ %@",[[ATPaymentManager sharedManager] shippingCity], [[ATPaymentManager sharedManager] shippingState], [[ATPaymentManager sharedManager] shippingZipCode]];
}

- (void)didSelectExpiryYear:(NSNumber*)year
{
    self.expiryYear = [year intValue];
    //NSLog(@"year %d", [year intValue]);
}

- (void)didSelectExpiryMonth:(NSNumber*)month
{
    self.expiryMonth = [month intValue];
    //NSLog(@"month %d", [month intValue]);
}


- (void)didCreateCustomerSuccessfully:(NSNotification*)note
{
    [self pushCompletePurchaseScreen];
}

- (void)didFailCreatingCustomer:(NSNotification*)note
{
    UIAlertView *failedCustomerAlert = [[UIAlertView alloc] initWithTitle:@"Dang!" message:@"Could not process your payment. Please call 415-228-0842 or try again later." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [failedCustomerAlert show];
}


#pragma mark
#pragma mark CustomKeyboardDelegate

-(void)nextClicked:(NSUInteger)selectedId{
    [activeField.nextField becomeFirstResponder];
}

-(void)previousClicked:(NSUInteger)selectedId{
    [activeField.previousField becomeFirstResponder];
}

-(void)doneClicked:(NSUInteger)selectedId{
    [activeField resignFirstResponder];
}



@end
