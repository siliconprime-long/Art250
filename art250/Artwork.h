//
//  Artwork.h
//  art250
//
//  Created by Winfred Raguini on 8/16/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Artist;
@class SearchableArtistProfile;
@interface Artwork : NSManagedObject

@property (nonatomic, retain) NSString * algorithmUsed;
@property (nonatomic, retain) NSString * artworkDescription;
@property (nonatomic, retain) NSNumber * artworkID;
@property (nonatomic, retain) id artworkImgURL;
@property (nonatomic, retain) NSNumber * columns;
@property (nonatomic, retain) NSNumber * depth;
@property (nonatomic, retain) id genre;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) id ipadDisplayImgURL;
@property (nonatomic, retain) id keyword;
@property (nonatomic, retain) id medium;
@property (nonatomic, retain) NSString * previewImgURL;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * recommended;
@property (nonatomic, retain) NSNumber * rows;
@property (nonatomic, retain) NSString * shippingRequirements;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) id thumbImgURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * inCollection;
@property (nonatomic, retain) NSNumber * inCart;
@property (nonatomic, retain) NSDate *addedToCartAt;
@property (nonatomic, retain) Artist *artist;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSNumber * numInOtherCollections;
@property (nonatomic, retain) NSDate * soldAt;
@property (nonatomic, strong) UIImage *croppedImage;
@property (nonatomic, strong) SearchableArtistProfile *searchableProfile;
+ (Artwork *)uniqueArtworkWithArtworkID:(NSNumber *)artworkID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Artwork*)uniqueArtworkWithDictionary:(NSDictionary *)artworkInfoDict forContext:(NSManagedObjectContext*)ctx;
- (NSString*)dimensionsString;
- (void)updateStatus;
- (UIImage*)artImage;
- (BOOL)sold;
- (NSString*)genreString;
+ (RKResponseDescriptor*)rkResponseDescriptor;
- (NSString*)mediumString;
+ (RKEntityMapping*)entityMapping;
+ (void)additionalArtworkForArtistIds:(NSArray*)artistIds withBlock:(void (^)(NSArray *additionalArtwork, NSArray *nextBatch, NSError *error))block;
+ (void)additionalArtworkForArtistIds:(NSArray*)artistIds forArtistProfileObjectID:(NSManagedObjectID*)objectID forArtistProfileObjectIDs:(NSArray*)queryArtistProfileObjectIDs withBlock:(void (^)(NSArray *additionalArtwork, NSArray *nextBatch, NSManagedObjectID *objID, NSArray *objIDArray, NSError *error))block;
@end
