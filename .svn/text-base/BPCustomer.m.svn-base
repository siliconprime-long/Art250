//
//  BPAccount.m
//  art250
//
//  Created by Winfred Raguini on 6/4/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "BPCustomer.h"
#import "BPHTTPClient.h"
#import "BPCard.h"
#import "ATPaymentManager.h"

#define BP_ACCOUNT_RESP_URI @"uri"

#define kURIKey @"kURIKey"
#define kCardsURIArrayKey @"kCardsURIArrayKey"
#define kEmailKey @"kEmailKey"

@interface BPCustomer ()
@property (nonatomic, strong, readwrite) NSDictionary *accountDict;
@property (nonatomic, strong, readwrite) NSString *URI;
@property (nonatomic, strong, readwrite) NSString *email;
@property (nonatomic, strong, readwrite) NSArray *cardsURIArray;
+ (void)saveNewCustomerForEmail:(NSString*)email withAccountURI:(NSString*)accountURI card:(BPCard*)card;
@end

@implementation BPCustomer


- (id)initWithURI:(NSString*)uri
{
    if (self = [super init]) {
        _URI = uri;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        _URI = [dictionary objectForKey:kBPAccountURIKey];
        _cardsURIArray = [dictionary objectForKey:kBPCardsKey];
        _email = [dictionary objectForKey:kBPEmailKey];
        _accountDict = dictionary;
        _buyerId = [dictionary objectForKey:kBuyerIdKey];
    }
    return self;
}

- (id)initWithURI:(NSString*)uri email:(NSString*)email buyerId:(NSNumber*)buyerId cardsArray:(NSArray*)cardsArray
{
    if (self = [super init]) {
        _URI = uri;
        _buyerId = buyerId;
        _email = email;
        _cardsURIArray = cardsArray;
    }
    return self;
}

- (id)initWithURI:(NSString *)uri email:(NSString *)email cardsArray:(NSArray *)cardsArray
{
    return [self initWithURI:uri email:email buyerId:0 cardsArray:cardsArray];
}

+ (void)addNewCustomerWithEmailAddress:(NSString *)email name:(NSString *)name
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: email, @"email", name, @"name", nil];
    [[BPHTTPClient sharedClient] postPath:[[BPHTTPClient sharedClient] customersURI] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSDictionary *jsonDict = JSON;
        NSString *uri = [jsonDict objectForKey:BP_ACCOUNT_RESP_URI];
        [self saveNewCustomerForEmail:email withAccountURI:uri card:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidCreateNewCustomerSuccessfullyNotification object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidCreateNewCustomerSuccessfullyNotification object:nil];
    }];
}


+ (void)addNewCustomerWithCard:(BPCard*)card andEmailAddress:(NSString*)email name:(NSString *)name
{

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:card.URI, @"card_uri", email, @"email", name, @"name", nil];
    [[BPHTTPClient sharedClient] postPath:[[BPHTTPClient sharedClient] customersURI] parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSDictionary *jsonDict = JSON;
        NSString *uri = [jsonDict objectForKey:BP_ACCOUNT_RESP_URI];
        [self saveNewCustomerForEmail:email withAccountURI:uri card:card];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidValidateCreditCardSuccessfully object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidValidateCreditCardFailed object:nil];
    }];
}


+ (BPCustomer*)retrieveCustomerForEmail:(NSString*)email
{
    NSData *customerData = [[NSUserDefaults standardUserDefaults] objectForKey:kBPCustomersKey];
    NSDictionary *customersDict = [NSKeyedUnarchiver unarchiveObjectWithData:customerData];
    BPCustomer *bpAccount = [customersDict objectForKey:email];
    return bpAccount;
}

- (void)associateCard:(BPCard*)card
{
//    NSLog(@"card uri is %@", card.URI);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:card.URI, @"card_uri", nil];
    [[BPHTTPClient sharedClient] putPath:self.URI parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSDictionary *jsonDict = JSON;
        [self saveCard:card];
        NSString *uri = [jsonDict objectForKey:BP_ACCOUNT_RESP_URI];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidValidateCreditCardSuccessfully object:nil];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[NSNotificationCenter defaultCenter] postNotificationName:kCreditCardAssociationFailedNotification object:nil];
    }];
}

- (void)saveCard:(BPCard*)card
{
    NSMutableArray *mutableCardsArray = [[NSMutableArray alloc] initWithArray:self.cardsURIArray];
    [mutableCardsArray addObject:card];
    NSMutableDictionary *mutableAccountDict = [[NSMutableDictionary alloc] initWithDictionary:self.accountDict];
    [mutableAccountDict setValue:mutableCardsArray forKey:kBPCardsKey];
    [[NSUserDefaults standardUserDefaults] setValue:mutableAccountDict forKey:self.email];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)cardAssociatedUsingLastFourDigits:(NSString*)lastFourDigits month:(NSUInteger)month year:(NSUInteger)year
{
    return YES;
}

+ (void)saveNewCustomerForEmail:(NSString*)email withAccountURI:(NSString*)accountURI card:(BPCard*)card
{
    //Retrieve existing dictionary of accounts - based on email
    NSData *existingData = [[NSUserDefaults standardUserDefaults] objectForKey:kBPCustomersKey];
    NSDictionary *accountsDict = [NSKeyedUnarchiver unarchiveObjectWithData:existingData];
    NSMutableDictionary *mutableAccountsDict = [[NSMutableDictionary alloc] initWithDictionary:accountsDict];
    
    //Array of an actual BPCard without a PAN
    NSArray *cardArray = nil;
    
    if (card != nil) {
        cardArray = [[NSArray alloc] initWithObjects:card, nil];
    }
    
    BPCustomer *bpCustomer = [[self alloc] initWithURI:accountURI email:email cardsArray:cardArray];
    
    //NSDictionary *accountInfoDict = [[NSDictionary alloc] initWithObjectsAndKeys:accountURI, kBPAccountURIKey, cardArray, kBPCardsKey, email, kBPEmailKey, nil];
    
    [mutableAccountsDict setValue:bpCustomer forKey:email];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mutableAccountsDict];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:kBPCustomersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [[ATPaymentManager sharedManager] setCurrentBPCustomer:bpCustomer];
}

- (void)save
{
    NSData *customersData = [[NSUserDefaults standardUserDefaults] objectForKey:kBPCustomersKey];
    
    
    NSDictionary *customersDict = [NSKeyedUnarchiver unarchiveObjectWithData:customersData];
    
    
    
    NSMutableDictionary *mutableCustomersDict = [[NSMutableDictionary alloc] initWithDictionary:customersDict];
    [mutableCustomersDict setValue:self forKey:self.email];
    
    NSData *newCustomerData = [NSKeyedArchiver archivedDataWithRootObject:mutableCustomersDict];
    

    [[NSUserDefaults standardUserDefaults] setValue:newCustomerData forKey:kBPCustomersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)setBuyerId:(NSNumber*)buyerId
{
    _buyerId = buyerId;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"buyerID: %d, URI:%@, cardsArray:%@, email: %@", [self.buyerId intValue], self.URI, self.cardsURIArray, self.email];
}

- (NSString*)debitsURI
{
    return [NSString stringWithFormat:@"%@/%@",self.URI, @"debits"];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_buyerId forKey:kBuyerIdKey];
    [aCoder encodeObject:_URI forKey:kURIKey];
    [aCoder encodeObject:_cardsURIArray forKey:kCardsURIArrayKey];
    [aCoder encodeObject:_email forKey:kEmailKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSNumber *buyerId = [decoder decodeObjectForKey:kBuyerIdKey];
    NSString *uri = [decoder decodeObjectForKey:kURIKey];
    NSArray *cardsArray = [decoder decodeObjectForKey:kCardsURIArrayKey];
    NSString *email = [decoder decodeObjectForKey:kEmailKey];
    return [self initWithURI:uri email:email buyerId:buyerId cardsArray:cardsArray];
}


@end
