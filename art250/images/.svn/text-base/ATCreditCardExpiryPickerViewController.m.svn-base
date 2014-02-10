//
//  ATCreditCardExpiryPickerControllerViewController.m
//  art250
//
//  Created by Winfred Raguini on 5/5/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCreditCardExpiryPickerViewController.h"

@interface ATCreditCardExpiryPickerViewController ()

@end

@implementation ATCreditCardExpiryPickerViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.monthArray = [[NSArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug",
         @"Sept", @"Oct", @"Nov", @"Dec", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.preferredContentSize = CGSizeMake(320.0, 240.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 12;
    } else {
        return 10;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%@ - %d",[self.monthArray objectAtIndex:row], row + 1];
    } else {
        NSDateComponents *dateComps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
        return [NSString stringWithFormat:@"%d", [dateComps year] + row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        if ([self.delegate respondsToSelector:@selector(didSelectExpiryMonth:)]) {
            int month = row + 1;
            [self.delegate performSelector:@selector(didSelectExpiryMonth:) withObject:[NSNumber numberWithInt:month]];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(didSelectExpiryYear:)]) {
            NSDateComponents *dateComps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
            [self.delegate performSelector:@selector(didSelectExpiryYear:) withObject:[NSNumber numberWithInt:[dateComps year] + row]];
        }
    }
    
        
    
}




@end
