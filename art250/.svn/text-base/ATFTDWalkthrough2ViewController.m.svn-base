//
//  ATFTDWalkthrough1ViewController.m
//  art250
//
//  Created by Winfred Raguini on 8/20/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATFTDWalkthrough2ViewController.h"

@interface ATFTDWalkthrough2ViewController ()
@property (nonatomic, strong) UIImageView *animatingView1;
@property (nonatomic, strong) UIImageView *animatingView2;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ATFTDWalkthrough2ViewController

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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(animatePaintings) userInfo:nil repeats:YES];
    
    [self.view setClipsToBounds:YES];
    
    self.animatingView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"art_purp.png"]];
    self.animatingView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"art_yeller.png"]];
    // Do any additional setup after loading the view from its nib.
    self.aScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);
    
    CGRect animatingView2Frame = self.animatingView2.frame;
    animatingView2Frame.origin.x = self.view.frame.size.width + (self.view.frame.size.width/2 - self.animatingView2.frame.size.width/2);
    animatingView2Frame.origin.y = 40.0f;
    [self.animatingView2 setFrame:animatingView2Frame];
    
    [self.aScrollView addSubview:self.animatingView2];
    
    CGRect animatingView1Frame = self.animatingView1.frame;
    animatingView1Frame.origin.x = self.view.frame.size.width * 2 + (self.view.frame.size.width/2 - self.animatingView1.frame.size.width/2);
    animatingView1Frame.origin.y = 30.0f;
    [self.animatingView1 setFrame:animatingView1Frame];
    
    [self.aScrollView addSubview:self.animatingView1];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.aScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0.0f, self.view.frame.size.width, self.view.frame.size.height) animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [[ATTrackingManager sharedManager] trackEvent:FL_STARTED_FTD_TOUR timed:YES];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(animatePaintings) userInfo:nil repeats:YES];
    
    [self.timer fire];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)animatePaintings
{
    
    [self performSelector:@selector(doAnimation) withObject:nil afterDelay:1.0f];
}

- (void)doAnimation
{
    [UIView animateWithDuration:1.5f delay:2.0f options: nil
                     animations:^(void){
                         [self.aScrollView scrollRectToVisible:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
                     }completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:1.5f delay:1.0f options:nil animations:^(void){
                             [self.aScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0.0f, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
                             
                         } completion:^(BOOL finished){
                             [UIView animateWithDuration:1.0f delay:0.3f options:nil animations:^(void){
                                 [self.aScrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width * 2, 0.0f, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
                             } completion:nil];
                         }];
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
