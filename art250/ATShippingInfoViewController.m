//
//  ATShippingInfoViewController.m
//  art250
//
//  Created by Winfred Raguini on 3/20/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATShippingInfoViewController.h"
#import "ATPurchaseCompleteViewController.h"
#import "ATPaymentInfoViewController.h"
#import "ATPaymentManager.h"
#import "NSString+ATExtensions.h"
#import "ATShipmentManager.h"
#import "ATTextField.h"

#define BOTTOM_CHECKOUT_BAR_HEIGHT 104.0f

@interface ATShippingInfoViewController () 
- (BOOL)validateShippingInfo;
@property (nonatomic, strong) CustomKeyboard *customKeyboard;
@end

@implementation ATShippingInfoViewController
@synthesize countryPickerController = _countryPickerController;


ATTextField *activeField;

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
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];


    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 480.0f)];
        
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.scrollView addGestureRecognizer:tapRecognizer];
    
    
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



- (void)tapDetected:(UITapGestureRecognizer*)recognizer
{
    [activeField resignFirstResponder];
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

- (IBAction)submitPaymentButtonSelected:(id)sender
{
//    [[ATShipmentManager sharedManager] createXMLElement];
    
    //First validate
    if ([self validateShippingInfo]) {
        [[ATTrackingManager sharedManager] trackEvent:FL_SHIPMENT_PAGE_VALIDATED];
        ATPaymentInfoViewController *paymentController = [[ATPaymentInfoViewController alloc] initWithNibName:@"ATPaymentInfoViewController" bundle:nil];
        [self.navigationController pushViewController:paymentController animated:YES];
    }
}
    
- (BOOL)validateShippingInfo
{
    //Should validate here
    NSString *errorString = @"";
    if ([self.shippingInfoFirstNameField.text length] == 0)
    {
        errorString = [errorString stringByAppendingFormat:@"\n %@",NSLocalizedString(@"* First name is required.",nil)];
    }
    if ([self.shippingInfoLastNameField.text length] == 0) {
        errorString = [errorString stringByAppendingFormat:@"\n %@",NSLocalizedString(@"* Last name is required.",nil)];
    }
    if ([self.shippingInfoAddress1Field.text length] == 0) {
        errorString = [errorString stringByAppendingFormat:@"\n %@",NSLocalizedString(@"* Address is required.",nil)];
    }
    if ([self.shippingInfoCityField.text length] == 0) {
        errorString = [errorString stringByAppendingFormat:@"\n %@",NSLocalizedString(@"* City is required.",nil)];
    }
    if ([self.shippingInfoZipField.text length] == 0) {
        errorString = [errorString stringByAppendingFormat:@"\n %@",NSLocalizedString(@"* Zip code is required.",nil)];
    }
    if ([self.shippingInfoStateField.text length] == 0) {
        errorString = [errorString stringByAppendingFormat:@"\n %@",NSLocalizedString(@"* State is required.",nil)];
    }
    if ([self.shippingInfoEmailAddressField.text length] == 0) {
        errorString = [errorString stringByAppendingFormat:@"\n %@",NSLocalizedString(@"* Email is required.",nil)];

    } else {
        if (![NSString isValidEmail:self.shippingInfoEmailAddressField.text]) {
            UIAlertView *shippingValidationAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid email", nil) message:NSLocalizedString(@"Use a valid email so I can email you cool stuff",nil) delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [shippingValidationAlert show];
            return NO;
        } else if (![self.shippingInfoEmailAddressField.text isEqualToString:self.confirmEmailField.text]) {
            UIAlertView *shippingValidationAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm email", nil) message:NSLocalizedString(@"Your emails should match.",nil) delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [shippingValidationAlert show];
            return NO;
        }
    }
    if ([self.shippingInfoPhoneNumberField.text length] == 0) {
        errorString = [errorString stringByAppendingFormat:@"\n %@",NSLocalizedString(@"* Phone number is required.", nil)];
    }
    
    
    if ([errorString length] > 0) {
        UIAlertView *shippingValidationAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing shipping info.",nil) message:errorString delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [shippingValidationAlert show];
        return NO;
    } else {
        [[ATPaymentManager sharedManager] setShippingFirstName:self.shippingInfoFirstNameField.text];
        [[ATPaymentManager sharedManager] setShippingLastName:self.shippingInfoLastNameField.text];
        [[ATPaymentManager sharedManager] setShippingAddress1:self.shippingInfoAddress1Field.text];
        if ([self.shippingInfoAddress2Field.text length] > 0) {
            [[ATPaymentManager sharedManager] setShippingAddress2:self.shippingInfoAddress2Field.text];
        }
        [[ATPaymentManager sharedManager] setShippingCity:self.shippingInfoCityField.text];
        [[ATPaymentManager sharedManager] setShippingZipCode:self.shippingInfoZipField.text];
        [[ATPaymentManager sharedManager] setShippingState:self.shippingInfoStateField.text];
        [[ATPaymentManager sharedManager] setShippingEmailAddress:self.shippingInfoEmailAddressField.text];
        [[ATPaymentManager sharedManager] setShippingPhoneNumber:self.shippingInfoPhoneNumberField.text];
        return YES;
    }
}

- (IBAction)cancelButtonSelected:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark Private

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
        [[(ATTextField *)textField nextField] performSelectorOnMainThread:@selector(becomeFirstResponder) withObject:nil waitUntilDone:NO];

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
    
    //NSLog(@"keyBoard height is %1.2f", kbSize.height);
    //NSLog(@"keyBoard width is %1.2f", kbSize.width);
    
    //NSLog(@"the view frame is now origin x: %1.2f, origin y:%1.2f, width:%1.2f, height:%1.2f", self.view.frame.origin.x, self.view.frame.origin.y, aRect.size.width, aRect.size.height);
    
    //NSLog(@"aRect origin x:%1.2f origin y:%1.2f", origin.x, origin.y);
    
    //NSLog(@"activeField origin.y %1.2f", activeField.frame.origin.y);
    
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (activeField.frame.origin.y + 43.0f + self.scrollView.frame.origin.y) - (aRect.size.height));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }

}

//- (void)keyboardWasShown:(NSNotification*)aNotification {
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    CGRect bkgndRect = activeField.superview.frame;
//    bkgndRect.size.height += kbSize.height;
//    [activeField.superview setFrame:bkgndRect];
//    [self.scrollView setContentOffset:CGPointMake(0.0, activeField.frame.origin.y-kbSize.height) animated:YES];
//}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark
#pragma mark ATCountryPickerDelegate

- (void)didSelectCountry:(NSString*)countryString
{
    //NSLog(@"You picked this country %@", countryString);
    [self.pickerPopoverController dismissPopoverAnimated:YES];
}

#pragma mark
#pragma mark ATStatePickerDelegate

- (void)didSelectState:(NSString*)stateString
{
    self.shippingInfoStateField.text = stateString;
    //NSLog(@"You picked this state %@", stateString);
    [self.pickerPopoverController dismissPopoverAnimated:YES];
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
