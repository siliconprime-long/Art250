//
//  ATPaymentManager.m
//  art250
//
//  Created by Winfred Raguini on 5/5/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATPaymentManager.h"
#import "Balanced.h"
#import "BPBankAccount.h"
#import "BPCard.h" 
#import "BPManager.h"
#import "BPCustomer.h"
#import "BPHTTPClient.h"
#import "ATArtManager.h"

#define DEFAULT_COUNTRY @"USA"



#define BALANCED_RESP_LAST_FOUR @"last_four"
#define BALANCED_RESP_STATUS_CODE_KEY @"status_code"
#define BALANCED_RESP_CARD_TYPE_KEY @"card_type"
#define BALANCED_RESP_CARD_URI @"uri"
#define BALANCED_RESP_EXPIRY_MONTH @"expiration_month"
#define BALANCED_RESP_EXPIRY_YEAR @"expiration_year"

@interface ATPaymentManager ()
- (Balanced*)createBalancedMarketplace;
- (void)setCardTypeWithResponse:(NSString*)cardTypeString;
- (void)associateAccountWithCardURI:(NSString*)cardURI;
@end

@implementation ATPaymentManager

+ (ATPaymentManager*)sharedManager
{
    static ATPaymentManager* _theManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theManager = [[ATPaymentManager alloc] init];
    });
    return _theManager;
}

- (id)init{
    if (self = [super init]) {
        _discount = 0.0f;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSaveNewAccount:) name:kdidSaveNewBPAccount object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTokenizeCreditCard:) name:kDidTokenizeCreditCard object:nil];
    }
    return self;
}


- (void)tokenizeCardWithNumber:(NSString*)cardNumber expirationMonth:(int)expMonth expirationYear:(int)expYear securityCode:(NSString*)code optionalFields:(NSDictionary*)optionalFields
{
    BPCard *card = [[BPCard alloc] initWithNumber:cardNumber expirationMonth:expMonth expirationYear:expYear securityCode:code optionalFields:optionalFields];
    
//    BPCard *card = [[BPCard alloc] initWithNumber:@"4242424242424242" expirationMonth:8 expirationYear:2025 securityCode:@"123"];
    
    Balanced *balanced = [[Balanced alloc] initWithMarketplaceURI:kBPMarketplaceURLString];

    NSLog(@"Trying to validate credit card with Balanced");
    
    [balanced tokenizeCard:card onSuccess:^(NSDictionary *responseParams) {
        // success
        //NSLog(@"woohoo!! responseParams %@", responseParams);
        //Check to see if status code is 2XX (Successful) or
        //4xx or 5xx (error)
        int statusCode = [responseParams objectForKey:BALANCED_RESP_STATUS_CODE_KEY];
        //NSLog(@"status_code is %d", statusCode);
        if (statusCode > 399) {
            //Error - error
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidValidateCreditCardFailed object:nil];
        } else {
//            NSString *cardLastFourDigits = [responseParams objectForKey:BALANCED_RESP_LAST_FOUR];
//            self.endingCreditCardNumber = cardLastFourDigits;
            //[[BPManager sharedManager] setCardLastFourDigits:cardLastFourDigits];
            //[[BPManager sharedManager] setCardURI:[responseParams objectForKey:BALANCED_RESP_CARD_URI]];
            NSString *cardType = [responseParams objectForKey:BALANCED_RESP_CARD_TYPE_KEY];
            [self setCardTypeWithResponse:cardType];
            NSUInteger expirationMonth = [[responseParams objectForKey:BALANCED_RESP_EXPIRY_MONTH] integerValue];
            NSUInteger expirationYear = [[responseParams objectForKey:BALANCED_RESP_EXPIRY_YEAR] integerValue];
            
            BPCard *tokenizedCard = [[BPCard alloc] initWithURI:[responseParams objectForKey:BALANCED_RESP_CARD_URI] lastFourDigits:[responseParams objectForKey:BALANCED_RESP_LAST_FOUR] expirationMonth:expirationMonth expirationYear:expirationYear];
            
            [self associateAccountWithCard:tokenizedCard];
            
            self.currentBPCard = tokenizedCard;
            
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:tokenizedCard, kBPCardKey, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidTokenizeCreditCard object:nil userInfo:dict];
            
            //If there is no existing account
            //What to do if there is already an account
            NSLog(@"Successfully validated credit card.");
        }
    } onError:^(NSError *error) {
        // failure
        NSLog(@"Balanced FAILED %@ at BALANCED_MARKETPLACE_URI:%@", [error localizedDescription], kBPMarketplaceURLString);
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidValidateCreditCardFailed object:nil];
    }];
}

- (void)associateAccountWithCard:(BPCard*)card
{
    //If there's an existing account based on the billing email then associate the card with that
    if ([self bpCustomerExistsForEmail:self.billingEmailAddress]) {
        BPCustomer *existingCustomer = [BPCustomer retrieveCustomerForEmail:self.billingEmailAddress];
        [existingCustomer associateCard:card];
    } else {
        [BPCustomer addNewCustomerWithCard:card andEmailAddress:self.billingEmailAddress name:self.billingFullName];
    }
}



- (BOOL)bpCustomerExistsForEmail:(NSString*)email
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kBPCustomersKey];
    NSDictionary *accountDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return [accountDict objectForKey:email] != nil;
}

- (void)setCardTypeWithResponse:(NSString*)cardTypeString
{
    if ([cardTypeString isEqualToString:@"mastercard"])
    {
        self.creditCardType = ATCreditCardTypeMC;
    } else if ([cardTypeString isEqualToString:@"visa"])
    {
        self.creditCardType = ATCreditCardTypeVisa;
    } else if ([cardTypeString isEqualToString:@"discover"])
    {
        self.creditCardType = ATCreditCardTypeDiscover;
    } else {
        self.creditCardType = ATCreditCardTypeAmex;
    }
}

- (void)duplicateShippingInfo
{
    //Billing info
    self.billingFirstName = self.shippingFirstName;
    self.billingLastName = self.shippingLastName;
    self.billingAddress1 = self.shippingAddress1;
    self.billingAddress2 = self.shippingAddress2;
    self.billingZipCode = self.shippingZipCode;
    self.billingCity = self.shippingCity;
    self.billingState = self.shippingState;
    self.billingEmailAddress = self.shippingEmailAddress;
    self.billingPhoneNumber = self.shippingPhoneNumber;
}

- (void)clearShippingInfo
{
    //Billing info
    self.shippingFirstName = nil;
    self.shippingLastName = nil;
    self.shippingAddress1 = nil;
    self.shippingAddress2 = nil;
    self.shippingZipCode = nil;
    self.shippingCity = nil;
    self.shippingState = nil;
    self.shippingEmailAddress = nil;
    self.shippingPhoneNumber = nil;
}

- (void)clearBillingInfo
{
    //Billing info
    self.billingFirstName = nil;
    self.billingLastName = nil;
    self.billingAddress1 = nil;
    self.billingAddress2 = nil;
    self.billingZipCode = nil;
    self.billingCity = nil;
    self.billingState = nil;
    self.billingEmailAddress = nil;
    self.billingPhoneNumber = nil;
}

- (NSString*)shippingCountry
{
    return DEFAULT_COUNTRY;
}

- (NSString*)billingCountry
{
    return DEFAULT_COUNTRY;
}

- (NSString*)shippingFullName
{
    return [NSString stringWithFormat:@"%@ %@", self.shippingFirstName, self.shippingLastName];
}

- (NSString*)billingFullName
{
    return [NSString stringWithFormat:@"%@ %@", self.billingFirstName, self.billingLastName];
}

- (UIImage*)currentCreditCardImage
{
    switch (self.creditCardType) {
        case ATCreditCardTypeVisa:
            return [UIImage imageNamed:@"credit_card_visa_C.png"];
            break;
        case ATCreditCardTypeMC:
            return [UIImage imageNamed:@"credit_card_master_C.png"];
            break;
        case ATCreditCardTypeDiscover:
            return [UIImage imageNamed:@"credit_card_discover_C.png"];
            break;
        default:
            return [UIImage imageNamed:@"credit_card_amex_C.png"];
            break;
    }
}

- (CGFloat)effectiveGiftCardValue
{
    CGFloat cartTotal = [[ATArtManager sharedManager] cartTotal] - [[ATPaymentManager sharedManager] discount];
    CGFloat giftCardRemainingValue = [[ATPaymentManager sharedManager] giftCardRemainingValue];
    
    //cartTotal > giftCardRemainingValue
    //cartTotal < giftCardRemainingValue
    //cartTotal == giftCardRemainingValue
    
    return MIN(giftCardRemainingValue,cartTotal);
}





@end
