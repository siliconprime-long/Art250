//
//  ATCreateAcccountViewController.m
//  art250
//
//  Created by Winfred Raguini on 10/13/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCreateAccountViewController.h"
#import "ATAPIClient.h"

@interface ATCreateAccountViewController ()

@end

@implementation ATCreateAccountViewController

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
    
    self.title = @"Create an account";
    self.preferredContentSize = CGSizeMake(450, 422);
    
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)passwordDisplayButtonSelected:(id)sender {
    if (self.passwordTextField.isSecureTextEntry) {
        [self.passwordTextField setSecureTextEntry:NO];
        [self.passwordDisplayButton setTitle:@"HIDE" forState:UIControlStateNormal];
    } else {
        [self.passwordTextField setSecureTextEntry:YES];
        [self.passwordDisplayButton setTitle:@"SHOW" forState:UIControlStateNormal];
    }
}

- (IBAction)signUpButtonSelected:(id)sender
{
    //First validate to make sure they have all the fields filled out
    
    //Also test if password is good
    if ([self.nameTextField.text length] > 0 && [self.emailTextField.text length] > 0 && [self.passwordTextField.text length] >= 6) {
    
        NSDictionary *verifyParams = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailTextField.text, @"email", nil];
        //First check to make sure the user doesn't already exist
        [[ATAPIClient sharedClient] getPath:@"users/verify.json" parameters:verifyParams success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSDictionary *responseDict = responseObject;
            if ([[responseDict objectForKey:@"unique"] intValue] == 1) {
                [self createAccount];
            } else {
                
                UIAlertView *failedLogin = [[UIAlertView alloc] initWithTitle:@"Could not create an account" message:@"Someone is already using this email - you may already have an account." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [failedLogin show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidFailLoginNotification object:nil];
        }];
        
    } else {
        UIAlertView *alert;
        if ([self.passwordTextField.text length] < 6) {
            alert = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Password must be at least 6 characters." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        } else {
            alert = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Please enter all fields." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        }
        [alert show];
        
    }
}

- (void)createAccount
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kwillLogInNotification object:nil];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailTextField.text, @"email", self.passwordTextField.text, @"password", self.passwordTextField.text, @"password_confirmation", nil];
    NSDictionary *userParams = [[NSDictionary alloc] initWithObjectsAndKeys:params, @"user", @"ipad", @"type",self.nameTextField.text, @"name",nil];
    
    [[ATAPIClient sharedClient] postPath:@"users.json" parameters:userParams success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *responseDict = responseObject;
        if ([[responseDict objectForKey:@"success"] intValue] == 1) {
            NSArray *nameArray = [self.nameTextField.text componentsSeparatedByString:@" "];
            NSString *firstName = [nameArray objectAtIndex:0];
            NSString *lastName = [nameArray lastObject];
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys: firstName, @"first_name", lastName, @"last_name", nil];
            NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo, @"user", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidLogInWithEmailNotification object:nil userInfo:userDict];
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidLoginNotification object:userDict];
        } else {
            UIAlertView *failedLogin = [[UIAlertView alloc] initWithTitle:@"Could not log in" message:@"Incorrect email or password" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [failedLogin show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[NSNotificationCenter defaultCenter] postNotificationName:kdidFailLoginNotification object:nil];
        UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Could not connect to server." message:@"Please try again later." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [failedAlert show];
    }];
}

- (void)textFieldDidChange:(id)sender
{
    UITextField *passwordField = (UITextField*)sender;
    
    if ([passwordField.text length] >= 6) {
        [self.passwordLengthWarningLabel setHidden:YES];
    } else {
        [self.passwordLengthWarningLabel setHidden:NO];
    }
}

@end
