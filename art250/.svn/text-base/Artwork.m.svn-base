//
//  Artwork.m
//  art250
//
//  Created by Winfred Raguini on 8/16/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "Artwork.h"
#import "Artist.h"
#import "UIImage+WRExtensions.h"
#import "ATAPIClient.h" 
#import "ATTransientArtistProfile.h"
#import "ATTransientArtist.h"
#import "SearchableArtistProfile.h"
#import "ATArtManager.h"

#define SLOTVIEW_WIDTH 128.0f
#define SLOTVIEW_HEIGHT 98.0f
#define MAX_ARTIST_QUERY_BATCH 50

#define SUGGESTED_ARTWORK_QUOTIENT 1

@interface Artwork ()

@end

@implementation Artwork

@dynamic algorithmUsed;
@dynamic artworkDescription;
@dynamic artworkID;
@dynamic artworkImgURL;
@dynamic columns;
@dynamic depth;
@dynamic genre;
@dynamic height;
@dynamic keyword;
@dynamic medium;
@dynamic ipadDisplayImgURL;
@dynamic previewImgURL;
@dynamic thumbImgURL;
@dynamic price;
@dynamic recommended;
@dynamic rows;
@dynamic shippingRequirements;
@dynamic title;
@dynamic userID;
@dynamic weight;
@dynamic width;
@dynamic artist;
@dynamic state;
@dynamic inCollection;
@dynamic inCart;
@dynamic numInOtherCollections;
@dynamic addedToCartAt;
@dynamic soldAt;
@synthesize delegate = _delegate;
@synthesize croppedImage = _croppedImage;
@dynamic searchableProfile;

+ (Artwork *)uniqueArtworkWithArtworkID:(NSNumber *)artworkID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *artworkArray;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"Artwork" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"artworkID = %@", artworkID];
    NSError *executeFetchError = nil;
    artworkArray = [context executeFetchRequest:request error:&executeFetchError];
    Artwork *artwork;
    if (executeFetchError) {
        NSLog(@"[%@, %@] error looking up user with id: %i with error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [artworkID intValue], [executeFetchError localizedDescription]);
    } else if ([artworkArray count] == 0) {
        //This is new - add to the artist
        artwork = [NSEntityDescription insertNewObjectForEntityForName:@"Artwork"
                                                                inManagedObjectContext:context];
        artwork.artworkID = artworkID;
    } else {
        artwork = [artworkArray objectAtIndex:0];
    }
    
    return artwork;
}

+ (Artwork*)uniqueArtworkWithDictionary:(NSDictionary *)artworkInfoDict forContext:(NSManagedObjectContext*)ctx
{
    Artwork *suggestedArtwork = [Artwork uniqueArtworkWithArtworkID:[artworkInfoDict objectForKey:@"id"] inManagedObjectContext:ctx];
    
    if ([artworkInfoDict objectForKey:@"algorithm_used"] != [NSNull null]) {
        [suggestedArtwork setAlgorithmUsed:[artworkInfoDict objectForKey:@"algorithm_used"]];
    }
    if ([artworkInfoDict objectForKey:@"columns"] != [NSNull null]) {
        [suggestedArtwork setColumns:[artworkInfoDict objectForKey:@"columns"]];
    }
    if ([artworkInfoDict objectForKey:@"default_num_in_collections"] != [NSNull null]) {
        [suggestedArtwork setNumInOtherCollections:[artworkInfoDict objectForKey:@"default_num_in_collections"]];
    }
    if ([artworkInfoDict objectForKey:@"depth"] != [NSNull null]) {
        [suggestedArtwork setDepth:[artworkInfoDict objectForKey:@"depth"]];
    }
    if ([artworkInfoDict objectForKey:@"description"] != [NSNull null]) {
        [suggestedArtwork setArtworkDescription:[artworkInfoDict objectForKey:@"description"]];
    }
    if ([artworkInfoDict objectForKey:@"genre"] != [NSNull null]) {
        [suggestedArtwork setGenre:[artworkInfoDict objectForKey:@"genre"]];
    }
    if ([artworkInfoDict objectForKey:@"height"] != [NSNull null]) {
        [suggestedArtwork setHeight:[artworkInfoDict objectForKey:@"height"]];
    }
    if ([artworkInfoDict objectForKey:@"keyword"] != [NSNull null]) {
        [suggestedArtwork setKeyword:[artworkInfoDict objectForKey:@"keyword"]];
    }
    if ([artworkInfoDict objectForKey:@"medium"] != [NSNull null]) {
        [suggestedArtwork setMedium:[artworkInfoDict objectForKey:@"medium"]];
    }
    if ([artworkInfoDict objectForKey:@"price"] != [NSNull null]) {
        [suggestedArtwork setPrice:[artworkInfoDict objectForKey:@"price"]];
    }
    if ([artworkInfoDict objectForKey:@"recommended"] != [NSNull null]) {
        if ([[artworkInfoDict objectForKey:@"recommended"] boolValue]) {
            [suggestedArtwork setRecommended:[NSNumber numberWithBool:YES]];
        }
    }
    if ([artworkInfoDict objectForKey:@"rows"] != [NSNull null]) {
        [suggestedArtwork setRows:[artworkInfoDict objectForKey:@"rows"]];
    }
    if ([artworkInfoDict objectForKey:@"shipping_requirements"] != [NSNull null]) {
        [suggestedArtwork setShippingRequirements:[artworkInfoDict objectForKey:@"shipping_requirements"]];
    }
    if ([artworkInfoDict objectForKey:@"sold_at"] != [NSNull null]) {
        NSString *dateString = [artworkInfoDict objectForKey:@"sold_at"];
        NSDate *soldAtDate = [[[ATArtManager sharedManager] dateFormatter] dateFromString:dateString];
        [suggestedArtwork setSoldAt:soldAtDate];
    }
    if ([artworkInfoDict objectForKey:@"state"] != [NSNull null]) {
        [suggestedArtwork setState:[artworkInfoDict objectForKey:@"state"]];
    }
    if ([artworkInfoDict objectForKey:@"title"] != [NSNull null]) {
        [suggestedArtwork setTitle:[artworkInfoDict objectForKey:@"title"]];
    }
    if ([artworkInfoDict objectForKey:@"user_id"] != [NSNull null]) {
        [suggestedArtwork setUserID:[artworkInfoDict objectForKey:@"user_id"]];
    }
    if ([artworkInfoDict objectForKey:@"weight"] != [NSNull null]) {
        [suggestedArtwork setWeight:[artworkInfoDict objectForKey:@"weight"]];
    }
    if ([artworkInfoDict objectForKey:@"width"] != [NSNull null]) {
        [suggestedArtwork setWidth:[artworkInfoDict objectForKey:@"width"]];
    }
    
    if ([artworkInfoDict objectForKey:@"artwork_image"] != [NSNull null]) {
        NSDictionary *artworkImageOuterDict = [artworkInfoDict objectForKey:@"artwork_image"];
        
        NSDictionary *artworkImageInnerDict = [artworkImageOuterDict objectForKey:@"artwork_image"];
        
        if ([artworkImageInnerDict objectForKey:@"ipad_display"] != [NSNull null]) {
            NSDictionary *ipadDisplayDict = [artworkImageInnerDict objectForKey:@"ipad_display"];
            [suggestedArtwork setIpadDisplayImgURL:[ipadDisplayDict objectForKey:@"url"]];
        }
        if ([artworkImageInnerDict objectForKey:@"preview"] != [NSNull null]) {
            NSDictionary *previewDict = [artworkImageInnerDict objectForKey:@"preview"];
            [suggestedArtwork setPreviewImgURL:[previewDict objectForKey:@"url"]];
        }
        if ([artworkImageInnerDict objectForKey:@"thumb"] != [NSNull null]) {
            NSDictionary *thumbDict = [artworkImageInnerDict objectForKey:@"thumb"];
            [suggestedArtwork setThumbImgURL:[thumbDict objectForKey:@"url"]];
        }
        
        
    }
    
    NSDictionary *artistDetailsDict = [artworkInfoDict objectForKey:@"artist"];
    
    Artist *artist = [Artist uniqueArtistWithUserId:[artistDetailsDict objectForKey:@"id"] inManagedObjectContext:ctx];
    
    if ([artistDetailsDict objectForKey:@"email"] != [NSNull null]) {
        [artist setEmail:[artistDetailsDict objectForKey:@"email"]];
    }
    if ([artistDetailsDict objectForKey:@"id"] != [NSNull null]) {
        [artist setUserID:[artistDetailsDict objectForKey:@"id"]];
        [suggestedArtwork setUserID:[artistDetailsDict objectForKey:@"id"]];
    }
    
    [suggestedArtwork setArtist:artist];
    
    NSDictionary *artistProfileDict = [artistDetailsDict objectForKey:@"user_profile"];
    
    
    
    SearchableArtistProfile *profile = [SearchableArtistProfile uniqueArtistProfileWithProfileId:[artistProfileDict objectForKey:@"id"] inManagedObjectContext:ctx];
    
    if ([artistProfileDict objectForKey:@"address1"] != [NSNull null]) {
        [profile setAddress1:[artistProfileDict objectForKey:@"address1"]];
    }
    if ([artistProfileDict objectForKey:@"address2"] != [NSNull null]) {
        [profile setAddress2:[artistProfileDict objectForKey:@"address2"]];
    }
    if ([artistProfileDict objectForKey:@"artist_statement"] != [NSNull null]) {
        [profile setArtistStatement:[artistProfileDict objectForKey:@"artist_statement"]];
    }
    if ([artistProfileDict objectForKey:@"city"] != [NSNull null]) {
        [profile setCity:[artistProfileDict objectForKey:@"city"]];
    }
    if ([artistProfileDict objectForKey:@"first_name"] != [NSNull null]) {
        [profile setFirstName:[artistProfileDict objectForKey:@"first_name"]];
    }
    if ([artistProfileDict objectForKey:@"last_name"] != [NSNull null]) {
        [profile setLastName:[artistProfileDict objectForKey:@"last_name"]];
    }
    if ([artistProfileDict objectForKey:@"state"] != [NSNull null]) {
        [profile setState:[artistProfileDict objectForKey:@"state"]];
    }
    if ([artistProfileDict objectForKey:@"profile_image"] != [NSNull null]) {
        NSDictionary *profileImageOuterDict = [artistProfileDict objectForKey:@"profile_image"];
        
        if ([profileImageOuterDict objectForKey:@"profile_image"] != [NSNull null]) {
            NSDictionary *profileImageInnerDict = [profileImageOuterDict objectForKey:@"profile_image"];
            
            if ([profileImageInnerDict objectForKey:@"preview"] != [NSNull null]) {
                NSDictionary *previewDict = [profileImageInnerDict objectForKey:@"preview"];
                [profile setProfilePreviewURL:[previewDict objectForKey:@"url"]];
            }
            if ([profileImageInnerDict objectForKey:@"thumb"] != [NSNull null]) {
                NSDictionary *thumbDict = [profileImageInnerDict objectForKey:@"thumb"];
                [profile setProfileThumbURL:[thumbDict objectForKey:@"url"]];
            }
            if ([profileImageInnerDict objectForKey:@"url"] != [NSNull null]) {
                [profile setProfileImageURL:[profileImageInnerDict objectForKey:@"url"]];
            }
            
        }
    }
    
    //NSLog(@"setting profile %@ with id %d to artwork %@", [profile fullName], [profile.profileID intValue], suggestedArtwork.title);
    
    [suggestedArtwork setSearchableProfile:profile];
    
    return suggestedArtwork;
}


+ (void)additionalArtworkForArtistIds:(NSArray*)artistIds withBlock:(void (^)(NSArray *additionalArtwork, NSArray *nextBatch, NSError *error))block
{
    //    NSLog(@"the full array of artists is %d", [artistIds count]);
    //Only do up to some max threshold and keep passing whatever hasn't been done yet in nextBatch param
    NSRange theRange;
    theRange.location = 0;
    theRange.length = MIN(MAX_ARTIST_QUERY_BATCH, [artistIds count]);
    
    NSArray *arrayOfArtistIDs = [artistIds subarrayWithRange:theRange];
    
    //    NSLog(@"making a call for %d artist IDs", [arrayOfArtistIDs count]);
    
    NSRange theRestRange;
    theRestRange.location = theRange.length;
    theRestRange.length = [artistIds count] - theRange.length;
    
    __block NSArray *nextBatchIDs = nil;
    if (theRestRange.length > 0) {
        nextBatchIDs = [artistIds subarrayWithRange:theRestRange];
    }
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: arrayOfArtistIDs, @"artist_ids", nil];
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.name.bgqueue", NULL);
    
    
    NSURLRequest *request = [[ATAPIClient sharedClient] requestWithMethod:@"GET" path:@"artworks/query_artists.json" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"JSON: %@", JSON);
//        if ([NSThread isMainThread]) {
//            NSLog(@"main thread inside json request");
//        } else {
//            NSLog(@"NOT on main thread inside json request");
//        }
        if (block) {
            block(JSON, nextBatchIDs,nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Failed with error: %@", [error localizedDescription]);
        if (block) {
            block([NSArray array], nil, error);
        }
    }];
    operation.successCallbackQueue = backgroundQueue;
    //[[ATAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
    [operation start];
    
    
    
}

+ (RKEntityMapping*)entityMapping
{
    RKEntityMapping *artworkMapping = [RKEntityMapping mappingForEntityForName:@"Artwork" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [artworkMapping addAttributeMappingsFromDictionary:@{
                                                         @"algorithm_used":                                @"algorithmUsed",
                                                         @"description":                                   @"artworkDescription",
                                                         @"id":                                            @"artworkID",
                                                         @"artwork_image.artwork_image.url":               @"artworkImgURL",
                                                         @"columns":                                       @"columns",
                                                         @"depth":                                         @"depth",
                                                         @"genre":                                         @"genre",
                                                         @"height":                                        @"height",
                                                         @"artwork_image.artwork_image.ipad_display.url":  @"ipadDisplayImgURL",
                                                         @"keyword":                                       @"keyword",
                                                         @"medium":                                        @"medium",
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
    return artworkMapping;
}

+ (RKResponseDescriptor*)rkResponseDescriptor
{
    
    //Get recommended artwork
    RKResponseDescriptor *artworkResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self entityMapping] method:RKRequestMethodGET pathPattern:@"/v2/artworks/query.json" keyPath:@"artwork" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    return artworkResponseDescriptor;
}

- (id)thumbImgURL
{
    NSString *thumbImgURLString = (NSString*)[self primitiveValueForKey:@"thumbImgURL"];
    thumbImgURLString = [thumbImgURLString stringByReplacingOccurrencesOfString:@"/development/" withString:@"/production/"];
    thumbImgURLString = [thumbImgURLString stringByReplacingOccurrencesOfString:@"/staging/" withString:@"/production/"];
    return thumbImgURLString;
}

- (id)previewImgURL
{
    NSString *previewImgURLString = (NSString*)[self primitiveValueForKey:@"previewImgURL"];
    previewImgURLString = [previewImgURLString stringByReplacingOccurrencesOfString:@"/development/" withString:@"/production/"];
    previewImgURLString = [previewImgURLString stringByReplacingOccurrencesOfString:@"/staging/" withString:@"/production/"];
    return previewImgURLString;
}

- (id)ipadDisplayImgURL
{
    NSString *ipadDisplayImgURLString = (NSString*)[self primitiveValueForKey:@"ipadDisplayImgURL"];
    ipadDisplayImgURLString = [ipadDisplayImgURLString stringByReplacingOccurrencesOfString:@"/development/" withString:@"/production/"];
    ipadDisplayImgURLString = [ipadDisplayImgURLString stringByReplacingOccurrencesOfString:@"/staging/" withString:@"/production/"];
    return ipadDisplayImgURLString;
}

- (id)artworkImgURL
{
    NSString *artworkImgURLString = (NSString*)[self primitiveValueForKey:@"artworkImgURL"];
    artworkImgURLString = [artworkImgURLString stringByReplacingOccurrencesOfString:@"/development/" withString:@"/production/"];
    artworkImgURLString = [artworkImgURLString stringByReplacingOccurrencesOfString:@"/staging/" withString:@"/production/"];
    return artworkImgURLString;
}

- (NSString*)mediumString
{
    NSArray *mediumArray = (NSArray*)[self primitiveValueForKey:@"medium"];
    __block NSString *newMediumString = @"";
    [mediumArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSDictionary *dict = (NSDictionary*)obj;
        newMediumString = [newMediumString stringByAppendingFormat:@" %@",[dict objectForKey:@"name"]];
    }];
    return newMediumString;
}

- (NSString*)genreString
{
    NSArray *genreArray = (NSArray*)[self primitiveValueForKey:@"genre"];
    __block NSString *newGenreString = @"";
    [genreArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSDictionary *dict = (NSDictionary*)obj;
        newGenreString = [newGenreString stringByAppendingFormat:@" %@",[dict objectForKey:@"name"]];
    }];
    return newGenreString;
}

- (NSString*)dimensionsString
{
    return [NSString stringWithFormat:@"%1.1f\"h x %1.1f\"w x %1.1f\"d", [self.height floatValue], [self.width floatValue], [self.depth floatValue]];
}

- (UIImage*)croppedImage
{
    if (_croppedImage == nil)
    {
        CGFloat ratio = 5.0f;
        
        CGRect cropRect;
        CGFloat artObjectWidth = 0.0;
        CGFloat artObjectHeight;
        
        while (artObjectWidth/2 < SLOTVIEW_WIDTH || artObjectHeight/2 < SLOTVIEW_HEIGHT) {
            artObjectWidth = [self.width floatValue] * ratio;
            artObjectHeight = [self.height floatValue] * ratio;
            cropRect = CGRectMake((artObjectWidth/2 - SLOTVIEW_WIDTH/2.0f), (artObjectHeight/2 - SLOTVIEW_HEIGHT/2.0f),  SLOTVIEW_WIDTH, SLOTVIEW_HEIGHT);
            ratio += 1.0f;
        }
        _croppedImage = [[self scaledImageWithPixelRatio:ratio] croppedImageWithRect:cropRect];
        
    }
    
    return _croppedImage;
}

- (void)updateStatus
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:self.artworkID], @"id", nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    
    [[ATAPIClient sharedClient] getPath:[NSString stringWithFormat:@"artworks/%d/status.json", [self.artworkID intValue]] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *responseDict = responseObject;
        NSString *status = [[responseDict objectForKey:@"artwork"] objectForKey:@"state"];
        NSString *soldAt = [[responseDict objectForKey:@"artwork"] objectForKey:@"sold_at"];
        if (soldAt != (id)[NSNull null] && [soldAt length] > 0) {
            self.soldAt = [dateFormatter dateFromString:soldAt];
            self.inCart = [NSNumber numberWithBool:NO];
        }
        self.state = status;
        if ([self.delegate respondsToSelector:@selector(didCompleteUpdate:)]) {
            [self.delegate performSelector:@selector(didCompleteUpdate:) withObject:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}



- (UIImage*)scaledImageWithPixelRatio:(CGFloat)pixelRatio
{
    UIImage *artImage = [self artImage];
    UIImage *scaledImage = [artImage imageByScalingAndCroppingForSize:CGSizeMake([self.width floatValue] * pixelRatio, [self.height floatValue] * pixelRatio)];
    
    return scaledImage;
}

- (UIImage*)artImage
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.previewImgURL]]];
}

- (BOOL)sold
{
    return self.soldAt != nil;
}

#pragma mark -



@end
