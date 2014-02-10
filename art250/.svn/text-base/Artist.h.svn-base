//
//  Artist.h
//  art250
//
//  Created by Winfred Raguini on 8/16/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ArtistProfile.h"

@interface Artist : NSManagedObject

@property (nonatomic, retain) NSNumber * artworkCount;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSSet *artworks;
@property (nonatomic, retain) ArtistProfile *profile;
@end

@interface Artist (CoreDataGeneratedAccessors)


- (void)addArtworksObject:(NSManagedObject *)value;
- (void)removeArtworksObject:(NSManagedObject *)value;
- (void)addArtworks:(NSSet *)values;
- (void)removeArtworks:(NSSet *)values;
- (int)numArtwork;
+ (Artist *)uniqueArtistWithUserId:(NSNumber *)userID inManagedObjectContext:(NSManagedObjectContext *)context;
@end
