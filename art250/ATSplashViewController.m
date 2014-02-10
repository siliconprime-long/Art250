//
//  ATSplashViewController.m
//  art250
//
//  Created by Winfred Raguini on 12/22/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATSplashViewController.h"
#import "ATGlobalConstants.h"
#import "ATHangitContainerViewController.h"
#import "ATArtContainerViewController.h"
@interface ATSplashViewController ()

@end

@implementation ATSplashViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Private

- (void)takePhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImageView *dottedLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x_frame.png"]];
    
    CGPoint viewCenter = CGPointMake(imagePicker.view.frame.size.height/2.0f, imagePicker.view.frame.size.width/2.0f - VIRTUAL_PAINTING_POS_Y_OFFSET);

    
    dottedLineView.center = viewCenter;
    
    [imagePicker.cameraOverlayView addSubview:dottedLineView];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker animated:NO completion:nil];
}

#pragma mark
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        ATArtContainerViewController *artContainerController = [[ATArtContainerViewController alloc] initWithNibName:@"ATArtContainerViewController" bundle:nil];
        [self presentViewController:artContainerController animated:NO completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
