//
//  ATArtObject.h
//  art250
//
//  Created by Winfred Raguini on 8/25/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ATSentimentTypeNone = -1,
    ATSentimentTypeDislike,
    ATSentimentTypeLike
} ATSentimentType;


@class ATArtistObject;
@interface ATArtObject : NSObject
@property (nonatomic, strong) ATArtistObject *artist;

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UIImage *croppedImage;
@property (nonatomic, strong) UIImage *artImage;
@property (nonatomic, strong) UIImage *largeArtImage;

@property (nonatomic, strong) NSString *croppedImageURL;
@property (nonatomic, strong) NSString *artImageURL;
@property (nonatomic, strong) NSString *largeArtImageURL;

@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artworkDescription;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *medium;
@property (nonatomic, strong) NSNumber *heightInInches;
@property (nonatomic, strong) NSNumber *widthInInches;
@property (nonatomic, strong) NSNumber *depthInInches;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong, readonly) NSString *sizeString;

@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) ATSentimentType sentiment;

- (BOOL)sold;
- (id)initWithAttributes:(NSDictionary *)attributes;
- (UIImage*)scaledImageWithPixelRatio:(CGFloat)pixelRatio;
+ (void)suggestedArtworkForHueArray:(NSArray*)hueArray withAverageHue:(int)averageHue distance:(NSString*)distance size:(NSString*)size lat:(CGFloat)lat lng:(CGFloat)lng limit:(int)limit inBatchesOf:(int)batches withBlock:(void (^)(NSArray *initialArtwork, NSArray *fullArtwork, NSError *error))block;
+ (void)preloadImagesWithArtwork:(NSArray*)suggestedArtwork;
- (void)updateStatus;
@end


@protocol ATArtObjectDelegate
- (void)didCompleteUpdate:(ATArtObject*)self;
- (void)updateFailed:(ATArtObject*)self;
@end
