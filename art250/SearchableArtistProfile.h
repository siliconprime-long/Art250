//
//  SearchableArtistProfile.h
//  art250
//
//  Created by Winfred Raguini on 12/12/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist, Artwork;

@interface SearchableArtistProfile : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * profileID;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * artistStatement;
@property (nonatomic, retain) id profileImageURL;
@property (nonatomic, retain) id profilePreviewURL;
@property (nonatomic, retain) id profileThumbURL;
@property (nonatomic, retain) Artist *artist;
@property (nonatomic, retain) NSSet *artworks;
@end

@interface SearchableArtistProfile (CoreDataGeneratedAccessors)

- (void)addArtworksObject:(Artwork *)value;
- (void)removeArtworksObject:(Artwork *)value;
- (void)addArtworks:(NSSet *)values;
- (void)removeArtworks:(NSSet *)values;

+ (SearchableArtistProfile*)uniqueArtistProfileWithProfileId:(NSNumber *)profiledID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)artistProfilesSinceLastSyncDate:(NSDate*)lastSyncDate offset:(NSNumber*)offset withBlock:(void (^)(NSArray *profiles, NSError *error))block;
+ (SearchableArtistProfile*)lastSearchableArtistProfile;
+ (void)loadArtistProfilesWithOffset:(NSNumber*)offset;
+ (NSArray*)artistProfilesBeginningWith:(NSString*)beginningLetter;
+ (NSUInteger)countOfArtistProfilesBeginningWith:(NSString*)beginningLetter;
+ (NSArray*)artistProfilesWithSearchString:(NSString*)searchText;
- (NSString*)fullName;
- (NSString*)locationString;
- (BOOL)hasUploadedProfileImage;

@end
