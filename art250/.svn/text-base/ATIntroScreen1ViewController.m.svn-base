//
//  ATIntroScreen1ViewController.m
//  art250
//
//  Created by Winfred Raguini on 2/14/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATIntroScreen1ViewController.h"
#import "ATIntroViewController.h"

@interface ATIntroScreen1ViewController ()

@end

@implementation ATIntroScreen1ViewController

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
    
//    [self.standingMan setAnimationDuration:3.0f];
//    [self.standingMan startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidCompleteWalkthrough object:nil];
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
 
}

- (IBAction)didChooseContinueButton:(id)selector
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:2],@"currentPage", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseContinueButton object:nil userInfo:dict];
    
    [self performSelector:@selector(freezeScreen) withObject:nil afterDelay:0.5];
}

- (void)freezeScreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kshouldFreezeScreen object: nil];
}


- (void)didChooseWallDistance:(NSNotification*)note
{
    [self.continueButton setEnabled:YES];
    
    NSDictionary *userInfo = [note userInfo];
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect standingManFrame = self.standingMan.frame;
                         switch ([[userInfo objectForKey:@"distanceButtonTag"] intValue]) {
                             case 0:
                                 standingManFrame.origin.y = -200;
                                 break;
                             case 1:
                                 standingManFrame.origin.y = -100;
                                 break;
                             default:
                                 standingManFrame.origin.y = 0;
                                 break;
                         }
                         
                         [self.standingMan setFrame:standingManFrame];
                     }
                     completion:^(BOOL finished){
                         if(finished) {
                            
                         }
                             //NSLog(@"Finished !!!!!");
                         // do any stuff here if you want
                     }];
    
}


@end
