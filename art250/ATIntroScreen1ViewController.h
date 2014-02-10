//
//  ATIntroScreen1ViewController.h
//  art250
//
//  Created by Winfred Raguini on 2/14/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATCameraOverlayViewController.h"

@interface ATIntroScreen1ViewController : ATCameraOverlayViewController
@property (nonatomic, readwrite, strong) IBOutlet UIImageView *standingMan;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;
- (IBAction)didChooseContinueButton:(id)selector;
@end
