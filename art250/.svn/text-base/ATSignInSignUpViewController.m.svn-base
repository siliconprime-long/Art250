//
//  ATSignInSignUpViewController.m
//  art250
//
//  Created by Winfred Raguini on 10/12/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATSignInSignUpViewController.h"
#import "ATCreateAccountViewController.h"
#import "ATLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ATUserManager.h"

@interface ATSignInSignUpViewController ()

@end

@implementation ATSignInSignUpViewController

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
    
    self.preferredContentSize = CGSizeMake(450, 422);
    
    self.title = @"Log in";
    

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonSelected:)];
    
    self.navigationItem.rightBarButtonItem = closeButton;
    
    [self.fbLoginView setDelegate:[ATUserManager sharedManager]];
   
}

- (void)viewWillAppear:(BOOL)animated
{


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeButtonSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(closeSignInSignUpSelected)]) {
        [self.delegate performSelector:@selector(closeSignInSignUpSelected) withObject:nil];
    }
}

-(IBAction)signInSelected:(id)sender {
    ATLoginViewController *loginController = [[ATLoginViewController alloc] initWithNibName:@"ATLoginViewController" bundle:nil];
    
    [self.navigationController pushViewController:loginController animated:YES];
}

-(IBAction)signUpSelected:(id)sender {
    ATCreateAccountViewController *signUpController = [[ATCreateAccountViewController alloc] initWithNibName:@"ATCreateAccountViewController" bundle:nil];
    
    [self.navigationController pushViewController:signUpController animated:YES];
}

@end
