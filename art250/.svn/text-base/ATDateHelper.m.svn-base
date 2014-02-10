//
//  ATDateHelper.m
//  art250
//
//  Created by Win Raguini on 1/6/14.
//  Copyright (c) 2014 Art250. All rights reserved.
//

#import "ATDateHelper.h"

@implementation ATDateHelper

+(NSDate*)parseDateString:(NSString *)dateString
{
    NSDateFormatter *rfc3339TimestampFormatterWithTimeZone = [[NSDateFormatter alloc] init];
    [rfc3339TimestampFormatterWithTimeZone setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [rfc3339TimestampFormatterWithTimeZone setDateFormat:@"MMM dd, yyyy"];
    
    NSDate *theDate = nil;
    NSError *error = nil;
    if (![rfc3339TimestampFormatterWithTimeZone getObjectValue:&theDate forString:dateString range:nil error:&error]) {
        NSLog(@"Date '%@' could not be parsed: %@", dateString, error);
    }
    
    return theDate;
}

@end
