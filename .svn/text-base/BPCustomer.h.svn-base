//
//  BPAccount.h
//  art250
//
//  Created by Winfred Raguini on 6/4/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPCard;
@interface BPCustomer : NSObject
@property (nonatomic, strong, readwrite) NSNumber *buyerId;
@property (nonatomic, strong, readonly) NSString *URI;
@property (nonatomic, strong, readonly) NSArray *cardsURIArray;
@property (nonatomic, readonly) NSString *bankAccountsURI;
@property (nonatomic, readonly) NSString *cardsURI;
@property (nonatomic, readonly) NSString *creditsURI;
@property (nonatomic, readonly) NSString *debitsURI;
@property (nonatomic, readonly) NSString *holdsURI;
@property (nonatomic, readonly) NSString *refundsURI;
@property (nonatomic, readonly) NSString *transactionsURI;

- (id)initWithURI:(NSString*)uri;
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (id)initWithURI:(NSString *)uri email:(NSString *)email cardsArray:(NSArray *)cardsArray;
- (id)initWithURI:(NSString*)uri email:(NSString*)email buyerId:(NSNumber*)buyerId cardsArray:(NSArray*)cardsArray;
+ (void)addNewCustomerWithEmailAddress:(NSString *)email name:(NSString *)name;
+ (void)addNewCustomerWithCard:(BPCard*)card andEmailAddress:(NSString*)email name:(NSString*)name;
+ (BPCustomer*)retrieveCustomerForEmail:(NSString*)email;
- (void)associateCard:(BPCard*)card;
- (void)save;
- (BOOL)cardAssociatedUsingLastFourDigits:(NSString*)lastFourDigits month:(NSUInteger)month year:(NSUInteger)year;
@end
