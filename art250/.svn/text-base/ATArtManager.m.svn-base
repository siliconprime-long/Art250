//
//  ATArtManager.m
//  art250
//
//  Created by Winfred Raguini on 9/10/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATArtManager.h"
#import "Artwork.h"
#import "Artist.h"
#import "UIImage+WRExtensions.h"
#import "UIColor+WRExtensions.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "ATPaymentManager.h"
#import "ATArtistObject.h"
#import "ATUserManager.h"
#import "ATTransientArtistProfile.h"
#import "ATTransientArtist.h"
#import "ATTransientArtwork.h"
#import "SearchableArtistProfile.h"
#import <Parse/Parse.h>
#import "ATInactiveArtworkProxy.h"

#define MAX_ART_IDS_REQUESTED 100
#define NUM_BATCHES 3

#define MAX_HUES 20
#define IPAD_SQUISH_FACTOR 0.8134328358209
#define NUM_SPLASH_ARTWORK 7

#define MAX_ARTWORK_BATCHES 3

#define PREV_ARTISTS_RANGE 10
#define NEXT_ARTISTS_RANGE 20

typedef enum {
    ATArtworkDistanceTypeClose = 0, //8 feet
    ATArtworkDistanceTypeMedium,    //12 feet
    ATArtworkDistanceTypeFar        //16 feet
} ATArtworkDistanceType;

@interface ATArtManager ()
@property (nonatomic, strong, readonly) NSString *distanceSelection;
@property (nonatomic, strong, readonly) NSString *sizeSelection;
@property (nonatomic, readwrite, strong) NSMutableArray *suggestedArtwork;
@property (nonatomic, assign) BOOL loadingArtworkForChosenArtist;
@property (nonatomic, assign) BOOL appendingCarouselWithMoreArtists;
@property (nonatomic, assign) BOOL prependingCarouselWithMoreArtists;
@property (nonatomic, readwrite, assign) int secondsLeftToCompleteCheckout;
@property (nonatomic, readwrite, assign) int artworkBatchesLoaded;
@property (nonatomic, readwrite, assign) CGFloat lat;
@property (nonatomic, readwrite, assign) CGFloat lng;
@property (nonatomic, readwrite, strong) NSArray* artworkAlreadyPurchased;
@property (nonatomic, readwrite) UIView *recommendationLoadingView;
@property (nonatomic, readwrite) UIView *recommendationFrameAndTextView;
@property (nonatomic, readwrite, strong) NSString *collectionEndMessage;
@property (nonatomic, readwrite, strong) NSString *collectionTitle;
@property (nonatomic, readwrite, strong) NSDateFormatter *dateFormatter;
- (void)cacheCarousel;
@end

@implementation ATArtManager
@synthesize currentArtObject = _currentArtObject;

+(ATArtManager*)sharedManager
{
    static ATArtManager* _theManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theManager = [[ATArtManager alloc] init];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:_theManager
                                                 selector:@selector(artworkDeletedFromCollection:)
                                                     name:kArtworkDidGetDeletedFromCollection object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:_theManager
                                                 selector:@selector(artworkAddedToCollection:)
                                                     name:kArtworkDidGetAddedToCollection object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:_theManager
                                                 selector:@selector(artworkPreviewDismissed:)
                                                     name:kDidTapOnArtworkBackground object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:_theManager selector:@selector(didStartFirstTimeDirectionsTutorial) name:kdidStartFirstTimeDirectionsTutorialNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:_theManager selector:@selector(didRetrieveAdditionalArtworkForArtistIDs:) name:kdidRetrieveAdditionalArtworkForArtistIDsNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:_theManager selector:@selector(didUpdateCarousel:) name:kdidUpdateCarouselNotification object:nil];
        
    });
    return _theManager;
}

- (id)init
{
    if (self = [super init]) {
        //For now default to two artObjects
        _firstTimeEnlargingAndSaving = YES;
        _distanceType = ATArtworkDistanceTypeMedium;
        _collectionType = ATCollectionTypeRecommendations;
        _collectionEndMessage = @"This is the end of our recommendations for this wall";
        _collectionTitle = @"Recommendations";
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [_dateFormatter setLocale:locale];
    }
    return  self;
}


- (NSArray*)artCarousel
{
    return self.suggestedArtwork;
}

- (void)didUpdateCarousel:(NSNotification*)note
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.collectionType] forKey:@"collectionType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cacheCarousel
{
    NSMutableArray *carouselArray = [[NSMutableArray alloc] init];
    for (id artworkObject in self.suggestedArtwork) {
        if ([artworkObject isKindOfClass:[Artwork class]]) {
            Artwork *artwork = (Artwork*)artworkObject;
            NSURL *moIDURL = [[artwork objectID] URIRepresentation];
            NSString *moIDString = [moIDURL absoluteString];
            [carouselArray addObject:moIDString];
        } else {
            ATInactiveArtworkProxy *artworkProxy = (ATInactiveArtworkProxy*)artworkObject;
            SearchableArtistProfile *artistProfile = artworkProxy.artistProfile;
            NSURL *moIDURL = [[artistProfile objectID] URIRepresentation];
            NSDictionary *inactiveArtwork = [[NSDictionary alloc] initWithObjectsAndKeys:[moIDURL absoluteString], @"artistProfileObjectIdURLString", nil];
            [carouselArray addObject:inactiveArtwork];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:carouselArray forKey:@"cachedCarousel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadCarouselCache
{
    NSPersistentStoreCoordinator *persistentStoreCoord = [[RKObjectManager sharedManager] managedObjectStore].persistentStoreCoordinator;
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    NSArray *carouselCacheArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"cachedCarousel"];
    NSMutableArray *cachedCarousel = [[NSMutableArray alloc] init];
    for (id object in carouselCacheArray) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *objectURIString = (NSString*)object;
            NSURL *objectURI = [[NSURL alloc] initWithString:objectURIString];
            NSManagedObjectID *moID = [persistentStoreCoord managedObjectIDForURIRepresentation:objectURI];
            NSManagedObject *myManagedObject = [ctx objectWithID:moID];
            [cachedCarousel addObject:myManagedObject];
        } else {
            //Its an NSDictionary
            NSDictionary *objectDict = (NSDictionary*)object;
            NSString *objectURLString = [objectDict objectForKey:@"artistProfileObjectIdURLString"];
            NSURL *artistProfileURL = [[NSURL alloc] initWithString:objectURLString];
            NSManagedObjectID *artistProfileObjectID = [persistentStoreCoord managedObjectIDForURIRepresentation:artistProfileURL];
            NSManagedObject *apObject = [ctx objectWithID:artistProfileObjectID];
            SearchableArtistProfile *artistProfile = (SearchableArtistProfile*)apObject;
            ATInactiveArtworkProxy *proxy = [[ATInactiveArtworkProxy alloc] init];
            [proxy setArtistProfile:artistProfile];
            [cachedCarousel addObject:proxy];
        }
    }
    self.suggestedArtwork = cachedCarousel;
}

- (void)updateArtistProfiles
{
     [SearchableArtistProfile loadArtistProfilesWithOffset:[NSNumber numberWithInt:0]];
    
//    [ATTransientArtistProfile artistProfilesWithBlock:^(NSArray *profiles, NSError *error){
//        if (error) {
//            NSLog( @"Error: %@", [error localizedDescription]);
//        } else {
//            NSLog( @"profiles %@", profiles);
//            for (ATTransientArtistProfile *artistProfile in profiles) {
//                
//                NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
//                
//                NSFetchRequest *request = [[NSFetchRequest alloc] init];
//                
//                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"profileID = %d", [artistProfile.profileID intValue]];
//                
//                NSLog(@"looking for profileID %d", [artistProfile.profileID intValue]);
//                
//                [request setPredicate:predicate];
//                
//                NSEntityDescription *entityDescription = [NSEntityDescription
//                                                          entityForName:@"SearchableArtistProfile" inManagedObjectContext:ctx];
//                
//                [request setEntity:entityDescription];
//                
//                NSArray *array = [ctx executeFetchRequest:request error:&error];
//                SearchableArtistProfile *profile = nil;
//                if (array == nil)
//                {
//                    
//                    // Deal with error...
//                } else {
//                    profile = [array lastObject];
//                }
//                if (profile != nil) {
//                    NSLog( @"For artist: %@ %@", artistProfile.firstName, artistProfile.lastName);
//                    for (ATTransientArtwork *artwork in artistProfile.artworks) {
//                        
//                        Artwork *newArtwork = [Artwork uniqueArtworkWithArtworkID:artwork.artworkID inManagedObjectContext:ctx];
//                        
//                        [newArtwork setTitle:artwork.title];
//                        [newArtwork setArtworkDescription:artwork.artworkDescription];
//                        [newArtwork setColumns:artwork.columns];
//                        [newArtwork setDepth:artwork.depth];
//                        [newArtwork setGenre:artwork.genre];
//                        [newArtwork setHeight:artwork.height];
//                        [newArtwork setIpadDisplayImgURL:artwork.ipadDisplayImgURL];
//                        [newArtwork setKeyword:artwork.keyword];
//                        [newArtwork setMedium:artwork.medium];
//                        [newArtwork setPreviewImgURL:artwork.previewImgURL];
//                        [newArtwork setPrice:artwork.price];
//                        [newArtwork setRecommended:artwork.recommended];
//                        [newArtwork setRows:artwork.rows];
//                        [newArtwork setShippingRequirements:artwork.shippingRequirements];
//                        [newArtwork setState:artwork.state];
//                        [newArtwork setThumbImgURL:artwork.thumbImgURL];
//                        [newArtwork setUserID:artwork.userID];
//                        [newArtwork setWeight:artwork.weight];
//                        [newArtwork setWidth:artwork.width];
//                        [newArtwork setInCollection:artwork.inCollection];
//                        [newArtwork setInCart:artwork.inCart];
//                        [newArtwork setAddedToCartAt:artwork.addedToCartAt];
//                        [newArtwork setDelegate:artwork.delegate];
//                        [newArtwork setNumInOtherCollections:artwork.numInOtherCollections];
//                        [newArtwork setSoldAt:artwork.soldAt];
//                        
//                        [profile addArtworksObject:newArtwork];
//                        
//                        NSLog(@"title: %@", newArtwork.title);
//                        
//                    }
//                    NSError *err;
//                    if (![ctx saveToPersistentStore:&err]) {
//                        NSLog(@"Error %@", [err localizedDescription]);
//                    } else {
//                        NSLog(@"all saved!");
//                    }
//                    
//                }
//                
//            }
//        }
//    }];
    
}

- (void)initializeArtistProfileObjectIDs
{
    NSManagedObjectContext *ctx = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    
    NSSortDescriptor *sortByFirstName = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortByFirstName]];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"SearchableArtistProfile" inManagedObjectContext:ctx];
    
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"Whats up with this?!");
    } else {
        NSMutableArray *profilesArray = [[NSMutableArray alloc] init];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            SearchableArtistProfile *profile = (SearchableArtistProfile*)obj;
            [profilesArray addObject:profile.objectID];
        }];
        self.artistDirectoryObjectIDs = [NSArray arrayWithArray:profilesArray];
        
        for (NSManagedObjectID *artistProfileObjectID in self.artistDirectoryObjectIDs) {
            SearchableArtistProfile *artistProfile = (SearchableArtistProfile*)[ctx objectWithID:artistProfileObjectID];
            //NSLog(@"Artist: %@ %@ id:%d", artistProfile.firstName, artistProfile.lastName, [artistProfile.profileID intValue]);
        }
        
    }
    
}

- (void)setCurrentArtObject:(Artwork *)currentArtObject
{
    if (currentArtObject != _currentArtObject) {
        _currentArtObject = nil;
        _currentArtObject = currentArtObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidChangeCurrentArtworkNotification object:nil];
    }
}

- (void)trackArtObject:(Artwork*)artObject
{
    NSDictionary *artPiecesSeen = [[NSUserDefaults standardUserDefaults] objectForKey:kTrackedArtPiecesKey];
    
    NSMutableDictionary *mutableArtPiecesSeen;
    NSString *artObjectKey = [NSString stringWithFormat:@"%@",artObject.artworkID];
    if (artPiecesSeen != nil) {
        mutableArtPiecesSeen = [[NSMutableDictionary alloc] initWithDictionary:artPiecesSeen];
        [mutableArtPiecesSeen setValue:[NSNumber numberWithInt:1] forKey:artObjectKey];
        
        [[ATUserManager sharedManager] incrementWithFlurryKey:kFlurryNumUniquePiecesSeen];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidIncrementArtCounter object:nil];
    } else {
        mutableArtPiecesSeen = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1], artObjectKey, nil];
    }
    [[NSUserDefaults standardUserDefaults] setObject:mutableArtPiecesSeen forKey:kTrackedArtPiecesKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    NSDictionary *artDict = [[NSUserDefaults standardUserDefaults] objectForKey:kTrackedArtPiecesKey];
    
    //NSLog(@"tracked art:%@", artDict);
    
    //NSLog(@"you've seen %d pieces of art so far", [[artDict allKeys] count]);
}

- (int)trackedPieces
{
    NSDictionary *artDict = [[NSUserDefaults standardUserDefaults] objectForKey:kTrackedArtPiecesKey];
    return [[artDict allKeys] count];
}

- (void)addArtworkToCollection:(Artwork*)artwork
{
    artwork.inCollection = [NSNumber numberWithBool:YES];
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    
    NSError *executeError = nil;
    if(![ctx saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    } else {
        PFObject *favoriteArtwork = [PFObject objectWithClassName:@"Favorite"];
        favoriteArtwork[@"artworkID"] = artwork.artworkID;
        if ([[ATUserManager sharedManager] userID] != nil) {
            favoriteArtwork[@"profileID"] = [[ATUserManager sharedManager] userID];
        }
        if ([[ATUserManager sharedManager] userType] != nil) {
            favoriteArtwork[@"userType"] = [[ATUserManager sharedManager] userType];
        }
        if ([[ATUserManager sharedManager] fullName] != nil) {
            favoriteArtwork[@"userName"] = [[ATUserManager sharedManager] fullName];
        }
        
        [favoriteArtwork saveInBackground];
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:artwork, @"artObject", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kArtworkDidGetAddedToCollection object:nil userInfo:dict];
    }
}

- (void)removeArtObjectFromCollection:(Artwork*)artObject
{
    artObject.inCollection = [NSNumber numberWithBool:NO];
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;

    
    NSError *executeError = nil;
    if(![ctx saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }
}


- (NSArray*)collectionArray
{
    NSError *error;
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Artwork" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inCollection == YES"];
    
    [request setPredicate:predicate];
    
    //NSSortDescriptor *sortBySlotIndex = [[NSSortDescriptor alloc] initWithKey:@"slotIndex" ascending:YES];
    
    //[request setSortDescriptors:[NSArray arrayWithObject:sortBySlotIndex]];
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if (array == nil)
    {
        
        // Deal with error...
    } else {
       
    }
    
    return array;
}


- (NSArray*)cartOnly
{
    NSError *error;
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Artwork" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"inCart == YES && inCollection == NO"];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"addedToCartAt" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if (array == nil)
    {
        
        // Deal with error...
    } else {
       
    }
    
    return array;
}

- (NSArray*)cart
{
    NSError *error;
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Artwork" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"inCart == YES"];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"addedToCartAt" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if (array == nil)
    {
        
        // Deal with error...
    } else {
       
    }
    
    return array;
}

- (void)emptyCart
{
    NSError *error;
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Artwork" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"inCart == YES"];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"addedToCartAt" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    
    for (Artwork *artwork in array) {
        artwork.inCart = [NSNumber numberWithBool:NO];
    }
    
    NSError *executeError = nil;
    if(![ctx saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }
}

- (void)emptyPurchasedArtwork
{
    self.artworkAlreadyPurchased = nil;
}

- (void)moveCartToPurchasedArtwork
{
    self.artworkAlreadyPurchased = [self cart];
}

- (void)moveCartToSold
{
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    for (Artwork *artwork in [self cart]) {
        artwork.soldAt = [NSDate date];
    }
    
    NSError *executeError = nil;
    if(![ctx saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }
    
    
}

- (Artwork*)findAnyArtworkForArtistProfile:(SearchableArtistProfile*)artistProfile
{
    NSManagedObjectContext *ctx = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"profileID = %d", [artistProfile.profileID intValue]];
    
//    NSLog(@"looking for profileID %d", [artistProfile.profileID intValue]);
    
    [request setPredicate:predicate];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SearchableArtistProfile" inManagedObjectContext:ctx];
    
    [request setEntity:entityDescription];
    //
    NSError *error;
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    
    if ([array count] > 0) {
        SearchableArtistProfile *currentProfile = [array objectAtIndex:0];
        //NSLog(@"artist actually has %d pieces of art", [currentProfile.artworks count]);
        if ([currentProfile.artworks count] > 0) {
            return (Artwork*)[currentProfile.artworks anyObject];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSManagedObjectID*)nextProfileObjectIDFrom:(SearchableArtistProfile*)artistProfile;
{
    int index = [self.artistDirectoryObjectIDs indexOfObject:artistProfile.objectID];
    
//    NSLog(@"artistProfiles is %@", artistProfile);
    
    if (index == [self.artistDirectoryObjectIDs count] - 1) {
        return nil;
    } else {
        return (NSManagedObjectID*)[self.artistDirectoryObjectIDs objectAtIndex:index + 1];
    }
}

- (NSManagedObjectID*)previousProfileObjectIDFrom:(SearchableArtistProfile*)artistProfile
{
    int index = [self.artistDirectoryObjectIDs indexOfObject:artistProfile.objectID];
    if (index == 0) {
        return nil;
    } else {
        return (NSManagedObjectID*)[self.artistDirectoryObjectIDs objectAtIndex:index - 1];
    }
}

- (NSArray*)purchasedArtwork
{
    return self.artworkAlreadyPurchased;
}

- (CGFloat)cartTotal
{
    return [self carttotalWithoutDiscount];
}

- (CGFloat)carttotalWithoutDiscount
{
    CGFloat total = 0.0f;
    for (Artwork *artObject in [self cart]) {
        total = total + [artObject.price floatValue];
    }
    return total;
}

- (CGFloat)cartTotalFormattedForBP
{
    return [self cartTotal] * 100;
}


- (NSString*)sizeSelection
{
    switch (self.sizeType) {
        case ATSizeButtonTypeSmall:
            return @"small";
            break;
        case ATSizeButtonTypeMedium:
            return @"medium";
            break;
        default:
            return @"large";
            break;
    }
}

- (NSString*)distanceSelection
{
    switch (self.distanceType) {
        case ATDistanceButtonTypeNear:
            return @"near";
            break;
        case ATDistanceButtonTypeMid:
            return @"mid";
            break;
        default:
            return @"far";
            break;
    }
}


- (void)deleteSuggestedArtwork
{
    NSError *error;
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Artwork" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSMutableArray *artistIDsInCollection = [[NSMutableArray alloc] init];
    
    NSPredicate *predicate;
    if (self.collectionArray.count > 0) {
        for (Artwork *artwork in self.collectionArray) {
            [artistIDsInCollection addObject:artwork.userID];
        }
        predicate = [NSPredicate predicateWithFormat:@"inCollection == NO AND NOT(userID IN $ARTIST_IDS)"];
        predicate = [predicate predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObject:artistIDsInCollection forKey:@"ARTIST_IDS"]];

    } else {
        predicate = [NSPredicate predicateWithFormat:@"inCollection == NO"];
    }

    
    [request setPredicate:predicate];
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if (array == nil)
    {
        
        // Deal with error...
    } else {
        if ([array count] > 0) {
            for (Artwork *artworkToDelete in array) {
                [ctx deleteObject:artworkToDelete];
            }
        }
    }
    
    NSError *executeError = nil;
    if(![ctx saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }
    //NSUInteger count = [ctx countForEntityForName:@"Artwork" predicate:nil error:nil];
    
}


- (void)replaceCurrentArtworkWithArtwork:(Artwork*)artwork
{
    //[self.suggestedArtwork removeObject:self.currentArtObject];
    [self setCurrentArtObject:artwork];
#ifdef DEBUG
    //NSLog(@"About to insertObject in suggested artwork with count %d", [self.suggestedArtwork count]);
#endif
    if (self.currentIndex >= [self.suggestedArtwork count]) {
        [self.suggestedArtwork addObject:artwork];
        self.currentIndex = [self.suggestedArtwork count] - 1;
    } else {
        //[self.suggestedArtwork insertObject:artwork atIndex:self.currentIndex];
        [self.suggestedArtwork replaceObjectAtIndex:self.currentIndex withObject:artwork];
    }
    [self cacheCarousel];
#ifdef DEBUG
    //NSLog(@"there is now %d pieces of suggested artwork with current index %d", self.suggestedArtwork.count, self.currentIndex);
#endif
}

- (void)replaceArtworkAtIndex:(NSUInteger)index withArtwork:(Artwork*)artwork
{
    [self.suggestedArtwork replaceObjectAtIndex:index withObject:artwork];
}

- (void)additionalArtworkByArtistWithID:(NSNumber*)artistID completionBlock:(void (^)(NSArray *artwork, NSError *error))block
{
    NSError *error;
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Artwork" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %d", [artistID intValue]];
    
    [request setPredicate:predicate];
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if (array == nil)
    {
        if (block) {
            block([NSArray array], error);
        }
        // Deal with error...
    } else {
        if ([array count] > 0) {
            if (block) {
                block(array, nil);
            }
        }
    }
}

- (void)retrieveSuggestedArtworkWithBackgroundImage:(UIImage*)image completionBlock:(void (^)(BOOL finished))completion
{
    //Create the color array here.
    NSArray *colorArray = [image averageColorArray];
    
    NSMutableDictionary *hueDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *rgbDictionary = [NSMutableDictionary dictionary];
    for (UIColor *rgbColor in colorArray) {
        CGFloat hue;
        CGFloat saturation;
        CGFloat brightness;
        CGFloat alpha;
        
        CGFloat red;
        CGFloat green;
        CGFloat blue;
        if([rgbColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]){
            //do what ever you want to do if values are valid
            //Create hue dictionary
            NSString *hueKey = [NSString stringWithFormat:@"%d", (int)(hue * 360)];
            if (![hueDictionary objectForKey:hueKey]) {
                [hueDictionary setObject:[NSNumber numberWithInt:1] forKey:hueKey];
            } else {
                int numHues = [[hueDictionary objectForKey:hueKey] intValue] + 1;
                [hueDictionary setObject:[NSNumber numberWithInt:numHues] forKey:hueKey];
            }
            
            //Create rgb dictionary
            if ([rgbColor getRed:&red green:&green blue:&blue alpha:&alpha]) {
                NSString *rgbKey = [NSString stringWithFormat:@"%1.2f,%1.2f, %1.2f, %1.2f", red, green, blue, alpha];
                if (![rgbDictionary objectForKey:rgbKey]) {
                    [rgbDictionary setObject:[NSNumber numberWithInt:1] forKey:rgbKey];
                } else {
                    int numHues = [[hueDictionary objectForKey:rgbKey] intValue] + 1;
                    [rgbDictionary setObject:[NSNumber numberWithInt:numHues] forKey:rgbKey];
                }
            }
        } else {
            //what needs to be done, if converting failed?
            //Some default values? raising an exception? return?
        }
    }
    
    NSArray *sortedHues = [hueDictionary keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
//    //NSLog(@"hue array count is %d", [hueArray count]);
    
//    //NSLog(@"hue dictionary is %@", hueDictionary);
//    //NSLog(@"sorted keys is %@", sortedHues);
    
//    //NSLog(@"rgb dictionary %@", rgbDictionary);
    
    NSRange theRange;
    
    theRange.location = 0;
    theRange.length = MIN(MAX_HUES, [sortedHues count]);
    
    NSArray *hueArray = [sortedHues subarrayWithRange:theRange];
    
    UIColor *averageColor = [self.wallImage mergedColor];
    
    CGFloat red, green, blue, alpha, hue, saturation, luminosity;
    
    [averageColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    RGB2HSL(red, green, blue, &hue, &saturation, &luminosity);
    
    int averageHue = hue * 360;
    
    //NSLog(@"the AVERAGE HUE IS %d", averageHue);
    
    
    [ATArtObject suggestedArtworkForHueArray:hueArray withAverageHue:averageHue distance:self.distanceSelection size:self.sizeSelection lat:self.lat lng:self.lng limit:MAX_ART_IDS_REQUESTED inBatchesOf:NUM_BATCHES withBlock:^(NSArray *initialArtworkArray, NSArray *fullArtworkArray, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            //NSLog(@"Dang Error: %@", [error localizedDescription]);
            
            NSDictionary *errorDict = [[NSDictionary alloc] initWithObjectsAndKeys:error, kServerErrorKey, nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidGetSuggestedArtworkFailure object:nil userInfo:errorDict];
            
        } else {
            [[ATTrackingManager sharedManager] trackEvent:FL_GET_RECOMMENDED_ARTWORK_SUCCESSFUL];
            //On every request the ATArtManager will only ever get the first batch of artwork -- additional artwork will have to be loaded later
            self.suggestedArtwork = [NSMutableArray arrayWithArray:initialArtworkArray];
            [[ATArtManager sharedManager] setCollectionType:ATCollectionTypeRecommendations];
            
            NSDictionary *indexInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:0], @"firstIndex", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidUpdateCarouselNotification object:nil userInfo:indexInfo];
            [self cacheCarousel];
            //This is directly from the API 
            self.fullArtwork = fullArtworkArray;
            self.artworkBatchesLoaded = 1;
            //NSLog(@"self.suggestedArtwork %@", self.suggestedArtwork);
            
            NSMutableArray *artistIds = [[NSMutableArray alloc] init];
            for (Artwork *artObject in self.suggestedArtwork) {
                Artist *artist = artObject.artist;
                if (![artistIds containsObject:artist.userID]) {
                    [artistIds addObject:artist.userID];
                }
            }
            [self retrieveAdditionalArtworkForArtistIds:artistIds];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidGetSuggestedArtworkSuccessfullyNotification object:nil];
        }
        BOOL finished = YES;
        if (completion) {
            completion(finished);
        }
    }];
    
}

- (void)retrieveSuggestedArtworkFromCacheWithBlock:(void (^)(BOOL finished, NSError *error))completion
{
    NSError *error;
    [self retrieveSuggestedArtworkFromCache];
    BOOL finished = YES;
    if (completion) {
        completion(finished, error);
    }
}

- (void)retrieveSuggestedArtworkFromCache
{
    NSArray *carouselCacheArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"cachedCarousel"];
    
    if (carouselCacheArray != nil) {
        [self loadCarouselCache];
    } else {
        NSError *error;
        
        NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
        
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:@"Artwork" inManagedObjectContext:ctx];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recommended == YES"];
        
        [request setPredicate:predicate];
        
        NSArray *array = [ctx executeFetchRequest:request error:&error];
        if (array == nil)
        {
            
            // Deal with error...
        } else {
            if ([array count] > 0) {
                self.suggestedArtwork = [[NSMutableArray alloc] initWithArray:array];
                [self cacheCarousel];
            }
        }

    }
    
}

- (void)didRetrieveAdditionalArtworkForArtistIDs:(NSNotification*)note
{
    if (self.loadingArtworkForChosenArtist) {
        self.loadingArtworkForChosenArtist = NO;
        
        NSDictionary *userInfo = [note userInfo];
        
        NSManagedObjectID *objectID = [userInfo objectForKey:@"objectID"];
        NSArray *queryArtistProfileObjectIDs = [userInfo objectForKey:@"queryArtistProfileObjectIDs"];
        
        [self reloadCarouselWithArtworkForArtistProfileObjectID:objectID withArtistObjectIDs:queryArtistProfileObjectIDs];
    }
    
    //if just appending more artists to the carousel do an update - not a reload
    if (self.appendingCarouselWithMoreArtists) {
        self.appendingCarouselWithMoreArtists = NO;
        
        NSDictionary *userInfo = [note userInfo];
        
        NSManagedObjectID *objectID = [userInfo objectForKey:@"objectID"];
        NSArray *queryArtistProfileObjectIDs = [userInfo objectForKey:@"queryArtistProfileObjectIDs"];
        
        
        dispatch_queue_t updateCarouselQueue;
        updateCarouselQueue = dispatch_queue_create("com.arttwo50.updateCarousel", NULL);
        
        dispatch_async(updateCarouselQueue, ^{
            printf("updateCarouselQueue.\n");
            [self updateCarouselWithArtworkWithArtistObjectIDs:queryArtistProfileObjectIDs appending:YES];
        });
    } else if (self.prependingCarouselWithMoreArtists) {
        self.prependingCarouselWithMoreArtists = NO;
        
        NSDictionary *userInfo = [note userInfo];
        
        NSManagedObjectID *objectID = [userInfo objectForKey:@"objectID"];
        NSArray *queryArtistProfileObjectIDs = [userInfo objectForKey:@"queryArtistProfileObjectIDs"];
        
        [self updateCarouselWithArtworkWithArtistObjectIDs:queryArtistProfileObjectIDs appending:NO];
    }
}

- (void)queryArtworkForArtistIDsArray:(NSArray*)queryArtistProfileObjectIDs aroundArtistWithObjectID:(NSManagedObjectID*)objectID
{
    //Convert objectIDs to profileIDs
    NSMutableArray *artistIDs = [[NSMutableArray alloc] init];
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;

    //NSLog(@"queryArtistProfileObjectIDs %@", queryArtistProfileObjectIDs);
    
    
    [self.queryArtistProfileObjectIDs enumerateObjectsUsingBlock:^(NSManagedObjectID *objID, NSUInteger idx, BOOL *stop){
        SearchableArtistProfile *artistProfile = (SearchableArtistProfile*)[ctx objectWithID:objID];
        //NSLog(@"Find user id for artist %@ %@", artistProfile.firstName, artistProfile.lastName);
        if (artistProfile.artist.userID != nil) {
            //NSLog(@"Found user id for artist %@ %@ id: %d", artistProfile.firstName, artistProfile.lastName, [artistProfile.artist.userID intValue]);
             [artistIDs addObject:artistProfile.artist.userID];
        } else {
            NSLog(@"somethings up with user id for artist %@ %@", artistProfile.firstName, artistProfile.lastName);
        }
    }];
    
    self.loadingArtworkForChosenArtist = YES;
    
    [self retrieveAdditionalArtworkForArtistIds:artistIDs];

}

- (void)loadArtworkForArtistProfilewithObjectID:(NSManagedObjectID*)objectID
{
    self.collectionType = ATCollectionTypeArtists;
    
    self.artistProfileObjectID = objectID;
    self.queryArtistProfileObjectIDs = [self additionalArtistObjectIDsStartingFromObjectID:objectID forward:NEXT_ARTISTS_RANGE backward:PREV_ARTISTS_RANGE];
    
    [self queryArtworkForArtistIDsArray:self.queryArtistProfileObjectIDs aroundArtistWithObjectID:objectID];
}

- (void)reloadCarouselWithArtworkForArtistProfileObjectID:(NSManagedObjectID*)objectID withArtistObjectIDs:(NSArray*)queryArtistProfileObjectIDs
{
    NSMutableArray *artworkArray = [[NSMutableArray alloc] init];
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    int objectIndex = 0;
    int mainProfileObjectIndex;
    for (NSManagedObjectID *profileObjectID in queryArtistProfileObjectIDs) {
        SearchableArtistProfile *artistProfile = (SearchableArtistProfile*)[ctx objectWithID:profileObjectID];
        Artwork *artwork = [artistProfile.artworks anyObject];
        //This may be an issue
        if (artwork != nil) {
            [artworkArray addObject:artwork];
        } else {
            ATInactiveArtworkProxy *proxy = [[ATInactiveArtworkProxy alloc] init];
            [proxy setArtistProfile:artistProfile];
            [artworkArray addObject:proxy];
        }
        if ([profileObjectID isEqual:objectID]) {
            mainProfileObjectIndex = objectIndex;
        }
        objectIndex++;
        
    }
    self.suggestedArtwork = [[NSMutableArray alloc] initWithArray:artworkArray];
    [self cacheCarousel];
    NSUInteger artworkCount = [ctx countForEntityForName:@"Artwork" predicate:nil error:nil];
    NSUInteger profileCount = [ctx countForEntityForName:@"SearchableArtistProfile" predicate:nil error:nil];
//    NSLog(@"%d pieces of artwork: %d artist profiles", artworkCount, profileCount);
//    NSLog(@"Uploaded with %d pieces of art/artists", [self.suggestedArtwork count]);
//    NSLog(@"Uploaded with %d pieces of art/artists in artworkArray", [artworkArray count]);
    
    NSDictionary *indexInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:mainProfileObjectIndex], @"firstIndex", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidUpdateCarouselNotification object:nil userInfo:indexInfo];

}

- (void)updateCarouselWithArtworkWithArtistObjectIDs:(NSArray*)queryArtistProfileObjectIDs appending:(BOOL)appending
{
    NSMutableArray *artworkArray = [[NSMutableArray alloc] init];
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    for (NSManagedObjectID *profileObjectID in queryArtistProfileObjectIDs) {
        SearchableArtistProfile *artistProfile = (SearchableArtistProfile*)[ctx objectWithID:profileObjectID];
        //NSLog(@"adding artwork for %@ %@", artistProfile.firstName, artistProfile.lastName);
        Artwork *artwork = [artistProfile.artworks anyObject];
        if (artwork != nil) {
            [artworkArray addObject:artwork];
        } else {
            ATInactiveArtworkProxy *proxy = [[ATInactiveArtworkProxy alloc] init];
            [proxy setArtistProfile:artistProfile];
            [artworkArray addObject:proxy];
        }
    }
    
    NSDictionary *indexInfo = nil;
    
    if (appending) {
        [self.suggestedArtwork addObjectsFromArray:artworkArray];
    } else {
        indexInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:[artworkArray count]], @"updateCurrentIndexWithOffset", nil];
        [artworkArray addObjectsFromArray:self.suggestedArtwork];
        self.suggestedArtwork = artworkArray;
        
    }
    [self cacheCarousel];
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidUpdateCarouselNotification object:nil userInfo:indexInfo];
    
}

- (void)loadCarouselMetadata
{
    NSNumber *collectionType = [[NSUserDefaults standardUserDefaults] objectForKey:@"collectionType"];
    switch ([collectionType intValue]) {
        case ATCollectionTypeRecommendations:
            self.collectionType = ATCollectionTypeRecommendations;
            break;
        case ATCollectionTypeFavorites:
            self.collectionType = ATCollectionTypeFavorites;
        case ATCollectionTypeArtists:
            self.collectionType = ATCollectionTypeArtists;
        default:
            break;
    }
    
}

- (void)setCollectionType:(ATCollectionType)collectionType
{
    _collectionType = collectionType;
    switch (collectionType) {
        case ATCollectionTypeArtists:
            self.collectionTitle = @"Artists";
            break;
        case ATCollectionTypeFavorites:
            self.collectionTitle = @"Favorites";
            break;
        case ATCollectionTypeRecommendations:
            self.collectionTitle = @"Recommendations";
            break;
        default:
            self.collectionTitle = @"Unknown";
            break;
    }
}

- (void)loadRecommendations
{
    self.collectionType = ATCollectionTypeRecommendations;
    
    NSError *error;
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Artwork" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recommended == YES"];
    
    [request setPredicate:predicate];
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if (array == nil)
    {
        
        // Deal with error...
    } else {
        if ([array count] > 0) {
            self.suggestedArtwork = [[NSMutableArray alloc] initWithArray:array];
            [self cacheCarousel];
            
            NSDictionary *indexInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:0], @"firstIndex", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidUpdateCarouselNotification object:nil userInfo:indexInfo];
        } else {
            UIAlertView *noFavoritesAlert = [[UIAlertView alloc] initWithTitle:nil message:@"There are no recommendations for this wall." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [noFavoritesAlert show];
        }
    }

}


- (void)loadFavorites
{
    self.collectionType = ATCollectionTypeFavorites;
    NSError *error;
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Artwork" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inCollection == YES"];
    
    [request setPredicate:predicate];
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if (array == nil)
    {
        
        // Deal with error...
    } else {
        if ([array count] > 0) {
            self.suggestedArtwork = [[NSMutableArray alloc] initWithArray:array];
            [self cacheCarousel];
            
            NSDictionary *indexInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:0], @"firstIndex", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidUpdateCarouselNotification object:nil userInfo:indexInfo];
        } else {
            UIAlertView *noFavoritesAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Favorite the pieces you like and see them again here." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [noFavoritesAlert show];
        }
    }
    
}

- (NSUInteger)collectionCount
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inCollection == YES"];

    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    return [ctx countForEntityForName:@"Artwork" predicate:predicate error:nil];
}

- (NSUInteger)cartOnlyCount
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inCollection == NO && inCart == YES"];
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    return [ctx countForEntityForName:@"Artwork" predicate:predicate error:nil];
}

- (NSString*)collectionIDs
{
    NSError *error;
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Artwork" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inCollection == YES"];
    [request setPredicate:predicate];
    
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    
    if (array == nil)
    {
        
        // Deal with error...
    } else {
      
    }
    
    NSString *arrayString = @"";
    
    if ([array count] > 0) {
        for (Artwork *artwork in array) {
            arrayString = [arrayString stringByAppendingFormat:@" %d", artwork.artworkID.intValue];
        }
        return arrayString;
    } else {
        return arrayString;
    }
}




- (void)retrieveAdditionalArtworkForArtistIds:(NSArray*)artistIds
{
    
    [Artwork additionalArtworkForArtistIds:artistIds withBlock:^(NSArray *additionalArtwork, NSArray *nextBatch, NSError *error) {
        NSManagedObjectContext *ctx = [[RKObjectManager sharedManager].managedObjectStore newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:YES];
        //NSManagedObjectContext *ctx = [[RKObjectManager sharedManager].managedObjectStore mainQueueManagedObjectContext];
//        NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//        NSPersistentStoreCoordinator *coord = [[RKObjectManager sharedManager] managedObjectStore].persistentStoreCoordinator;
//        [ctx setPersistentStoreCoordinator:coord];
        if (error) {
            NSLog(@"Unable to get additional artwork");
        } else {
            //Additional artwork for artists
            for (NSDictionary *artworkDict in additionalArtwork) {
                NSDictionary *innerArtworkDict = [artworkDict objectForKey:@"artwork"];
                Artwork *newArtwork = [Artwork uniqueArtworkWithDictionary:innerArtworkDict forContext:ctx];
            }
        }
        
        NSError *executeError = nil;
        if(![ctx saveToPersistentStore:&executeError]) {
            NSLog(@"Failed to save to data store error:%@", [executeError localizedDescription]);
        } else {
            if ([nextBatch count] > 0) {
                [self retrieveAdditionalArtworkForArtistIds:nextBatch];
            } else {
                [self performSelector:@selector(postDidRetrieveOnMainThread) withObject:nil];
            }
        }
        
    }];
}

- (void)postDidRetrieveOnMainThread
{
    [self performSelectorOnMainThread:@selector(postDidRetrieveAdditionalArtworkWithDictionary) withObject:nil waitUntilDone:YES];
}

- (void)postDidRetrieveAdditionalArtworkWithDictionary
{
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:self.artistProfileObjectID, @"objectID", self.queryArtistProfileObjectIDs, @"queryArtistProfileObjectIDs", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidRetrieveAdditionalArtworkForArtistIDsNotification object:nil userInfo:userInfo];
}


- (void)addArtObjectToCart:(Artwork*)artwork
{
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    artwork.inCart = [NSNumber numberWithBool:YES];
    artwork.addedToCartAt = [NSDate date];
    
    
    NSError *executeError = nil;
    if(![ctx saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    } else {
        if ([artwork isEqual:self.currentArtObject]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidAddCurrentArtworkToCartNotification object:nil];
        }
    }
    
}

- (void)removeArtObjectFromCart:(Artwork*)artwork
{
  
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    artwork.inCart = [NSNumber numberWithBool:NO];
    artwork.addedToCartAt = nil;
    
    NSError *executeError = nil;
    if(![ctx saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }
}

- (void)artworkDeletedFromCollection:(NSNotification*)notif
{
//    //NSLog(@"Deleted artwork - notification userInfo: %@", [notif userInfo]);
//    //NSLog(@"Here should add the passed in object to the painting array");
}



- (void)artworkAddedToCollection:(NSNotification*)notif
{
    [[ATTrackingManager sharedManager] trackEvent:FL_ART_ADDED_TO_COLLECTION];
    //Remove the artwork from the suggestedartwork collection

    
}

- (void)removeArtworkFromSuggestedArtwork:(Artwork*)artwork
{
    for (Artwork *suggestedArtwork in self.suggestedArtwork) {
        if (suggestedArtwork.objectID == artwork.objectID) {
            [self.suggestedArtwork removeObject:suggestedArtwork];
            break;
        }
    }
    [self cacheCarousel];
}

- (void)removeArtworkFromSuggestedArtworkByArtist:(Artist*)thisArtist
{
    for (Artwork *artwork in self.suggestedArtwork) {
        Artist *artist = artwork.artist;
        if ([thisArtist.userID isEqualToNumber:artist.userID]) {
            [self.suggestedArtwork removeObjectsInArray:[NSArray arrayWithObject:artwork]];
            break;
        }
    }
    [self cacheCarousel];
   
}

- (void)artworkPreviewDismissed:(NSNotification*)notif
{
    //NSLog(@"Doing nothing here");
}

- (void)addArtObjectToSuggestedArtwork:(Artwork*)artObject
{
    [self.suggestedArtwork addObject:artObject];
    [self cacheCarousel];
}

- (void)insertArtObject:(Artwork*)artObject atIndex:(int)index
{
    [self.suggestedArtwork insertObject:artObject atIndex:index];
    [self cacheCarousel];
}


- (void)restartCheckoutTimer
{
    if (self.checkoutTimer != nil) {
        [self.checkoutTimer invalidate];
        self.checkoutTimer = nil;
    }
    self.secondsLeftToCompleteCheckout = CHECKOUT_TIMER;
    self.checkoutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                     target:self
                                                   selector:@selector(decrementCheckoutTimer:)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)resetTimer
{
    if (self.checkoutTimer != nil) {
        [self.checkoutTimer invalidate];
        self.checkoutTimer = nil;
    }
    self.secondsLeftToCompleteCheckout = CHECKOUT_TIMER;
}

- (void)stopTimer
{
    [self.checkoutTimer invalidate];
    self.checkoutTimer = nil;
    
    self.secondsLeftToCompleteCheckout = CHECKOUT_TIMER;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidStopCheckoutTimerNotification object:nil];
}

- (void)decrementCheckoutTimer:(NSTimer*)timer
{
    if (self.secondsLeftToCompleteCheckout > 0) {
        self.secondsLeftToCompleteCheckout = self.secondsLeftToCompleteCheckout - 1;
    } else {
        self.secondsLeftToCompleteCheckout = 0;
    }
    NSDictionary *timerDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:self.secondsLeftToCompleteCheckout], @"checkoutTimer", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTimerDidFireNotification object:self userInfo:timerDict];
//        self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d",secondsLeftToCompleteCheckout/60,secondsLeftToCompleteCheckout - ((secondsLeftToCompleteCheckout/60)*60)];
//        //NSLog(@"timer seconds left: %i", secondsLeftToCompleteCheckout);
    
}
- (CGFloat)pixelsPerInch
{
    switch (self.distanceType) {
        case ATArtworkDistanceTypeClose:
            return ((12.617f + 12.59559090909090909f)/2) * IPAD_SQUISH_FACTOR;
            break;
        case ATArtworkDistanceTypeMedium:
            return ((8.54905882352941F + 8.63190909090909f)/2) * IPAD_SQUISH_FACTOR;
        default:
            return ((6.56088235294118 + 6.539363636363636363f)/2) * IPAD_SQUISH_FACTOR;
            break;
    }
}


- (UIImage*)hangItImageForArtObject:(Artwork*)artObject
{
    return [UIImage imageWithContentsOfFile:[self shareImageFilePathForArtObject:artObject]];
}

- (NSString*)shareImageFilePathForArtObject:(Artwork*)artObject
{
    NSString *imageName = [NSString stringWithFormat:@"hangit_%d.jpg", [artObject.artworkID intValue]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSLog(@"Looking for image at path: %@", [documentsDirectory stringByAppendingPathComponent:imageName]);
    return [documentsDirectory stringByAppendingPathComponent:imageName];
}


- (void)saveShareImage:(UIImage*)sharedImage forArtObject:(Artwork*)artObject
{
    if (sharedImage) {
        NSString *sharedImageFileName = [NSString stringWithFormat:SHARE_IMAGE_FILENAME_FORMAT,[artObject.artworkID intValue]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:sharedImageFileName];
        NSData* data = UIImageJPEGRepresentation(sharedImage, 1.0f);
        [data writeToFile:path atomically:YES];
        //UIImageWriteToSavedPhotosAlbum(sharedImage, nil, nil, nil);
    } else {
        //NSLog(@"Error in saving the share image");
    }
}


- (void)deleteShareImageforArtObject:(Artwork*)artObject
{
    
    // For error information
    NSError *error;
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    // Attempt to delete the file at filePath2
    if ([fileMgr removeItemAtPath:[self shareImageFilePathForArtObject:artObject] error:&error] != YES) {
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    }
    
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    
    // Show contents of Documents directory
//    NSLog(@"Documents directory: %@",[fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
}

- (UIImage*)artworkSplashImage
{
    static UIImage* _artworkSplashImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        int r = arc4random_uniform(NUM_SPLASH_ARTWORK) + 1;
        _artworkSplashImage = [UIImage imageNamed:[NSString stringWithFormat:@"launch_art_%03d.jpg", r]];
    });
    return _artworkSplashImage;
}

- (BOOL)firstTimeUser
{
    //Duh. some boolean stored in NSUserDefaults
    return ![[NSUserDefaults standardUserDefaults] boolForKey:kNonFirstTimeUserKey];
}

- (void)setFirstTimeUser:(BOOL)firstTimeUser
{
    [[NSUserDefaults standardUserDefaults] setBool:!firstTimeUser forKey:kNonFirstTimeUserKey];
}




- (BOOL)firstTimeAddedToCollection
{
    return ![[NSUserDefaults standardUserDefaults] boolForKey:kFirstTimeAddedToCollectionKey];
}

- (void)setFirstTimeAddedToCollection:(BOOL)firstTimeAddedToCollection
{
    //Set the NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setBool:firstTimeAddedToCollection forKey:kFirstTimeAddedToCollectionKey];
}

- (BOOL)allBatchesLoaded
{
    return YES;//self.artworkBatchesLoaded == NUM_BATCHES;
}

- (void)showArtRecommendationHUDForView:(UIView *)view withText:(NSString*)message
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    
    self.recommendationLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    [self.recommendationLoadingView setBackgroundColor:[UIColor clearColor]];
    [self.recommendationLoadingView setUserInteractionEnabled:NO];
    
    self.recommendationFrameAndTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    [self.recommendationFrameAndTextView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *overlayView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
    [self.recommendationLoadingView addSubview:overlayView];
    
//    int randomNum = arc4random() % 6 + 1;
    
//    if ([self firstTimeUser]) {
        UILabel *firstTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(363.0f, 195.0f, 299.0f, 61.0f)];
        NSString *recommendingText = message;
        [firstTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [firstTimeLabel setText:recommendingText];
        [firstTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        [firstTimeLabel setTextColor:[UIColor whiteColor]];
        [firstTimeLabel setShadowColor:[UIColor blackColor]];
        [firstTimeLabel setShadowOffset:CGSizeMake(0, -1)];
        [firstTimeLabel setNumberOfLines:0];
        [firstTimeLabel setBackgroundColor:[UIColor clearColor]];
        [self.recommendationFrameAndTextView addSubview:firstTimeLabel];
//    } else {
//        UIImageView *loadingMessageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d_loading_message.png", randomNum]]];
//        [self.recommendationLoadingView addSubview:loadingMessageView];
//    }
    
    

    
    UIImageView *pictureFrame = [[UIImageView alloc] initWithFrame:CGRectMake(482.0f, 149.0f, 60.0f, 40.0f)];
    pictureFrame.animationImages = [[NSArray alloc] initWithObjects:
                                    [UIImage imageNamed:@"frame_1-01.png"],
                                    [UIImage imageNamed:@"frame_2-01.png"],
                                    [UIImage imageNamed:@"frame_3-01.png"],
                                    [UIImage imageNamed:@"frame_4-01.png"],
                                    [UIImage imageNamed:@"frame_5-01.png"],
                                    [UIImage imageNamed:@"frame_6-01.png"],
                                    [UIImage imageNamed:@"frame_7-01.png"],
                                    [UIImage imageNamed:@"frame_8-01.png"],
                                    [UIImage imageNamed:@"frame_9-01.png"],
                                    [UIImage imageNamed:@"frame_10-01.png"],
                                    [UIImage imageNamed:@"frame_11-01.png"],
                                    [UIImage imageNamed:@"frame_12-01.png"],
                                    [UIImage imageNamed:@"frame_13-01.png"],
                                    [UIImage imageNamed:@"frame_14-01.png"],
                                    [UIImage imageNamed:@"frame_15-01.png"],
                                    [UIImage imageNamed:@"frame_16-01.png"],
                                    [UIImage imageNamed:@"frame_17-01.png"],
                                    [UIImage imageNamed:@"frame_18-01.png"],
                                    [UIImage imageNamed:@"frame_19-01.png"],
                                    [UIImage imageNamed:@"frame_20-01.png"],
                                    [UIImage imageNamed:@"frame_21-01.png"],
                                    [UIImage imageNamed:@"frame_22-01.png"],
                                    [UIImage imageNamed:@"frame_23-01.png"],
                                    [UIImage imageNamed:@"frame_24-01.png"],
                                    [UIImage imageNamed:@"frame_25-01.png"],
                                    [UIImage imageNamed:@"frame_26-01.png"],
                                    [UIImage imageNamed:@"frame_27-01.png"],
                                    [UIImage imageNamed:@"frame_28-01.png"],
                                    [UIImage imageNamed:@"frame_29-01.png"],
                                    [UIImage imageNamed:@"frame_30-01.png"],
                                    [UIImage imageNamed:@"frame_31-01.png"],
                                    [UIImage imageNamed:@"frame_32-01.png"],
                                    [UIImage imageNamed:@"frame_33-01.png"],
                                    [UIImage imageNamed:@"frame_34-01.png"],
                                    [UIImage imageNamed:@"frame_35-01.png"],
                                    [UIImage imageNamed:@"frame_36-01.png"],
                                    [UIImage imageNamed:@"frame_37-01.png"],
                                    [UIImage imageNamed:@"frame_38-01.png"],
                                    [UIImage imageNamed:@"frame_39-01.png"],
                                    [UIImage imageNamed:@"frame_40-01.png"],
                                    nil];
    
    pictureFrame.animationDuration = 1.75;
    // repeat the annimation forever
    pictureFrame.animationRepeatCount = 0;
    // start animating
    [pictureFrame startAnimating];
    
    [self.recommendationFrameAndTextView addSubview:pictureFrame];

    
//    if (![self firstTimeUser]) {
//        UIButton *takeTourButton = [[UIButton alloc] initWithFrame:CGRectMake(467.0f, 647.0f, 91.0f, 39.0f)];
//        [takeTourButton setImage:[UIImage imageNamed:@"btn_take_tour.png"] forState:UIControlStateNormal];
//        [takeTourButton addTarget:self action:@selector(showFirstTimeDirections) forControlEvents:UIControlEventTouchUpInside];
//        [self.recommendationFrameAndTextView addSubview:takeTourButton];
//    }
    
    [self.recommendationLoadingView addSubview:self.recommendationFrameAndTextView];
    
    [view addSubview:self.recommendationLoadingView];
    
}

- (void)showFirstTimeDirections
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseTakeTourNotification object:nil];
}

- (void)didStartFirstTimeDirectionsTutorial
{
    [self.recommendationFrameAndTextView removeFromSuperview];
}

- (void)hideArtRecommendationView
{
    [self.recommendationLoadingView removeFromSuperview];
}


- (int)batchSize
{
    return self.maxArtworkThreshold/self.artworkBatches;
}

-(int) maxArtworkThreshold
{
    return MAX_ART_IDS_REQUESTED;
}

-(int) artworkBatches
{
    return NUM_BATCHES;
}

- (NSString*)lastDistanceChosen
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int distance = [userDefaults integerForKey:klastDistanceChosenKey];
    
    switch (distance) {
        case 0:
            return @"8";
            break;
        case 1:
            return @"12";
        default:
            return @"16";
            break;
    }
}

- (NSString*)lastSizeChosen
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int size = [userDefaults integerForKey:klastSizeChosenKey];
    
    switch (size) {
        case 0:
            return @"small";
            break;
        case 1:
            return @"medium";
        default:
            return @"large";
            break;
    }
}

- (UIImage*)croppedImageForArtworkAtSlotIndex:(NSUInteger)index
{
    switch (index) {
        case 1:
            return self.artwork1 != nil ? [self.artwork1 croppedImage] : [UIImage imageNamed:@"collection_spot.png"];
            break;
        case 2:
            return self.artwork2 != nil ? [self.artwork2 croppedImage] : [UIImage imageNamed:@"collection_spot.png"];
            break;
        case 3:
            return self.artwork3 != nil ? [self.artwork3 croppedImage] : [UIImage imageNamed:@"collection_spot.png"];
            break;
        case 4:
            return self.artwork4 != nil ? [self.artwork4 croppedImage] : [UIImage imageNamed:@"collection_spot.png"];
            break;
        case 5:
            return self.artwork5 != nil ? [self.artwork5 croppedImage] : [UIImage imageNamed:@"collection_spot.png"];
            break;
        case 6:
            return self.artwork6 != nil ? [self.artwork6 croppedImage] : [UIImage imageNamed:@"collection_spot.png"];
            break;
        default:
            return nil;
            break;
    }
}

- (void)updateCollectionStatus
{
    for (Artwork *artwork in self.collectionArray) {
        [artwork updateStatus];
    }
}

- (UIImage*)savedBackgroundImage
{
    return [UIImage imageWithContentsOfFile:[self savedBackgroundImageFilePath]];
}

- (NSString*)savedBackgroundImageFilePath
{
    NSString *imageName = [NSString stringWithFormat:DEFAULT_BACKGROUND_IMAGE_FILENAME];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"Looking for image at path: %@", [documentsDirectory stringByAppendingPathComponent:imageName]);
    return [documentsDirectory stringByAppendingPathComponent:imageName];
}

- (void)saveBackgroundImageForDefault:(UIImage*)sharedImage
{
    if (sharedImage) {
        NSString *sharedImageFileName = DEFAULT_BACKGROUND_IMAGE_FILENAME;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:sharedImageFileName];
        //        //NSLog(@"imagePath is %@", path);
        NSData* data = UIImageJPEGRepresentation(sharedImage, 1.0f);
        [data writeToFile:path atomically:YES];
        //UIImageWriteToSavedPhotosAlbum(sharedImage, nil, nil, nil);
    } else {
        NSLog(@"Error in saving the default background image");
    }
}


- (void)cacheBackgroundImage:(UIImage *)image
{    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:[image imageOrientation] forKey:kBackgroundImageOrientationKey];

    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog(@"Failed to cache image data to disk");
    }
    
}

- (UIImage*)cachedBackgroundImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    
    UIImage *imageFromPath = [UIImage imageWithContentsOfFile:imagePath];
    
    UIImageOrientation imageOrientation = [[NSUserDefaults standardUserDefaults] integerForKey:kBackgroundImageOrientationKey];
    
    return [[UIImage alloc] initWithCGImage: imageFromPath.CGImage scale:1.0 orientation:imageOrientation];
}


- (void)loadAdditionalArtistsFromObjectID:(NSManagedObjectID*)objectID forward:(int)forwardRange backward:(int)backwardRange
{
    
    self.queryArtistProfileObjectIDs = [self additionalArtistObjectIDsStartingFromObjectID:objectID forward:forwardRange backward:backwardRange];
    self.artistProfileObjectID = objectID;
    //Convert objectIDs to profileIDs
    NSMutableArray *artistIDs = [[NSMutableArray alloc] init];
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    //NSManagedObjectContext *ctx = [[RKObjectManager sharedManager].managedObjectStore newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType tracksChanges:YES];
    NSLog(@"starting queryArtistProfileObjectIDs");
    [self.queryArtistProfileObjectIDs enumerateObjectsUsingBlock:^(NSManagedObjectID *objID, NSUInteger idx, BOOL *stop){
        SearchableArtistProfile *artistProfile = (SearchableArtistProfile*)[ctx objectWithID:objID];
        //NSLog(@"Trying to load artist %@ %@", artistProfile.firstName, artistProfile.lastName);
        if (artistProfile.artist.userID != nil) {
            //NSLog(@"Did load artist %@ %@", artistProfile.firstName, artistProfile.lastName);

            [artistIDs addObject:artistProfile.artist.userID];
        } else {
            
        }

    }];

    if (forwardRange == 0) {
        self.prependingCarouselWithMoreArtists = YES;
    } else {
        self.appendingCarouselWithMoreArtists = YES;
    }
    [self retrieveAdditionalArtworkForArtistIds:artistIDs];
}

- (NSArray*)additionalArtistObjectIDsStartingFromObjectID:(NSManagedObjectID*)objectID forward:(int)forwardRange backward:(int)backwardRange
{
    //Query this artist as well as the previous 10 and the next 40
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    SearchableArtistProfile *artistProfile = (SearchableArtistProfile*)[ctx objectWithID:objectID];
    int index = [self.artistDirectoryObjectIDs indexOfObject:objectID];
    //NSLog(@"querying the artworks for %@ %@ who's index is %d", artistProfile.firstName, artistProfile.lastName, index);
    NSRange prevRange;
    prevRange.location = MAX(index - backwardRange, 0);
    prevRange.length = MIN(index, backwardRange);
    NSMutableArray *queryArtistProfileObjectIDs = [[NSMutableArray alloc] init];
    [queryArtistProfileObjectIDs addObjectsFromArray:[self.artistDirectoryObjectIDs subarrayWithRange:prevRange]];
    NSRange nextRange;
    nextRange.location = index;
    nextRange.length = MIN(forwardRange, [self.artistDirectoryObjectIDs count] - index);
    [queryArtistProfileObjectIDs addObjectsFromArray:[self.artistDirectoryObjectIDs subarrayWithRange:nextRange]];
    //NSLog(@"prevArray %@", queryArtistProfileObjectIDs);
    //NSLog(@"all artists %@", self.artistDirectoryObjectIDs);
    //NSLog(@"the queryArtistProfileObjectIDs array is %d", [queryArtistProfileObjectIDs count]);
    return [[NSArray alloc] initWithArray:queryArtistProfileObjectIDs];
}


#pragma mark
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.lng = currentLocation.coordinate.longitude;
        self.lat = currentLocation.coordinate.latitude;
    }
}


@end
