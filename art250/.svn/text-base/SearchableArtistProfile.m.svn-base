//
//  SearchableArtistProfile.m
//  art250
//
//  Created by Winfred Raguini on 12/12/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "SearchableArtistProfile.h"
#import "Artist.h"
#import "Artwork.h"
#import "ATDateHelper.h"


@implementation SearchableArtistProfile

@dynamic city;
@dynamic firstName;
@dynamic lastName;
@dynamic profileID;
@dynamic state;
@dynamic address1;
@dynamic address2;
@dynamic artistStatement;
@dynamic profileImageURL;
@dynamic profilePreviewURL;
@dynamic profileThumbURL;
@dynamic artist;
@dynamic artworks;


+ (void)artistProfilesSinceLastSyncDate:(NSDate*)lastSyncDate offset:(NSNumber*)offset withBlock:(void (^)(NSArray *profiles, NSError *error))block
{
    NSNumber *limit = [NSNumber numberWithInt:50];
    NSDateComponents *lastSyncDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:lastSyncDate];
    NSDictionary *lastSyncDateParams = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInteger:[lastSyncDateComponents month]], @"month", [NSNumber numberWithInteger:[lastSyncDateComponents day]], @"day", [NSNumber numberWithInteger:[lastSyncDateComponents year]], @"year", nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: lastSyncDateParams, @"lastSyncDate", limit, @"limit", offset, @"offset", nil];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/artist_profiles/query.json" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
        NSLog(@"mappingResults %@", [mappingResult array]);
        
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

+ (SearchableArtistProfile*)lastSearchableArtistProfile
{
    NSError *error;
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"SearchableArtistProfile" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"profileID" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    [request setFetchLimit:1];
    
    
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if ([array count] > 0) {
        return [array lastObject];
    } else {
        return nil;
    }
}

+ (int)queryBatch
{
    return 50;
}


+ (void)loadArtistProfilesWithOffset:(NSNumber*)offset
{
    NSNumber *lastProfileID = 0;
    SearchableArtistProfile *lastSearchableArtistProfile = [self lastSearchableArtistProfile];
    if (lastSearchableArtistProfile) {
        lastProfileID = lastSearchableArtistProfile.profileID;
    }
    
    NSDate *lastSyncDate = [[NSUserDefaults standardUserDefaults] objectForKey:klastArtistProfileSyncDateKey];
    if (lastSyncDate == nil) {
        //Set it to the date the seed data was created
        lastSyncDate = [ATDateHelper parseDateString:@"Jan 14, 2014"];
    }
    
    [SearchableArtistProfile artistProfilesSinceLastSyncDate:lastSyncDate offset:offset withBlock:^(NSArray *profiles, NSError *error){
        if (error) {
            NSLog(@"There was an error updating the artist directory.");
            NSLog( @"Error: %@", [error localizedDescription]);
        } else {
            
            NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
            
            NSError *executeError = nil;
            if(![ctx saveToPersistentStore:&executeError]) {
                NSLog(@"Failed to save to data store");
            }
            
            if ([profiles count] == [SearchableArtistProfile queryBatch]) {
                int nextOffset = [offset intValue] + [profiles count];
                [self loadArtistProfilesWithOffset:[NSNumber numberWithInt:nextOffset]];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:klastArtistProfileSyncDateKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }];
}


+ (SearchableArtistProfile *)uniqueArtistProfileWithProfileId:(NSNumber *)profileID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *searchableArtistProfileResults;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //NSLog(@"profile ID is %d", [profileID intValue]);
    
    request.entity = [NSEntityDescription entityForName:@"SearchableArtistProfile" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"profileID = %@", profileID];
    request.fetchLimit = 1;
    NSError *executeFetchError = nil;
    searchableArtistProfileResults = [context executeFetchRequest:request error:&executeFetchError];
    
    SearchableArtistProfile *searchableArtistProfile;
    
    if (executeFetchError) {
        NSLog(@"[%@, %@] error looking up user with id: %i with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [profileID intValue], [executeFetchError localizedDescription]);
    } else if ([searchableArtistProfileResults count] == 0) {
        searchableArtistProfile = [NSEntityDescription insertNewObjectForEntityForName:@"SearchableArtistProfile"
                                                                inManagedObjectContext:context];
        searchableArtistProfile.profileID = profileID;
    } else {
        searchableArtistProfile = [searchableArtistProfileResults objectAtIndex:0];
    }
    
    return searchableArtistProfile;
}

+ (NSArray*)artistProfilesBeginningWith:(NSString*)beginningLetter
{
    NSError *error;
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"SearchableArtistProfile" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"firstName", beginningLetter];
    
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortByFirstName = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortByFirstName]];
    
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"what??");
        // Deal with error...
    } else {
        //NSLog(@"There are %d artist profiles beginning with %@", [array count], beginningLetter);
    }
    return array;
}

+ (NSArray*)artistProfilesWithSearchString:(NSString*)searchText
{
    NSError *error;
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"SearchableArtistProfile" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@ || %K CONTAINS[cd] %@", @"firstName", searchText, @"lastName", searchText];
    
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortByFirstName = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortByFirstName]];
    
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"what??");
        // Deal with error...
    } else {
        NSLog(@"There are %d artist profiles that have the text %@", [array count], searchText);
    }
    return array;
}

+ (NSUInteger)countOfArtistProfilesBeginningWith:(NSString*)beginningLetter
{
    
    NSError *error;
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@ ", @"firstName", beginningLetter];
    
    [request setPredicate:predicate];
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"SearchableArtistProfile" inManagedObjectContext:ctx];
    
    [request setEntity:entityDescription];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSUInteger count = [ctx countForFetchRequest:request error:&error];
    if(count == NSNotFound) {
        //Handle error
        NSLog(@"Error: %@", [error localizedDescription]);
        return 0;
    } else {
        return count;
    }
}

- (NSString*)fullName
{
    NSString *firstName;
    if (self.firstName != nil) {
        firstName = self.firstName;
    } else {
        firstName = @"";
    }
    NSString *lastName;
    if (self.lastName != nil) {
        lastName = self.lastName;
    } else {
        lastName = @"";
    }
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

- (NSString*)locationString
{
    NSString *city;
    if (self.city != nil) {
        city = self.city;
    } else {
        city = @"";
    }
    NSString *state;
    if (self.state != nil) {
        state = self.state;
    } else {
        state = @"";
    }
    return [NSString stringWithFormat:@"%@, %@", city, state];
}

- (BOOL)hasUploadedProfileImage
{
    return self.profileImageURL != nil;
}


@end
