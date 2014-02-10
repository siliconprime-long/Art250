//
//  ATRoomMenuViewController.m
//  art250
//
//  Created by Winfred Raguini on 12/1/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATRoomMenuViewController.h"
#import "ATImagePickerViewController.h"
#import "ATCameraOverlayViewController.h"

@interface ATRoomMenuViewController ()
@property (nonatomic, strong) ATImagePickerViewController *imagePicker;
@property (nonatomic, strong) ATCameraOverlayViewController *cameraOverlayController;
@property (nonatomic, strong) UIPopoverController *photoPickerPopoverController;
@end

@implementation ATRoomMenuViewController

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
    
    [self.navigationItem setTitle:@"Room"];
    self.menuArray = [NSArray arrayWithObjects:@"New Photo", @"Import Photo", @"Use Sample Room", @"Change Size of Artwork", nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.row) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeHideMenuDockNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeTakePhotoNotification object:nil];
            break;
        case 1:
            [self chooseExistingPhoto];
            break;
        case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeHideMenuDockNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeUseSampleRoomNotification object:nil];
            break;
        case 3:
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeHideMenuDockNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeChangeArtworkSizeNotification object:nil];
            break;
    }
    
    
    
}

- (void)chooseExistingPhoto
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:kdidChooseNewPhotoOptionNotification object:nil];
    if ([self.delegate respondsToSelector:@selector(hideSlideOutView)]) {
        [self.delegate performSelectorOnMainThread:@selector(hideSlideOutView) withObject:nil waitUntilDone:YES];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kdidInvokeImportPhotoNotification object:nil];
}



@end
