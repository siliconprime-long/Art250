//
//  BPHTTPClient.m
//  art250
//
//  Created by Winfred Raguini on 6/5/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "BPHTTPClient.h"
#import "AFJSONRequestOperation.h"



@implementation BPHTTPClient

+ (BPHTTPClient *)sharedClient {
    static BPHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BPHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBPHTTPBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setAuthorizationHeaderWithUsername:kBPAPIKeySecret password:nil];
    return self;
}

- (NSString*)baseURI
{
    return [self.baseURL absoluteString];
}

- (NSString*)marketplaceURI
{
    return kBPMarketplaceURLString;
}

- (NSString*)customersURI
{
    return [NSString stringWithFormat:@"%@", @"/v1/customers"];
}



@end
