//
//  ATInactiveArtworkProxy.h
//  art250
//
//  Created by Win Raguini on 1/2/14.
//  Copyright (c) 2014 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchableArtistProfile;
@interface ATInactiveArtworkProxy : NSObject <NSCoding>
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, strong) SearchableArtistProfile *artistProfile;
@property (nonatomic, strong, readonly) UIImage *inactiveArtworkImage;
@end
