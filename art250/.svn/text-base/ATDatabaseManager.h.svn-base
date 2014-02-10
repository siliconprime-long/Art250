//
//  ATDatabaseManager.h
//  art250
//
//  Created by Winfred Raguini on 12/7/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATDatabaseManager : NSObject
+ (ATDatabaseManager*)sharedManager;
- (void)initializeDB;
- (BOOL)didImportArtistProfiles;
@property (nonatomic, strong) NSManagedObjectContext *mainThreadContext;
@end
