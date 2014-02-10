//
//  ATTransientArtistProfile.m
//  art250
//
//  Created by Winfred Raguini on 12/12/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATTransientArtistProfile.h"

@implementation ATTransientArtistProfile

+ (void)artistProfilesWithBlock:(void (^)(NSArray *profiles, NSError *error))block
{
    NSNumber *limit = [NSNumber numberWithInt:50];
    NSNumber *offset = [NSNumber numberWithInt:0];
    NSDictionary *params = nil;
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/artist_profiles/query_artwork.json" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        
        
        if (block) {
            block([mappingResult array], nil);
        }
        
        
    }failure:^(RKObjectRequestOperation *operation, NSError *error){
        NSLog(@"dang error is %@", [error localizedDescription]);
        if (block) {
            block([NSArray array],error);
        }
    }];
}

@end
