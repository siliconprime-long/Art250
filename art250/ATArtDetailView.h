//
//  ATArtDetailView.h
//  art250
//
//  Created by Winfred Raguini on 8/26/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATArtObject.h"

@interface ATArtDetailView : UIView
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) ATArtObject *artObject;
@end
