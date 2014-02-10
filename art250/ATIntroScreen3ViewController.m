//
//  ATIntroScreen3ViewController.m
//  art250
//
//  Created by Winfred Raguini on 2/14/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATIntroScreen3ViewController.h"

@interface ATIntroScreen3ViewController ()

@end

@implementation ATIntroScreen3ViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseWallDistance:) name:kDidChooseWallDistance object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Private
-(IBAction)cameraButtonSelected:(id)sender
{
    //NSLog(@"Call a notification biatch");
}

- (IBAction)fakeCameraButtonSelected:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidSelectCameraButton object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidLoadFinalIntroScreen object:nil];
}

- (IBAction)getStartedButtonSelected:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
}

- (void)didChooseWallDistance:(NSNotification*)note
{
    NSDictionary *dict = [note userInfo];
    int tag = [[dict valueForKey:@"distanceButtonTag"] intValue];
//    [self deselectAllButtonsExcept:tag];
}

@end
