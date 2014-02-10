//
//  ATArtManager.h
//  art250
//
//  Created by Winfred Raguini on 9/10/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATArtObject.h"
#import "ATCameraOverlayViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Artwork.h"

#define CHECKOUT_TIMER 600

typedef enum {
    ATCollectionTypeUnknown = 0,
    ATCollectionTypeFavorites,
    ATCollectionTypeRecommendations,
    ATCollectionTypeArtists
} ATCollectionType;

@interface ATArtManager : NSObject <CLLocationManagerDelegate> {
}

@property (nonatomic, strong) NSArray *queryArtistProfileObjectIDs;
@property (nonatomic, strong) NSManagedObjectID *artistProfileObjectID;

@property (nonatomic, readwrite, assign) ATDistanceButtonType distanceType;
@property (nonatomic, readwrite, assign) ATSizeButtonType sizeType;
@property (nonatomic, readwrite, strong) NSArray *artistDirectoryObjectIDs;

@property (nonatomic, readwrite, assign) BOOL firstTimeEnlargingAndSaving;

@property (nonatomic, readwrite, strong) Artwork *artwork1;
@property (nonatomic, readwrite, strong) Artwork *artwork2;
@property (nonatomic, readwrite, strong) Artwork *artwork3;
@property (nonatomic, readwrite, strong) Artwork *artwork4;
@property (nonatomic, readwrite, strong) Artwork *artwork5;
@property (nonatomic, readwrite, strong) Artwork *artwork6;
@property (nonatomic, assign, readonly) int secondsLeftToCompleteCheckout;

@property (nonatomic, readonly) NSString *collectionIDs;

@property (nonatomic, assign) int currentIndex;


@property (nonatomic, readonly, strong) NSMutableArray *additionalArtwork;

@property (nonatomic, strong) NSArray *fullArtwork;

@property (nonatomic, readwrite, strong) Artwork *currentArtObject;
@property (nonatomic, readwrite, strong) NSArray *collectionArray;


@property (nonatomic, readonly, strong) NSArray *cart;
@property (nonatomic, readonly, strong) NSArray *purchasedArtwork;

@property (nonatomic, strong) NSArray *primaryBackgroundImageColors;
@property (nonatomic, strong) NSTimer *checkoutTimer;
@property (nonatomic, strong) UIImage *wallImage;
@property (nonatomic, readonly, assign) int artworkBatchesLoaded;
@property (nonatomic, readonly, assign) BOOL allBatchesLoaded;
@property (nonatomic, assign) BOOL firstTimeUser;

@property (nonatomic, assign) BOOL firstTimeAddedToCollection;

@property (nonatomic, assign, readonly) int maxArtworkThreshold;
@property (nonatomic, assign, readonly) int artworkBatches;
@property (nonatomic, readonly, strong) NSString *collectionEndMessage;
@property (nonatomic, readonly, strong) NSString *collectionTitle;
@property (nonatomic, readonly, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, readwrite, assign) ATCollectionType collectionType;
- (void)loadFavorites;
- (void)loadRecommendations;
- (NSArray*)artCarousel;
- (NSArray*)cartOnly;
+ (ATArtManager*)sharedManager;
- (void)deleteSuggestedArtwork;
- (void)removeArtObjectFromCollection:(Artwork*)artObject;
- (void)addArtObjectToSuggestedArtwork:(Artwork*)artObject;
- (CGFloat)cartTotal;
- (CGFloat)cartTotalFormattedForBP;
- (void)addArtObjectToCart:(Artwork*)artwork;
- (void)removeArtObjectFromCart:(Artwork*)artwork;
- (void)retrieveSuggestedArtworkWithBackgroundImage:(UIImage*)image completionBlock:(void (^)(BOOL finished))completion;
- (void)retrieveSuggestedArtworkFromCacheWithBlock:(void (^)(BOOL finished, NSError *error))completion;
- (void)retrieveSuggestedArtworkFromCache;
- (void)restartCheckoutTimer;
- (void)resetTimer;
- (void)stopTimer;
- (CGFloat)pixelsPerInch;
- (void)insertArtObject:(Artwork*)artObject atIndex:(int)index;

- (UIImage*)hangItImageForArtObject:(Artwork*)artObject;
- (void)saveShareImage:(UIImage*)sharedImage forArtObject:(Artwork*)artObject;
- (NSString*)shareImageFilePathForArtObject:(Artwork*)artObject;
- (void)deleteShareImageforArtObject:(Artwork*)artObject;
- (void)moveCartToPurchasedArtwork;
- (UIImage*)artworkSplashImage;
- (void)incrementArtCounter;
- (void)resetArtCounter;
- (void)trackArtObject:(Artwork*)artObject;
- (int)trackedPieces;
- (void)replaceCurrentArtworkWithArtwork:(Artwork*)artwork;
- (void)showArtRecommendationHUDForView:(UIView *)view withText:(NSString*)message;
- (void)hideArtRecommendationView;
- (int)batchSize;
- (void)emptyCart;
- (void)emptyPurchasedArtwork;
- (void)additionalArtworkByArtistWithID:(NSNumber*)artistID completionBlock:(void (^)(NSArray *artwork, NSError *error))block;
- (void)removeArtworkFromSuggestedArtwork:(Artwork*)artwork;
- (void)removeArtworkFromSuggestedArtworkByArtist:(Artist*)artist;
- (NSString*)lastDistanceChosen;
- (NSString*)lastSizeChosen;
- (UIImage*)croppedImageForArtworkAtSlotIndex:(NSUInteger)index;
- (NSUInteger)collectionCount;
- (NSUInteger)cartOnlyCount;
- (void)updateCollectionStatus;
- (void)moveCartToSold;
- (void)addArtworkToCollection:(Artwork*)artwork;
- (void)queryArtworkForArtistProfileID:(NSNumber*)profileID;
- (void)updateArtistProfiles;
- (void)initializeArtistProfileObjectIDs;
- (void)loadArtworkForArtistProfilewithObjectID:(NSManagedObjectID*)objectID;
- (void)cacheBackgroundImage:(UIImage*)image;
- (UIImage*)cachedBackgroundImage;
- (UIImage*)savedBackgroundImage;
- (void)retrieveAdditionalArtworkForArtistIds:(NSArray*)artistIds loading:(BOOL)loading;
- (void)queryArtworkForArtistIDsArray:(NSArray*)queryArtistProfileObjectIDs aroundArtistWithObjectID:(NSManagedObjectID*)objectID;
- (NSArray*)additionalArtistObjectIDsStartingFromObjectID:(NSManagedObjectID*)objectID forward:(int)forwardRange backward:(int)backwardRange;
- (void)loadAdditionalArtistsFromObjectID:(NSManagedObjectID*)objectID forward:(int)forwardRange backward:(int)backwardRange;
- (void)loadCarouselMetadata;
- (NSManagedObjectID*)previousProfileObjectIDFrom:(SearchableArtistProfile*)artistProfile;
- (NSManagedObjectID*)nextProfileObjectIDFrom:(SearchableArtistProfile*)artistProfile;
- (Artwork*)findAnyArtworkForArtistProfile:(SearchableArtistProfile*)artistProfile;
- (void)replaceArtworkAtIndex:(NSUInteger)index withArtwork:(Artwork*)artwork;
@end
