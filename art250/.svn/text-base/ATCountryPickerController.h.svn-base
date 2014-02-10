//
//  ATCountryPickerControllerViewController.h
//  art250
//
//  Created by Winfred Raguini on 3/21/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATCountryPickerDelegate <NSObject>
@optional
-(void)didSelectCountry:(NSString*)countryString;
@end

@interface ATCountryPickerController : UITableViewController
//@property (nonatomic, retain, readwrite) IBOutlet UITableView *tableView;
@property (nonatomic, retain, readwrite) NSArray *countryArray;
@property (nonatomic, assign) id delegate;
@end
