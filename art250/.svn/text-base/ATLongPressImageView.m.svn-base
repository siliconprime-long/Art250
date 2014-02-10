//
//  ATLongPressImageView.m
//  art250
//
//  Created by Winfred Raguini on 12/16/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATLongPressImageView.h"
#import "QuartzCore/CALayer.h"
#import "Artwork.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageEffects.h"
#import "ATInactiveArtworkProxy.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define SPINNER_SIDE_LENGTH 30.0f

@interface ATLongPressImageView ()
@property (nonatomic, strong) UIImageView *soldImageView;
@property (nonatomic, strong) UIImageView *inCollectionImageView;
@property (nonatomic, strong) UIImageView *inCartImageView;
@property (nonatomic, strong) UILabel *numLikesLabel;
- (void)longPressDetected:(UILongPressGestureRecognizer*)recognizer;
- (void)tapDetected:(UITapGestureRecognizer*)recognizer;
@end

@implementation ATLongPressImageView
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:NO];
        
//        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
//        [self addGestureRecognizer:tapRecognizer];
//        
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 2;
        self.clipsToBounds = NO;
        
        self.soldImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sold_overlay.png"]];
        [self addSubview:self.soldImageView];
        [self.soldImageView setHidden:YES];
        
        self.inCartImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"in_cart_overlay_solid.png"]];
        [self addSubview:self.inCartImageView];
        [self.inCartImageView setHidden:YES];
        
        
        self.inCollectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart_overlay.png"]];
        
        self.numLikesLabel = [[UILabel alloc] initWithFrame:self.inCollectionImageView.frame];
        [self.numLikesLabel setTextColor:[UIColor blackColor]];
        [self.numLikesLabel setTextAlignment:NSTextAlignmentCenter];
        [self.numLikesLabel setFont:[UIFont fontWithName:@"ProximaNova-Light" size:14.0f]];
        [self.numLikesLabel setHidden:YES];
        [self.inCollectionImageView addSubview:self.numLikesLabel];
        
        [self addSubview:self.inCollectionImageView];
        [self.inCollectionImageView setHidden:YES];
        
        self.spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.spinnerView];
        
    }
    return self;
}


#pragma mark
#pragma mark Private


- (void)tapDetected:(UITapGestureRecognizer*)recognizer
{
    if ([self.delegate respondsToSelector:@selector(tapDetected:)]) {
        [self.delegate performSelector:@selector(tapDetected:) withObject:recognizer];
    }
}

- (void)updateWithInactiveArtworkProxy:(ATInactiveArtworkProxy*)artworkProxy
{
    CGRect prevPaintingViewFrame = self.frame;
    prevPaintingViewFrame.size.width = artworkProxy.width;
    prevPaintingViewFrame.size.height = artworkProxy.height;
    [self setFrame:prevPaintingViewFrame];
    self.image = artworkProxy.inactiveArtworkImage;
    [self.inCartImageView setHidden:YES];
    [self.soldImageView setHidden:YES];
}

- (void)updateWithArtObject:(Artwork *)artObject withRatio:(CGFloat)pixInchRatio forEventType:(ATArtworkEventType)eventType
{
    self.artwork = artObject;
    
    
    self.eventType = eventType;
    
    CGRect prevPaintingViewFrame = self.frame;
    prevPaintingViewFrame.size.width = [self.artwork.width floatValue] * pixInchRatio;
    prevPaintingViewFrame.size.height = [self.artwork.height floatValue] * pixInchRatio;

    
    self.frame = prevPaintingViewFrame;
    
    [self setNeedsLayout];
    
    [self.inCartImageView setHidden:YES];
    [self.soldImageView setHidden:YES];
    
    if (self.eventType != ATArtworkEventTypePreview) {
        [self updateArtworkStatus];
    }
   
    [self.inCollectionImageView setHidden:YES];
    

    self.spinnerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self setImage:nil];

    [self.spinnerView startAnimating];
    //NSLog(@"URL %@", [artObject largeArtImageURL]);
    
    
    if ([self.artwork.inCollection boolValue] && self.eventType != ATArtworkEventTypePreview) {
        [self showInCollectionBadge];
    }
    
    if ([self.artwork.inCollection boolValue] && self.eventType != ATArtworkEventTypePreview && self.eventType != ATArtworkEventTypeAddedToCollection) {
        [self showInCollectionBadge];
    }
    
   // NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[self.artwork previewImgURL]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0f];
                                    
    __weak ATLongPressImageView *dp = self; // OK for iOS 4.x and up
  //  requestURL.cachePolicy = NSURLReques
 //   __block ATLongPressImageView *blockSelf = self;
    
//    THIS IS USING AFNETWORKING + UIIMAGEVIEW CATEGORY
//    [self setImageWithURLRequest:requestURL placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
//        if (dp) {
//            [dp stopSpinner];
//            [dp setImage:image];
//        }
//        
//    } failure:^(NSURLRequest *request
//                , NSHTTPURLResponse *response, NSError *error) {
//        NSLog(@"Failed in ATLongPressImageView imageRequest error %@", [error localizedDescription]);
//    }];
    
// This is using SDWebImage
    [self setImageWithURL:[NSURL URLWithString:[self.artwork previewImgURL]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){

        if (dp) {
            if (error == nil) {
                [dp stopSpinner];
                [dp setImage:image];
            } else {
                NSLog(@"Error %@", [error localizedDescription]);
            }
            
        }
    }];
}

- (void)updateArtworkStatus
{
    if ([self.artwork sold]) {
        CGRect soldViewImageFrame = self.soldImageView.frame;
        soldViewImageFrame.origin.x = self.frame.size.width - soldViewImageFrame.size.width;
        soldViewImageFrame.origin.y = self.frame.size.height - soldViewImageFrame.size.height;
        [self.soldImageView setFrame:soldViewImageFrame];
        [self.soldImageView setHidden:NO];
    } else {
        [self.soldImageView setHidden:YES];
    }
    
    if ([self.artwork.inCart boolValue]) {
        CGRect inCartViewImageFrame = self.inCartImageView.frame;
        inCartViewImageFrame.origin.x = self.frame.size.width - inCartViewImageFrame.size.width;
        inCartViewImageFrame.origin.y = self.frame.size.height - inCartViewImageFrame.size.height;
        [self.inCartImageView setFrame:inCartViewImageFrame];
        [self.inCartImageView setHidden:NO];
    } else {
        [self.inCartImageView setHidden:YES];
    }
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didSaveMergedImage:(NSNotification*)note
{
    //When the image appears show the collection badge if they're in the collection

}

- (void)showInCollectionBadge
{
    if (self.eventType == ATArtworkEventTypeAddedToCollection) {
        //Animate this bitch
        CGRect inCollectionImageViewFrame = self.inCollectionImageView.frame;
        inCollectionImageViewFrame.origin.x = 0.0f;
        inCollectionImageViewFrame.size.height = 1.0f;
        inCollectionImageViewFrame.size.width = 1.0f;
        inCollectionImageViewFrame.origin.y = 0.0f;
        [self.inCollectionImageView setFrame:inCollectionImageViewFrame];
        [self.inCollectionImageView setHidden:NO];
        //[self.numLikesLabel setText:[NSString stringWithFormat:@"%d",[self.artwork.numInOtherCollections intValue]]];
        [UIView animateWithDuration:0.4f animations:^(void){
            
            CGRect inCollectionImageViewFrame = self.inCollectionImageView.frame;
            inCollectionImageViewFrame.size.width = 42.0f;
            inCollectionImageViewFrame.size.height = 42.0f;
            
            [self.inCollectionImageView setFrame:inCollectionImageViewFrame];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.2f animations:^(void){
                CGRect inCollectionImageViewFrame = self.inCollectionImageView.frame;
                inCollectionImageViewFrame.size.width = 40.0f;
                inCollectionImageViewFrame.size.height = 40.0f;

                [self.inCollectionImageView setFrame:inCollectionImageViewFrame];
                
            } completion:^(BOOL finished){
                [self.numLikesLabel setHidden:NO];
            }];
        }];
        
        
    } else {
        CGRect inCollectionImageViewFrame = self.inCollectionImageView.frame;

        
        [self.inCollectionImageView setFrame:inCollectionImageViewFrame];
        [self.inCollectionImageView setHidden:NO];
        [self.numLikesLabel setHidden:NO];
    }
}

- (void)stopSpinner
{
    [self.spinnerView stopAnimating];
}

@end
