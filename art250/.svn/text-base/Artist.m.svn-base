//
//  Artist.m
//  art250
//
//  Created by Winfred Raguini on 8/16/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "Artist.h"


@implementation Artist

@dynamic artworkCount;
@dynamic email;
@dynamic userID;
@dynamic artworks;
@dynamic profile;


- (int)numArtwork
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %d", [self.userID intValue]];
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    NSUInteger count = [ctx countForEntityForName:@"Artwork" predicate:predicate error:nil];
    return count;
}

+ (Artist *)uniqueArtistWithUserId:(NSNumber *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *artistArray;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"userID = %@", userID];
    request.fetchLimit = 1;
    NSError *executeFetchError = nil;
    artistArray = [context executeFetchRequest:request error:&executeFetchError];
    Artist *artist;
    
    if (executeFetchError) {
        NSLog(@"[%@, %@] error looking up user with id: %i with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [userID intValue], [executeFetchError localizedDescription]);
    } else if ([artistArray count] == 0) {
        artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist"
                                                                inManagedObjectContext:context];
        artist.userID = userID;
    } else {
        artist = [artistArray objectAtIndex:0];
    }
    
    return artist;
}

@end
