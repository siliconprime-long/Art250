//
//  ATCollectionManager.h
//  art250
//
//  Created by Winfred Raguini on 9/2/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Artwork;
@interface ATCollectionManager : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL buyNowEnabled;
+ (ATCollectionManager*)sharedManager;
- (Artwork*)randomArtwork;
- (NSArray*)collection;
@end
