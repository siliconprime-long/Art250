//
//  ATIntroViewController.m
//  art250
//
//  Created by Winfred Raguini on 2/15/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATIntroViewController.h"
#import "ATArtManager.h"

@interface ATIntroViewController () {
    BOOL didChooseWallDistance;
}
- (void)switchToNextPage:(NSNotification*)note;
@end

@implementation ATIntroViewController

CGFloat scrollViewx;

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
    self.backgroundView.image = [[ATArtManager sharedManager] artworkSplashImage];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCompleteWalkthrough:) name:kDidCompleteWalkthrough object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freezeIntroScreen) name:kshouldFreezeScreen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseContinueButton:) name:kdidChooseContinueButton object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadSplashPage:) name:kdidLoadSplashPageNotification object:nil];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.frame.size.height);
    
//    [self.scrollView setUserInteractionEnabled:NO];
    
    [self.pageControl setHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //NSLog(@"yeah scrolling");
//    if (!didChooseWallDistance) {
//        [scrollView setContentOffset: CGPointMake(scrollViewx, 0)];
//    }
//}

- (void)freezeIntroScreen
{
    scrollViewx = self.scrollView.contentOffset.x;
    didChooseWallDistance = NO;
}



- (void)didChooseContinueButton:(NSNotification*)note
{
    didChooseWallDistance = YES;
    int page = [[[note userInfo] objectForKey:@"currentPage"] intValue];
    [self changePageFromCurrentPage:page];
}

- (void)switchToNextPage:(NSNotification*)note
{
    int page = [[[note userInfo] objectForKey:@"currentPage"] intValue];
    [self changePageFromCurrentPage:page];
}

//- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
//{
//    [aScrollView setContentOffset: CGPointMake(0, aScrollView.contentOffset.y)];
//    // or if you are sure you wanna it always on left:
//    // [aScrollView setContentOffset: CGPointMake(0, aScrollView.contentOffset.y)];
//}

- (void)didCompleteWalkthrough:(NSNotification*)note
{
    [self.backgroundView setHidden:YES];
}

- (void)didLoadSplashPage:(NSNotification*)note
{
    [self scrollToLastPage];
}

- (void)scrollToLastPage
{
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width/2, 0.0f, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
}

@end
