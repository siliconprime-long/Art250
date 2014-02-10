//
//  ATAPIClient.m
//  art250
//
//  Created by Winfred Raguini on 3/31/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATAPIClient.h"
#import "AFJSONRequestOperation.h"

//static NSString * const kATAPIBaseURLString = @"http://192.168.2.1:3000/";
//static NSString * const kATAPIBaseURLString = @"http://localhost:3000/";

#ifdef DEBUG
    //static NSString * const kATAPIBaseURLString = @"https://arttwo50.herokuapp.com/";
    static NSString * const kATAPIBaseURLString = @"http://gentle-journey-7944.herokuapp.com/";
    //static NSString * const kATAPIBaseURLString = @"http://localhost:3000/";
#else
    static NSString * const kATAPIBaseURLString = @"https://arttwo50.herokuapp.com/";
#endif

@implementation ATAPIClient

+ (ATAPIClient *)sharedClient {
    static ATAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ATAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kATAPIBaseURLString]];
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
    
    return self;
}

@end
