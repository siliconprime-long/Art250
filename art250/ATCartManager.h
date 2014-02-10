//
//  ATCartManager.h
//  art250
//
//  Created by Winfred Raguini on 9/3/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATCartManager : NSObject <UITableViewDataSource, UITableViewDelegate>
+ (ATCartManager*)sharedManager;
@end
