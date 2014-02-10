//
//  ATFTDIntroViewController.h
//  art250
//
//  Created by Winfred Raguini on 8/20/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATPagingViewController.h"

@interface ATFTDIntroViewController : ATPagingViewController 
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundView;
@property (nonatomic, strong) IBOutlet UIImageView *overlayView;
@property (nonatomic, strong) IBOutlet UIButton *skipTourButton;
- (IBAction)skipTourButtonSelected:(id)sender;
@end
