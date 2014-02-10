//
//  ATPaymentManager.h
//  art250
//
//  Created by Winfred Raguini on 5/5/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ATCreditCardTypeVisa = 0,
    ATCreditCardTypeMC,
    ATCreditCardTypeDiscover,
    ATCreditCardTypeAmex
}ATCreditCardType;

@class Balanced;
@class BPCustomer;
@class BPCard;
@interface ATPaymentManager : NSObject

@property (nonatomic, readwrite) BPCustomer *currentBPCustomer;
@property (nonatomic, readwrite) BPCard *currentBPCard;

@property (nonatomic, assign) int promoCodeId;
@property (nonatomic, readwrite) CGFloat discount;
@property (nonatomic, readwrite) NSString *giftCardId;
@property (nonatomic, readwrite) CGFloat giftCardRemainingValue;

//Credit Card info
@property (nonatomic, assign) NSString *endingCreditCardNumber;
@property (nonatomic, assign) ATCreditCardType creditCardType;

//Shipping info
@property (nonatomic, strong) NSString *shippingFirstName;
@property (nonatomic, strong) NSString *shippingLastName;
@property (nonatomic, strong) NSString *shippingAddress1;
@property (nonatomic, strong) NSString *shippingAddress2;
@property (nonatomic, strong) NSString *shippingZipCode;
@property (nonatomic, strong) NSString *shippingCity;
@property (nonatomic, strong) NSString *shippingState;
@property (nonatomic, strong) NSString *shippingEmailAddress;
@property (nonatomic, strong) NSString *shippingPhoneNumber;
@property (nonatomic, strong) NSString *shippingCountry;

//Billing info
@property (nonatomic, strong) NSString *billingFirstName;
@property (nonatomic, strong) NSString *billingLastName;
@property (nonatomic, strong) NSString *billingAddress1;
@property (nonatomic, strong) NSString *billingAddress2;
@property (nonatomic, strong) NSString *billingZipCode;
@property (nonatomic, strong) NSString *billingCity;
@property (nonatomic, strong) NSString *billingState;
@property (nonatomic, strong) NSString *billingEmailAddress;
@property (nonatomic, strong) NSString *billingPhoneNumber;
@property (nonatomic, strong) NSString *billingCountry;

//Balanced
@property (nonatomic, strong) Balanced *balanced;

- (CGFloat)effectiveGiftCardValue;
+ (ATPaymentManager*)sharedManager;
- (BOOL)bpCustomerExistsForEmail:(NSString*)email;
- (void)duplicateShippingInfo;
- (void)clearBillingInfo;
- (void)clearShippingInfo;
- (NSString*)shippingFullName;
- (NSString*)billingFullName;
- (NSString*)endingCreditCardNumber;
- (UIImage*)currentCreditCardImage;
- (void)tokenizeCardWithNumber:(NSString*)cardNumber expirationMonth:(int)expMonth expirationYear:(int)expYear securityCode:(NSString*)code optionalFields:(NSDictionary*)optionalFields;
@end
