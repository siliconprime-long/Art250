//
//  ATIntroScreen2ViewController.m
//  art250
//
//  Created by Winfred Raguini on 2/14/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATIntroScreen2ViewController.h"

@interface ATIntroScreen2ViewController ()

@end

@implementation ATIntroScreen2ViewController

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
    //NSLog(@"Loaded screen 2");
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseContinueButton object:nil userInfo:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cameraButtonSelected:(id)sender
{
 
}

- (IBAction)didChooseContinueButton:(id)selector
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:3],@"currentPage", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseContinueButton object:nil userInfo:dict];
    
    [self performSelector:@selector(freezeScreen) withObject:nil afterDelay:0.5];
}

- (void)freezeScreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kshouldFreezeScreen object: nil];
}


- (void)didChooseWallDistance:(NSNotification*)note
{
    NSDictionary *dict = [note userInfo];
    int tag = [[dict valueForKey:@"distanceButtonTag"] intValue];
//    [self deselectAllButtonsExcept:tag];
}

@end
