//
//  ATFTDWalkthrough3ViewController.m
//  art250
//
//  Created by Winfred Raguini on 8/20/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATFTDWalkthrough3ViewController.h"

@interface ATFTDWalkthrough3ViewController ()
@property (nonatomic, strong) UIImageView *animatingView1;
@property (nonatomic, strong) UIImageView *animatingView2;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ATFTDWalkthrough3ViewController

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
    
    

    // Do any additional setup after loading the view from its nib.
    [self.view setClipsToBounds:YES];
    
    self.animatingView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"art_purp.png"]];
    self.animatingView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"art_yeller.png"]];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 3);
    
    CGRect animatingView1Frame = self.animatingView1.frame;
    animatingView1Frame.origin.x = self.view.frame.size.width/2 - self.animatingView1.frame.size.width/2;
    animatingView1Frame.origin.y = self.view.frame.size.height + 30.0f;
    [self.animatingView1 setFrame:animatingView1Frame];
    
    [self.scrollView addSubview:self.animatingView1];
    
    CGRect animatingView2Frame = self.animatingView2.frame;
    animatingView2Frame.origin.x = self.view.frame.size.width/2 - self.animatingView2.frame.size.width/2;
    animatingView2Frame.origin.y = self.view.frame.size.height * 2 + 40.0f;
    [self.animatingView2 setFrame:animatingView2Frame];
    
    [self.scrollView addSubview:self.animatingView2];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.scrollView scrollRectToVisible:CGRectMake(0.0f, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
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
    
    [UIView animateWithDuration:1.5f delay:2.0f options:nil animations:^(void){
        [self.scrollView scrollRectToVisible:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.5f delay:1.0f options: nil
                         animations:^(void){
                             [self.scrollView scrollRectToVisible:CGRectMake(0.0f, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
                         }completion:^(BOOL finished){
                             [UIView animateWithDuration:1.0f delay:0.3f options: nil
                                              animations:^(void){
                                                  [self.scrollView scrollRectToVisible:CGRectMake(0.0f, self.view.frame.size.height * 2, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
                                              }completion:^(BOOL finished){
                                                  
                                                  
                                              }];
                         }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
