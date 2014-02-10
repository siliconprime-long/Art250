//
//  ATWalkThroughView1Controller.m
//  art250
//
//  Created by Winfred Raguini on 5/29/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATWalkThroughView1Controller.h"
#import "ATUserManager.h"

@interface ATWalkThroughView1Controller ()

@end

@implementation ATWalkThroughView1Controller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.slideImageViewURLString = @"launch_start_clear.png";
        //self.swipeyString = @"Swipe to begin.";
        //self.descriptionString = NSLocalizedString(@"Original art from the artist to your wall for only $250!",nil);
        //self.slideImageView.image = [UIImage imageNamed:@"launch_start_clear.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.descriptionLabel.textColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    
    //Add the FB login stuff
    //Add FB login
    FBLoginView *loginView =  [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email"]];
    
    [loginView setDelegate:[ATUserManager sharedManager]];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame,
                                   (self.view.center.x - (loginView.frame.size.width / 2)),
                                   self.view.frame.size.height - loginView.frame.size.height - 50.0f);
    [self.view addSubview:loginView];
    [loginView sizeToFit];
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //this will be replaced
    [skipButton setBackgroundImage:[UIImage imageNamed:@"skip_launch_screen.png"] forState:UIControlStateNormal];
    [skipButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:17.0f]];
    [skipButton.titleLabel setTextColor:[UIColor whiteColor]];
    [skipButton addTarget:self action:@selector(skipButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGRect skipButtonFrame = loginView.frame;
    skipButtonFrame.origin.x = skipButtonFrame.origin.x + 250.0f;
    skipButtonFrame.size.width = 133.0f;
    skipButtonFrame.size.height = 45.0f;
    [skipButton setFrame:skipButtonFrame];
    [self.view addSubview:skipButton];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:kdidLoginNotification object:nil];
    [self.actionButton setHidden:YES];
    
    //[self performSelector:@selector(swipeToLastPage) withObject:nil afterDelay:5.0f];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)skipButtonSelected:(id)sender
{
    [self swipeToLastPage];
}

- (void)swipeToLastPage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kdidLoadSplashPageNotification object:nil];
}

- (void)didLogin:(NSNotification*)note
{
    
    [self swipeToLastPage];
}



@end
