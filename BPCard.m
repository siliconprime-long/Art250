//
//  BPCard.m
//  Balanced iOS Example
//
//  Created by Ben Mills on 3/9/13.
//

#import "BPCard.h"

#define kURIKey @"kURIKey"
#define kLastFourDigitsKey @"kLastFourDigitsKey"
#define kSecurityCodeKey @"kSecurityCodeKey"
#define kExpirationMonthKey @"kExpirationMonthKey"
#define kExpirationYearKey @"kExpirationYearKey"

@interface BPCard ()
@property (nonatomic, readwrite) NSString *expiration;
@end

@implementation BPCard
@synthesize errors;

- (id)initWithNumber:(NSString *)cardNumber expirationMonth:(NSUInteger)expirationMonth expirationYear:(NSUInteger)expirationYear securityCode:(NSString *)securityCode
{
    return [self initWithNumber:cardNumber expirationMonth:expirationMonth expirationYear:expirationYear securityCode:securityCode optionalFields:nil];
}

- (id)initWithNumber:(NSString *)cardNumber expirationMonth:(NSUInteger)expirationMonth expirationYear:(NSUInteger)expirationYear securityCode:(NSString *)securityCode optionalFields:(NSDictionary *)optionalFields
{
    self = [super init];
    if (self) {
        [self setNumber:[cardNumber stringByReplacingOccurrencesOfString:@"\\D"
                                                       withString:@""
                                                          options:NSRegularExpressionSearch
                                                                   range:NSMakeRange(0, cardNumber.length)]];
        [self setExpirationMonth:expirationMonth];
        [self setExpirationYear:expirationYear];
        [self setSecurityCode:securityCode];
        [self setOptionalFields:[NSDictionary dictionaryWithDictionary:optionalFields]];
        self.errors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_URI forKey:kURIKey];
    [aCoder encodeObject:_lastFourDigits forKey:kLastFourDigitsKey];
    [aCoder encodeInteger:_expirationMonth forKey:kExpirationMonthKey];
    [aCoder encodeInteger:_expirationYear forKey:kExpirationYearKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *uri = [decoder decodeObjectForKey:kURIKey];
    NSString *lastFourDigits = [decoder decodeObjectForKey:kLastFourDigitsKey];
    NSUInteger *expirationMonth = [decoder decodeIntegerForKey:kExpirationMonthKey];
    NSUInteger expirationYear = [decoder decodeIntegerForKey:kExpirationYearKey];
    return [self initWithURI:uri lastFourDigits:lastFourDigits expirationMonth:expirationMonth expirationYear:expirationYear];
}


- (id)initWithURI:(NSString*)uri lastFourDigits:(NSString*)lastFourDigits expirationMonth:(NSUInteger)expirationMonth expirationYear:(NSUInteger)expirationYear
{
    if (self = [super init]) {
        _URI = uri;
        _lastFourDigits = lastFourDigits;
        _expirationMonth = expirationMonth;
        _expirationYear = expirationYear;
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"URI: %@, lastFourDigits:%@ expMonth:%d expYear:%d", self.URI, self.lastFourDigits, self.expirationMonth, self.expirationYear];
}

- (NSString*)expiration
{
    return [NSString stringWithFormat:@"%02d/%02d",_expirationMonth,_expirationYear];
}

- (BOOL)isEqualToCardNumber:(NSString*)cardNumber expMonth:(int)month expYear:(int)year
{
    NSString *compareNumber = cardNumber;
    if ([cardNumber length] > 4) {
        NSRange theRange;
        theRange.location = [cardNumber length]  - 4;
        theRange.length = 4;
        compareNumber = [cardNumber substringWithRange:theRange];
    }
    return ([self.lastFourDigits isEqualToString:compareNumber] && self.expirationMonth == month && self.expirationYear == year);
}

- (BOOL)isEqualToCard:(BPCard*)card
{
    
    return YES;
}

- (BOOL)getNumberValid {
    if (self.number == nil) { return false; }
    if ([self.number length] < 12) { return false; }
    
    BOOL odd = true;
    int total = 0;
    
    for (int i = self.number.length - 1; i >= 0; i--) {
        int value = [[self.number substringWithRange:NSMakeRange(i, 1)] intValue];
        total += (odd = !odd) ? 2 * value - (value > 4 ? 9 : 0) : value;
    }

    return (total % 10) == 0;
}

- (BOOL)getSecurityCodeValid {
    if (self.securityCode==0) { return false; }
    if (self.type==BPCardTypeUnknown) { return false; }
    NSUInteger requiredLength = (self.type==BPCardTypeAmericanExpress) ? 4 : 3;
    return [self.securityCode length] == requiredLength;
}

- (BOOL)getExpired {
    if (self.expirationMonth > 12 || self.expirationYear < 1) { return false; }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentMonth = [components month];
    NSInteger currentYear = [components year];
    
    return currentYear > self.expirationYear || (currentYear == self.expirationYear && currentMonth >= self.expirationMonth);
}

- (BOOL) getValid {
    BOOL valid = true;
    
    if (!self.numberValid) {
        [errors addObject:@"Card number is not valid"];
        valid = false;
    }
    
    if (self.expired) {
        [errors addObject:@"Card is expired"];
        valid = false;
    }
    
    if (!self.securityCodeValid) {
        [errors addObject:@"Security code is not valid"];
        valid = false;
    }
    
    return valid;
}

- (BPCardType) getType
{
    int digits = [[self.number substringWithRange:NSMakeRange(0, 2)] integerValue];
    
    if (digits >= 40 && digits <= 49) {
        return BPCardTypeVisa;
    }
    else if (digits >= 50 && digits <= 59) {
        return BPCardTypeMastercard;
    }
    else if (digits == 60 || digits == 62 || digits == 64 || digits == 65) {
        return BPCardTypeDiscover;
    }
    else if (digits == 34 || digits == 37) {
        return BPCardTypeAmericanExpress;
    }
    else {
        return BPCardTypeUnknown;
    }
}

@end
