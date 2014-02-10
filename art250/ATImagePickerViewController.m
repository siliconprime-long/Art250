//
//  ATImagePickerViewController.m
//  art250
//
//  Created by Winfred Raguini on 3/30/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATImagePickerViewController.h"

#define VIRTUAL_PAINTING_POS_Y_OFFSET 200.0f
#define DISTANCE_BUTTON_POS_X 19.0f
#define DISTANCE_BUTTON_SIDE 78.0f


@interface ATImagePickerViewController ()

@end

@implementation ATImagePickerViewController

NSArray *buttonsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (UIViewController *)childViewControllerForStatusBarHidden
{
    return nil;
}


- (void)takePicture
{
//    if (!self.distance15Button.selected || !self.distance20Button.selected) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You must choose a distance first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
//    } else {
        //NSLog(@"Taking that picture see");
        [super takePicture];
//    }
   
}

- (void)closeButtonSelected
{
    if ([self.delegate respondsToSelector:@selector(closeCameraButtonSelected)]) {
        [self.delegate performSelector:@selector(closeCameraButtonSelected)];
    }
}

- (void)closeCameraButtonSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(closeCameraButtonSelected)]) {
        [self.delegate performSelector:@selector(closeCameraButtonSelected)];
    }

}



- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


@end
