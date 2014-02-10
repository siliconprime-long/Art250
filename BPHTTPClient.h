//
//  BPHTTPClient.h
//  art250
//
//  Created by Winfred Raguini on 6/5/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "AFHTTPClient.h"

//Test Marketplace credentials
#ifdef DEBUG
#define kBPHTTPBaseURLString @"https://api.balancedpayments.com"
//#define kBPMarketplaceURLString @"/v1/marketplaces/TEST-MP2fvaHCuLF94CajeNNerq9i"
//#define kBPAPIKeySecret @"49519512cd7a11e2a17f026ba7d31e6f"

//Test marketplace
#define kBPMarketplaceURLString @"/v1/marketplaces/TEST-MP67IC0XTlxPLdbP5r6Nb20L"
#define kBPAPIKeySecret @"ak-test-r0xnhJscpp2595Cv11XANiXMC4JjS4bF"

#else

#warning Change this with production credentials
#define kBPHTTPBaseURLString @"https://api.balancedpayments.com"
//LIVE marketplace
#define kBPMarketplaceURLString @"/v1/marketplaces/MP4SRIxr6bN8qSBCbJXypdWM"
#define kBPAPIKeySecret @"a06b1ecade1111e29b53026ba7cac9da"

#endif

@interface BPHTTPClient : AFHTTPClient

+ (BPHTTPClient *)sharedClient;
@property (nonatomic, readonly) NSString *marketplaceURI;
@property (nonatomic, readonly) NSString *customersURI;
@property (nonatomic, readonly) NSString *baseURI;
@end
