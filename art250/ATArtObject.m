//
//  ATArtObject.m
//  art250
//
//  Created by Winfred Raguini on 8/25/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATArtObject.h"
#import "UIImage+WRExtensions.h"
#import "ATAPIClient.h"
#import "ATArtistObject.h"
#import "UIColor+WRExtensions.h"
#import "UIImageView+AFNetworking.h"
#import "Artist.h"
#import "Artwork.h"
#import "ArtistProfile.h"
#import "ATAPIClient.h"
#import "SearchableArtistProfile.h"

#define SLOTVIEW_WIDTH 128.0f
#define SLOTVIEW_HEIGHT 98.0f
#define MAX_ARTIST_QUERY_BATCH 20

#define SUGGESTED_ARTWORK_QUOTIENT 1

@interface ATArtObject ()
@property (nonatomic, readwrite) NSString *sizeString;
- (NSString*)serializeTagsFromArray:(NSArray*)tags;
+ (void)preloadImagesWithArtwork:(NSArray*)suggestedArtwork;
+ (void)preloadRestOfArtwork:(NSArray*)suggestedArtwork;
@end

@implementation ATArtObject

- (id)init
{
    if (self = [super init]) {
        _artImage = [UIImage imageNamed:@"artImage1.png"];
        _largeArtImage = [UIImage imageNamed:@"artLargeImage1.png"];
        _heightInInches = [NSNumber numberWithFloat:24.0f];
        _widthInInches = [NSNumber numberWithFloat:32.0f];
        _depthInInches = [NSNumber numberWithFloat:3.0f];
        _sentiment = ATSentimentTypeNone;
    }
    return self;
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _sentiment = ATSentimentTypeNone;
    
    //NSLog(@"Attributes are %@", attributes);
    
//    {"artwork_image":{"url":"http://com.arttwo50.s3-us-west-2.amazonaws.com/staging/uploads/artwork/artwork_image/56/december-11-holiday_lights__40-nocal-1920x1200_1_.jpg",
//     "ipad_display":{"url":"http://com.arttwo50.s3-us-west-2.amazonaws.com/staging/uploads/artwork/artwork_image/56/ipad_display_december-11-holiday_lights__40-nocal-1920x1200_1_.jpg"},
//     "preview":{"url":"http://com.arttwo50.s3-us-west-2.amazonaws.com/staging/uploads/artwork/artwork_image/56/preview_december-11-holiday_lights__40-nocal-1920x1200_1_.jpg"},
//     "thumb":{"url":"http://com.arttwo50.s3-us-west-2.amazonaws.com/staging/uploads/artwork/artwork_image/56/thumb_december-11-holiday_lights__40-nocal-1920x1200_1_.jpg"}},
//    "columns":null,
//    "created_at":"2013-01-24T21:03:07Z",
//    "depth":null,
//    "description":"",
//    "height":null,
//    "id":56,
//    "photo_url":null,
//    "rows":null,
//    "shipping_requirements":null,
//    "title":"",
//    "updated_at":"2013-01-24T21:03:07Z",
//    "user_id":74,
//    "weight":null,
//    "width":null,
//    "medium":[{"id":18,"name":"ew"}],
//    "genre":[{"id":19,"name":"ewqe"}],
//    "keyword":[]
    
//    "artist":
//        {"activated":false,"created_at":"2013-01-24T21:00:09Z","email":"j@p.com","id":74,"invites_left":5,"max_artwork_sales":5,"merchant_ready":false,"merchant_tier":null,"roles_mask":null,"updated_at":"2013-01-24T21:00:09Z","verified":false},
//    "user_profile":{"address1":null,"address2":null,"artist_statement":"","city":"","created_at":"2013-01-24T21:00:09Z","first_name":"","id":64,"last_name":"","profile_image":{"url":"http://com.arttwo50.s3-us-west-2.amazonaws.com/staging/uploads/user_profile/profile_image/64/december-11-blue_december__83-nocal-1920x1200_1_.jpg","preview":{"url":"http://com.arttwo50.s3-us-west-2.amazonaws.com/staging/uploads/user_profile/profile_image/64/preview_december-11-blue_december__83-nocal-1920x1200_1_.jpg"},"thumb":{"url":"http://com.arttwo50.s3-us-west-2.amazonaws.com/staging/uploads/user_profile/profile_image/64/thumb_december-11-blue_december__83-nocal-1920x1200_1_.jpg"}},"public_url":null,"state":"","status":"","updated_at":"2013-01-24T21:02:04Z","user_id":74}}
    
//    {:address1, :address2, :city, :first_name, :last_name, :profile_image, :artist_statement, :state}
    
    
//    NSDictionary *artistDictionary = [attributes valueForKeyPath:@"artist"];
//    ATArtistObject *artistObject = [[ATArtistObject alloc] initWithAttributes:artistDictionary];
//    
//    
//    self.artist = artistObject;
    _id = [[attributes valueForKeyPath:@"id"] intValue];
    NSArray *mediumTags = [attributes valueForKeyPath:@"medium"];
    _medium = [self serializeTagsFromArray:mediumTags];
    NSArray *genreTags = [attributes valueForKeyPath:@"genre"];
    _genre = [self serializeTagsFromArray:genreTags];
    _artworkDescription = [attributes valueForKeyPath:@"description"];
    _title = [attributes valueForKeyPath:@"title"];
    _artImageURL = [[attributes valueForKeyPath:@"artwork_image.artwork_image.url"] stringByReplacingOccurrencesOfString:@"development" withString:@"production"];
    _artImageURL = [_artImageURL stringByReplacingOccurrencesOfString:@"staging" withString:@"production"];
//    //NSLog(@"_artImageURL %@", _artImageURL);
    _largeArtImageURL = [[attributes valueForKeyPath:@"artwork_image.artwork_image.ipad_display.url"] stringByReplacingOccurrencesOfString:@"development" withString:@"production"];
    _largeArtImageURL = [_largeArtImageURL stringByReplacingOccurrencesOfString:@"staging" withString:@"production"];
     //NSLog(@"_largeArtImageURL %@", _largeArtImageURL);
    _croppedImageURL = [[attributes valueForKeyPath:@"artwork_image.artwork_image.preview.url"] stringByReplacingOccurrencesOfString:@"development" withString:@"production"];
    _croppedImageURL = [_croppedImageURL stringByReplacingOccurrencesOfString:@"staging" withString:@"production"];
//    //NSLog(@"_croppedImageURL %@", _croppedImageURL);
    _price = [NSNumber numberWithFloat:[[attributes valueForKeyPath:@"price"] floatValue]];
    
    if ( [attributes valueForKeyPath:@"height"] != [NSNull null]) {
         _heightInInches = [NSNumber numberWithFloat:[[attributes valueForKeyPath:@"height"] floatValue]];
    } else {
        _heightInInches = [NSNumber numberWithFloat:0.0f];
    }
    
    if ([attributes valueForKeyPath:@"width"] != [NSNull null]) {
        _widthInInches = [NSNumber numberWithFloat:[[attributes valueForKeyPath:@"width"] floatValue]];
    } else {
        _widthInInches = [NSNumber numberWithFloat:0.0f];
    }
    
    if ([attributes valueForKeyPath:@"depth"] != [NSNull null]) {
        _depthInInches = [NSNumber numberWithFloat:[[attributes valueForKeyPath:@"depth"] floatValue]];
    } else {
        _depthInInches = [NSNumber numberWithFloat:0.0f];
    }
    _sizeString = [NSString stringWithFormat:@"%01.1f\"x %01.1f\"x %01.1f\"", [_widthInInches floatValue], [_heightInInches floatValue], [_depthInInches floatValue]];
    _artist = [[ATArtistObject alloc] initWithAttributes:[attributes valueForKeyPath:@"artist"]];
    
    _artImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_croppedImageURL]]];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.artist forKey:@"artist"];
    [encoder encodeObject:self.croppedImage forKey:@"croppedImage"];
    [encoder encodeObject:self.artImage forKey:@"artImage"];
    [encoder encodeObject:self.largeArtImage forKey:@"largeArtImage"];
    
    [encoder encodeObject:self.croppedImageURL forKey:@"croppedImageURL"];
    [encoder encodeObject:self.artImageURL forKey:@"artImageURL"];
    [encoder encodeObject:self.largeArtImageURL forKey:@"largeArtImageURL"];
    
    [encoder encodeInt:self.id forKey:@"id"];
    
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.artworkDescription forKey:@"artworkDescription"];
    [encoder encodeObject:self.style forKey:@"style"];
    [encoder encodeObject:self.genre forKey:@"genre"];
    [encoder encodeObject:self.medium forKey:@"medium"];
    [encoder encodeObject:self.heightInInches forKey:@"heightInInches"];
    [encoder encodeObject:self.widthInInches forKey:@"widthInInches"];
    [encoder encodeObject:self.depthInInches forKey:@"depthInInches"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.sizeString forKey:@"sizeString"];
    
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeInt:self.sentiment forKey:@"sentiment"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.artist = [decoder decodeObjectForKey:@"artist"];
        self.croppedImage = [decoder decodeObjectForKey:@"croppedImage"];
        self.artImage = [decoder decodeObjectForKey:@"artImage"];
        self.largeArtImage = [decoder decodeObjectForKey:@"largeArtImage"];
        
        self.croppedImageURL = [decoder decodeObjectForKey:@"croppedImageURL"];
        self.artImageURL = [decoder decodeObjectForKey:@"artImageURL"];
        self.largeArtImageURL = [decoder decodeObjectForKey:@"largeArtImageURL"];
        
        self.id = [decoder decodeIntForKey:@"id"];
        
        self.title = [decoder decodeObjectForKey:@"title"];
        self.artworkDescription = [decoder decodeObjectForKey:@"artworkDescription"];
        self.style = [decoder decodeObjectForKey:@"style"];
        self.genre = [decoder decodeObjectForKey:@"genre"];
        self.medium = [decoder decodeObjectForKey:@"medium"];
        self.heightInInches = [decoder decodeObjectForKey:@"heightInInches"];
        self.widthInInches = [decoder decodeObjectForKey:@"widthInInches"];
        self.depthInInches = [decoder decodeObjectForKey:@"depthInInches"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.sizeString = [decoder decodeObjectForKey:@"sizeString"];
        
        self.status = [decoder decodeObjectForKey:@"status"];
        self.sentiment = [decoder decodeObjectForKey:@"sentiment"];
    }
    return self;
}



- (NSString*)description
{
    return [NSString stringWithFormat:@"title: %@, artImageURL: %@, height: %1.2f, width: %1.2f, depth: %1.2f", _title, _artImageURL, [_heightInInches floatValue], [_widthInInches floatValue], [_depthInInches floatValue]];
}

- (UIImage*)scaledImageWithPixelRatio:(CGFloat)pixelRatio
{
    UIImage *scaledImage = [self.artImage imageByScalingAndCroppingForSize:CGSizeMake([self.widthInInches floatValue] * pixelRatio, [self.heightInInches floatValue] * pixelRatio)];
    
    return scaledImage;
}


+ (void)suggestedArtworkForHueArray:(NSArray*)hueArray withAverageHue:(int)averageHue distance:(NSString*)distance size:(NSString*)size lat:(CGFloat)lat lng:(CGFloat)lng limit:(int)limit inBatchesOf:(int)batches withBlock:(void (^)(NSArray *initialArtwork, NSArray *fullArtwork, NSError *error))block {
    
    //NSLog(@"There are %d hues in the array", [hueArray count]);
//    NSMutableArray *hexColorArray = [NSMutableArray array];
//    [hueArray enumerateObjectsUsingBlock:^(id obj, __unused NSUInteger idx, __unused BOOL *stop){
//        UIColor *color = (UIColor*)obj;
//        //NSLog(@"hex is %@", color.uiColorToHexString);
//        [hexColorArray addObject:color.uiColorToHexString];
//    }];
//    //NSLog(@"sending the colorArray %@", hexColorArray);
    //NSLog(@"The hues are %@", hueArray);
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithFormat:@"%d", limit], @"limit", hueArray, @"hues", [NSNumber numberWithInt:averageHue], @"average_hue", distance, @"distance", size, @"size", nil];
    
    [[ATTrackingManager sharedManager] trackEvent:FL_GET_RECOMMENDED_ARTWORK];
    
    
    //Use this to save to CoreData - but remember to only save unique Artwork - and then send the Artwork NSManagedObjects
    [[ATAPIClient sharedClient] getPath:@"/v2/artworks/query.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSArray *responseDict = responseObject;
        NSMutableArray *artworksArray = [[NSMutableArray alloc] init];
        
        NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
        for (NSDictionary *artworkDict in responseDict) {
            NSDictionary *artworkInfoDict = [artworkDict objectForKey:@"artwork"];
            Artwork *suggestedArtwork = [Artwork uniqueArtworkWithDictionary:artworkInfoDict forContext:ctx];
            
            [artworksArray addObject:suggestedArtwork];
        }
        
        NSError *executeError = nil;
        if(![ctx saveToPersistentStore:&executeError]) {
            NSLog(@"Failed to save to data store");
        }
        
        if (block) {
            block(artworksArray, artworksArray, nil);
        }
//        NSString *status = [[responseDict objectForKey:@"artwork"] objectForKey:@"state"];
//        NSString *soldAt = [[responseDict objectForKey:@"artwork"] objectForKey:@"sold_at"];
//        if (soldAt != (id)[NSNull null] && [soldAt length] > 0) {
//            self.soldAt = [dateFormatter dateFromString:soldAt];
//            self.inCart = [NSNumber numberWithBool:NO];
//        }
//        self.state = status;
//        if ([self.delegate respondsToSelector:@selector(didCompleteUpdate:)]) {
//            [self.delegate performSelector:@selector(didCompleteUpdate:) withObject:self];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[ATTrackingManager sharedManager] trackEvent:FL_GET_RECOMMENDED_ARTWORK_FAILED];
        NSLog(@"dang error is %@", [error localizedDescription]);
        if (block) {
            block([NSArray array], [NSArray array], error);
        }
    }];
    
    
//    [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/artworks/query.json" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
//        if (block) {
//            block([mappingResult array], [mappingResult array], nil);
//        }
//    }failure:^(RKObjectRequestOperation *operation, NSError *error){
//        [[ATTrackingManager sharedManager] trackEvent:FL_GET_RECOMMENDED_ARTWORK_FAILED];
//        NSLog(@"dang error is %@", [error localizedDescription]);
//        if (block) {
//            block([NSArray array], [NSArray array], error);
//        }
//    }];
}

+ (void)preloadImagesWithArtwork:(NSArray*)suggestedArtwork
{
//    NSRange theRange;
//    theRange.location = 0;
//    theRange.length = [suggestedArtwork count] / SUGGESTED_ARTWORK_QUOTIENT;
//    NSArray *subsetOfSuggestedArtwork = [suggestedArtwork subarrayWithRange:theRange];
//    
//    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
//    
//    
//    //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        for (ATArtObject *artObject in subsetOfSuggestedArtwork) {
////            NSURL *url = [NSURL URLWithString:artObject.largeArtImageURL];
////            NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
////            AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:urlRequest success:^(UIImage *image){
////                
////            }];
////            [operationQueue addOperation:operation];
//            NSURL *imageURL = [NSURL URLWithString:artObject.largeArtImageURL];
//            UIImageView *imageView = [[UIImageView alloc] init];
//            [imageView setImageWithURL:imageURL];
//        }
}

+ (void)preloadRestOfArtwork:(NSArray*)suggestedArtwork
{
    NSRange theRange;
    theRange.location = [suggestedArtwork count] / SUGGESTED_ARTWORK_QUOTIENT;
    theRange.length = [suggestedArtwork count] - theRange.location;
    NSArray *subsetOfSuggestedArtwork = [suggestedArtwork subarrayWithRange:theRange];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        for (ATArtObject *artObject in subsetOfSuggestedArtwork) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImageWithURL:[NSURL URLWithString:artObject.largeArtImageURL]];
        }
    });
}

- (NSString*)serializeTagsFromArray:(NSArray*)tags
{
    NSString *tagNames = nil;
    for (NSDictionary *mediumTagKeys in tags) {
        if (tagNames == nil) {
            tagNames = [mediumTagKeys valueForKey:@"name"];
        } else {
            tagNames = [NSString stringWithFormat:@"%@, %@", tagNames, [mediumTagKeys valueForKey:@"name"]];
        }
    }
    return tagNames;
}

- (UIImage*)croppedImage
{
    CGRect cropRect;
    CGFloat artObjectWidth;
    CGFloat artObjectHeight;
    if (_croppedImage == nil)
    {
        CGFloat ratio = 5.0f;

        while (artObjectWidth/2 < SLOTVIEW_WIDTH || artObjectHeight/2 < SLOTVIEW_HEIGHT) {
            artObjectWidth = [self.widthInInches floatValue] * ratio;
            artObjectHeight = [self.heightInInches floatValue] * ratio;
            cropRect = CGRectMake((artObjectWidth/2 - SLOTVIEW_WIDTH/2.0f), (artObjectHeight/2 - SLOTVIEW_HEIGHT/2.0f),  SLOTVIEW_WIDTH, SLOTVIEW_HEIGHT);
            ratio += 1.0f;
        }
        _croppedImage = [[self scaledImageWithPixelRatio:ratio] croppedImageWithRect:cropRect];

    }
    
    return _croppedImage;
}

- (void)updateStatus
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:self.id], @"id", nil];
    [[ATAPIClient sharedClient] getPath:[NSString stringWithFormat:@"artworks/%d/status.json", self.id] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *responseDict = responseObject;
        NSString *status = [[responseDict objectForKey:@"artwork"] objectForKey:@"state"];

        [self setStatus:status];
        if ([self.delegate respondsToSelector:@selector(didCompleteUpdate:)]) {
            [self.delegate performSelector:@selector(didCompleteUpdate:) withObject:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error");
    }];
}

- (BOOL)isEqual:(id)object
{
    ATArtObject *artObject = (ATArtObject*)object;
    if (object == self || artObject.id == self.id) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)sold
{
    return [self.status isEqualToString:@"sold"];
}

@end
