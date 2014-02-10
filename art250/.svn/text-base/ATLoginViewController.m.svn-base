//
//  ATLoginViewController.m
//  art250
//
//  Created by Winfred Raguini on 10/13/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATLoginViewController.h"
#import "ATAPIClient.h"

@interface ATLoginViewController ()

@end

@implementation ATLoginViewController

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
    self.title = @"Log in with email";
    // Do any additional setup after loading the view from its nib.
    self.preferredContentSize = self.navigationController.view.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInButtonSelected:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kwillLogInNotification object:nil];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailTextField.text, @"email", self.passwordTextField.text, @"password", nil];
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjectsAndKeys:params, @"user", nil];
    
    [[ATAPIClient sharedClient] postPath:@"users/sign_in.json" parameters:userParams success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *responseDict = responseObject;
        NSLog(@"responseDict %@", responseDict);
        if ([[responseDict objectForKey:@"success"] intValue] == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidLogInWithEmailNotification object:nil userInfo:responseDict];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidLoginNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidFailLoginNotification object:nil];
            UIAlertView *failedLogin = [[UIAlertView alloc] initWithTitle:@"Could not log in" message:@"Incorrect email or password" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [failedLogin show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidFailLoginNotification object:nil];

    }];
}

@end
