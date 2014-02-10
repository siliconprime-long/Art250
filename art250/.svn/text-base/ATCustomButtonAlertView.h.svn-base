//
//  ATCustomButtonAlertView.h
//  art250
//
//  Created by Winfred Raguini on 6/29/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATDelegatedUIImageView.h"

@class ATCustomButtonAlertView;
@protocol ATCustomButtonAlertViewDelegate <NSObject>
- (void)customButtonAlertView:(ATCustomButtonAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface ATCustomButtonAlertView : ATDelegatedUIImageView
@property (nonatomic, assign) id<ATCustomButtonAlertViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) NSString *topLabelText;
@property (nonatomic, strong) NSString *bottomLabelText;
@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, strong) UILabel *topLabelTextLabel;
@property (nonatomic, strong) UILabel *bottomLabelTextLabel;

//TopLabel Properties
@property (nonatomic, strong) NSString *topLabelFont;
@property (nonatomic, assign) CGFloat topLabelHeight;
//BottomLabel Properties
@property (nonatomic, assign) CGFloat bottomLabelHeight;

@end

