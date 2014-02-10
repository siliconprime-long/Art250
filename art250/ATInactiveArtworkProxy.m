//
//  ATInactiveArtworkProxy.m
//  art250
//
//  Created by Win Raguini on 1/2/14.
//  Copyright (c) 2014 Art250. All rights reserved.
//

#import "ATInactiveArtworkProxy.h"

@interface ATInactiveArtworkProxy ()
@property (nonatomic, strong) UIImage *inactiveArtworkImage;
@property (nonatomic, assign, readwrite) CGFloat width;
@property (nonatomic, assign, readwrite) CGFloat height;
@end

@implementation ATInactiveArtworkProxy

- (id)init
{
    if (self = [super init]) {
        _inactiveArtworkImage = [UIImage imageNamed:@"no-art.png"];
        _width = 240.0f;
        _height = 180.0f;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.inactiveArtworkImage = [aDecoder decodeObjectForKey:@"inactiveArtworkImage"];
        self.width = [aDecoder decodeFloatForKey:@"width"];
        self.height = [aDecoder decodeFloatForKey:@"height"];
        self.artistProfile = [aDecoder decodeObjectForKey:@"artistProfile"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.inactiveArtworkImage forKey:@"inactiveArtworkImage"];
    [aCoder encodeFloat:self.width forKey:@"width"];
    [aCoder encodeFloat:self.height forKey:@"height"];
    [aCoder encodeObject:self.artistProfile forKey:@"artistProfile"];
}

@end
