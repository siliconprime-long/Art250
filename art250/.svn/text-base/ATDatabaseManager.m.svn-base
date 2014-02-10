//
//  ATDatabaseManager.m
//  art250
//
//  Created by Winfred Raguini on 12/7/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATDatabaseManager.h"
#import "ArtistProfile.h"
#import "Artist.h"
#import "SearchableArtistProfile.h"
#import "ATTransientArtistProfile.h"
#import "ATTransientArtwork.h"
#import "ATTransientArtist.h"
#import "Artwork.h"

@interface ATDatabaseManager ()
- (BOOL)didImportArtistProfiles;
- (void)importArtistProfiles;
@end
@implementation ATDatabaseManager
+ (ATDatabaseManager*)sharedManager
{
    static ATDatabaseManager* _sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ATDatabaseManager alloc] init];
        
    });
    return _sharedManager;
}

- (RKObjectManager*)objectManager
{
    #ifdef DEBUG
        //return [RKObjectManager managerWithBaseURL:[NSURL URLWithString:PROD_BASE_URL]];
        return [RKObjectManager managerWithBaseURL:[NSURL URLWithString:STAGING_BASE_URL]];
        //return [RKObjectManager managerWithBaseURL:[NSURL URLWithString:DEV_BASE_URL]];
    #else
        return [RKObjectManager managerWithBaseURL:[NSURL URLWithString:PROD_BASE_URL]];
    #endif
}

- (void)initializeDB
{
    
    NSError *error = nil;
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CoreData" ofType:@"momd"]];
    // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Initialize the Core Data stack
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Rhino.sqlite"];
    //NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"RhinoDB" ofType:@"sqlite"];
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    
    NSPersistentStore __unused *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:options error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
    
    [managedObjectStore createManagedObjectContexts];
    
    // Set the default store shared instance
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    // Configure the object manager

    RKObjectManager *objectManager = [self objectManager];
    
    objectManager.managedObjectStore = managedObjectStore;
    
    [RKObjectManager setSharedManager:objectManager];
    
    
    [objectManager addResponseDescriptor:[Artwork rkResponseDescriptor]];
    
    
    RKEntityMapping *artistMapping = [RKEntityMapping mappingForEntityForName:@"Artist" inManagedObjectStore:managedObjectStore];
    [artistMapping addAttributeMappingsFromDictionary:@{
                                                        @"email":                              @"email",
                                                        @"id":                                 @"userID",
                                                        @"artworkCount":                       @"artworkCount"}];
    
    [[Artwork entityMapping] addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"artist" toKeyPath:@"artist" withMapping:artistMapping]];
    
    RKEntityMapping *profileMapping = [RKEntityMapping mappingForEntityForName:@"ArtistProfile" inManagedObjectStore:managedObjectStore];
    [profileMapping addAttributeMappingsFromDictionary:@{
                                                         @"address1":                                  @"address1",
                                                         @"address2":                                  @"address2",
                                                         @"artist_statement":                          @"artistStatement",
                                                         @"city":                                      @"city",
                                                         @"state":                                     @"state",
                                                         @"first_name":                                @"firstName",
                                                         @"last_name":                                 @"lastName",
                                                         @"profile_image.profile_image.url":           @"profileImageURL",
                                                         @"profile_image.profile_image.preview.url":   @"profilePreviewURL",
                                                         @"profile_image.profile_image.thumb.url":     @"profileThumbURL",
                                                         @"id":                                        @"profileID"
                                                         }];
    
    [profileMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"artist" toKeyPath:@"artist" withMapping:artistMapping]];
    
    
    [artistMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user_profile" toKeyPath:@"profile" withMapping:profileMapping]];
    
    
    RKEntityMapping *searchableArtistProfileMapping = [RKEntityMapping mappingForEntityForName:@"SearchableArtistProfile" inManagedObjectStore:managedObjectStore];
    
    [searchableArtistProfileMapping addAttributeMappingsFromDictionary:@{
                                                         @"address1":                                  @"address1",
                                                         @"address2":                                  @"address2",
                                                         @"artist_statement":                          @"artistStatement",
                                                         @"city":                                      @"city",
                                                         @"state":                                     @"state",
                                                         @"first_name":                                @"firstName",
                                                         @"last_name":                                 @"lastName",
                                                         @"profile_image.profile_image.url":           @"profileImageURL",
                                                         @"profile_image.profile_image.preview.url":   @"profilePreviewURL",
                                                         @"profile_image.profile_image.thumb.url":     @"profileThumbURL",
                                                         @"id":                                        @"profileID"
                                                         }];
    
    [searchableArtistProfileMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"artist" toKeyPath:@"artist" withMapping:artistMapping]];
    
    RKResponseDescriptor *searchableArtistProfileResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:profileMapping method:RKRequestMethodGET pathPattern:@"/artist_profiles/query.json" keyPath:@"artist_profile" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:searchableArtistProfileResponseDescriptor];
    
    //RKResponseDescriptor *artistResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:artworkMapping method:RKRequestMethodGET pathPattern:@"/v2/artworks/query.json" keyPath:@"artwork.artist" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    //[objectManager addResponseDescriptor:artistResponseDescriptor];
    
    RKObjectMapping *transientArtistMapping = [RKObjectMapping mappingForClass:[ATTransientArtist class]];
    [transientArtistMapping addAttributeMappingsFromDictionary:@{
                                                                 @"email":                              @"email",
                                                                 @"id":                                 @"userID",
                                                                 @"artworkCount":                       @"artworkCount"}];
    
    
    RKObjectMapping *transientArtistProfileMapping = [RKObjectMapping mappingForClass:[ATTransientArtistProfile class]];
    [transientArtistProfileMapping addAttributeMappingsFromDictionary:@{
                                                        @"address1":                                  @"address1",
                                                        @"address2":                                  @"address2",
                                                        @"artist_statement":                          @"artistStatement",
                                                        @"city":                                      @"city",
                                                        @"state":                                     @"state",
                                                        @"first_name":                                @"firstName",
                                                        @"last_name":                                 @"lastName",
                                                        @"profile_image.profile_image.url":           @"profileImageURL",
                                                        @"profile_image.profile_image.preview.url":   @"profilePreviewURL",
                                                        @"profile_image.profile_image.thumb.url":     @"profileThumbURL",
                                                        @"id":                                        @"profileID"
                                                        }];
    
    
    
    RKObjectMapping *transientArtworkMapping = [RKObjectMapping mappingForClass:[ATTransientArtwork class]];
    [transientArtworkMapping addAttributeMappingsFromDictionary:@{
                                                                        @"algorithm_used":                                @"algorithmUsed",
                                                                        @"description":                                   @"artworkDescription",
                                                                        @"id":                                            @"artworkID",
                                                                        @"artwork_image.artwork_image.url":               @"artworkImgURL",
                                                                        @"columns":                                       @"columns",
                                                                        @"depth":                                         @"depth",
                                                                        @"genre_list":                                         @"genre",
                                                                        @"height":                                        @"height",
                                                                        @"artwork_image.artwork_image.ipad_display.url":  @"ipadDisplayImgURL",
                                                                        @"keyword":                                       @"keyword",
                                                                        @"medium_list":                                        @"medium",
                                                                        @"artwork_image.artwork_image.preview.url":       @"previewImgURL",
                                                                        @"price":                                         @"price",
                                                                        @"recommended":                                   @"recommended",
                                                                        @"rows":                                          @"rows",
                                                                        @"shippingRequirements":                          @"shipping_requirements",
                                                                        @"artwork_image.artwork_image.thumb.url":         @"thumbImgURL",
                                                                        @"title":                                         @"title",
                                                                        @"user_id":                                       @"userID",
                                                                        @"weight":                                        @"weight",
                                                                        @"width":                                         @"width",
                                                                        @"state":                                         @"state",
                                                                        @"default_num_in_collections":                    @"numInOtherCollections",
                                                                        @"sold_at":                                       @"soldAt"
                                                                        }];
    
    [transientArtworkMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"artist.user_profile" toKeyPath:@"searchableProfile" withMapping:transientArtistProfileMapping]];
    [transientArtworkMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"artist" toKeyPath:@"artist" withMapping:transientArtistMapping]];
    
    [transientArtistProfileMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"artworks" toKeyPath:@"artworks" withMapping:transientArtworkMapping]];
    
    RKResponseDescriptor *transientProfileAndArtworkDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:transientArtistProfileMapping method:RKRequestMethodGET pathPattern:@"/artist_profiles/query_artwork.json" keyPath:@"artist_profile" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    [objectManager addResponseDescriptor:transientProfileAndArtworkDescriptor];
    
    //For getting additional work for an artist
    RKResponseDescriptor *additionalArtworkResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:transientArtworkMapping method:RKRequestMethodGET pathPattern:@"/artworks/query_artists.json" keyPath:@"artwork" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    //[objectManager addResponseDescriptor:additionalArtworkResponseDescriptor];
    
    
    self.mainThreadContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    if (![self didImportArtistProfiles]) {
        [self importArtistProfiles];
    }
    
}

//- (void)mergeChangesFromContextDidSaveNotification:(NSNotification*)note
//{
//    NSManagedObjectContext *ctx = [note object];
//    
//    if ([_mainThreadContext isEqual:ctx]) {
//        return;
//    }
//    
//    //dispatch_sync(dispatch_get_main_queue(), ^{
//    NSLog(@"this got saved on another context %@", note);
//        [self.mainThreadContext mergeChangesFromContextDidSaveNotification:note];
//    //});
//}

- (BOOL)didImportArtistProfiles
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kdidImportArtistProfiles];
}

- (void)importArtistProfiles
{
    
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    NSPersistentStoreCoordinator *coord = [[RKObjectManager sharedManager].managedObjectStore persistentStoreCoordinator];
    [ctx setPersistentStoreCoordinator:coord];
    
    NSError* err = nil;
    
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"ArtistProfiles" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    
    if (data) {
        NSArray *artistProfiles = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:&err];
        //NSLog(@"Imported Artist Profiles: %@", artistProfiles);
        
        [artistProfiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *profile = [obj objectForKey:@"artist_profile"];
            
            NSNumber *profileID = [profile objectForKey:@"id"];
            
            
            SearchableArtistProfile *artistProfile = [SearchableArtistProfile uniqueArtistProfileWithProfileId:profileID inManagedObjectContext:ctx];
            
            if ([profile objectForKey:@"city"] != [NSNull null]) {
                artistProfile.city = [profile objectForKey:@"city"];
            }
            
            if ([profile objectForKey:@"state"] != [NSNull null]) {
                artistProfile.state = [profile objectForKey:@"state"];
            }
            
            if ([profile objectForKey:@"first_name"] != [NSNull null]) {
                artistProfile.firstName = [profile objectForKey:@"first_name"];
            }
            
            if ([profile objectForKey:@"last_name"] != [NSNull null]) {
                artistProfile.lastName = [profile objectForKey:@"last_name"];
            }
            
//            NSLog(@"Going to save %@", artistProfile.lastName);
            
            NSDictionary *artistDict = [profile objectForKey:@"artist"];
            Artist *artistDetails = [Artist uniqueArtistWithUserId:[artistDict objectForKey:@"id"] inManagedObjectContext:ctx];
            artistDetails.email = [artistDict objectForKey:@"email"];
            artistProfile.artist = artistDetails;
        }];
        
        NSError *error;
        
        if (![ctx saveToPersistentStore:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kdidImportArtistProfiles];
            NSUInteger postCount = [ctx countForEntityForName:@"SearchableArtistProfile" predicate:nil error:nil];
            
//            NSLog(@"There are %d artist profiles afterwards", postCount);
            
            //    NSArray * artistProfiless = [[ATDatabaseManager sharedManager] artistProfilesBeginningWith:@"Andrew"];
            //
            //
            //    for (ArtistProfile *artistProfile in artistProfiless){
            //        NSLog( @"name: %@ %@ profileID: %d objectID: %@", artistProfile.firstName, artistProfile.lastName, [artistProfile.profileID intValue], artistProfile.objectID);
            //    }
        }
    }
}


@end
