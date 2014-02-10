//
//  ATStatePickerController.h
//  art250
//
//  Created by Winfred Raguini on 3/21/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATStatePickerDelegate <NSObject>
@optional
-(void)didSelectState:(NSString*)stateString;
@end


@interface ATStatePickerController : UITableViewController
@property (nonatomic, retain, readwrite) NSArray *stateArray;
@property (nonatomic, assign) id delegate;
@end