//
//  ATArtistsDirectoryViewController.m
//  art250
//
//  Created by Winfred Raguini on 11/29/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATArtistsDirectoryViewController.h"
#import "ATDatabaseManager.h"
#import "ArtistProfile.h"
#import "SearchableArtistProfile.h"
#import "ATArtManager.h"

@interface ATArtistsDirectoryViewController ()
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *miscArtistProfilesArray;
@property (nonatomic, strong) NSArray *searchResults;
- (SearchableArtistProfile*)artistForIndexPath:(NSIndexPath*)indexPath;
@end

@implementation ATArtistsDirectoryViewController

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
    
    
    [self.searchDisplayController.searchBar setBarTintColor:[UIColor blackColor]];
    [self.searchDisplayController.searchBar setBackgroundColor:[UIColor whiteColor]];
    

    
    self.sectionArray = [NSArray arrayWithObjects:@"*", @"A", @"B", @"C", @"D",
                        @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M",
                        @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W",
                        @"X", @"Y", @"Z",nil];
    
    //Index title color
    [self.tableView setSectionIndexColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.7f]];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    
    [self.tableView setSeparatorColor:[[UIColor alloc] initWithRed:47.0f/255.0f green:47.0f/255.0f blue:47.0f/255.0f alpha:1.0f]];
    [self.searchDisplayController.searchResultsTableView setSectionIndexColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.7f]];
    [self.searchDisplayController.searchResultsTableView setSectionIndexBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f]];
    
    [self.navigationItem setTitle:@"Artist Directory"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  NSForegroundColorAttributeName, [UIFont fontWithName:@"ProximaNova-Semibold" size:17.0f], NSFontAttributeName, nil]];
    
    //[[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor clearColor]];
    
    NSManagedObjectContext *ctx = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    
    NSArray *artistObjectsIDs = [[ATArtManager sharedManager] artistDirectoryObjectIDs];
    NSMutableArray *miscMutableObjectIDArray = [[NSMutableArray alloc] init];
    for (NSManagedObjectID *profileObjectID in artistObjectsIDs) {

        SearchableArtistProfile *artistProfile = (SearchableArtistProfile*)[ctx objectWithID:profileObjectID];
        if (![artistProfile.firstName hasPrefix:@"A"] && ![artistProfile.firstName hasPrefix:@"a"]) {
            [miscMutableObjectIDArray addObject:artistProfile];
        } else {
            break;
        }
    }
    
    self.miscArtistProfilesArray = [NSArray arrayWithArray:miscMutableObjectIDArray];

//    
//    for (UIView *view in self.searchDisplayController.searchBar.subviews)
//    {
//        if ([view isKindOfClass:NSClassFromString
//             (@"UISearchBarBackground")])
//        {
//            [view removeFromSuperview];
//            break;
//        }
//    }
//    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 
#pragma mark UITableViewDelegate

#pragma mark
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        return 1;
    } else {
        return [self.sectionArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        return [self.searchResults count];
    } else {
        NSString *sectionLetter = [self.sectionArray objectAtIndex:section];
        
        //NSLog( @"Section letter: %@ for section: %d", sectionLetter, section);
        int count = 0;
        if ([sectionLetter isEqualToString:@"*"]) {
            count = [self.miscArtistProfilesArray count];
        } else {
            count = [SearchableArtistProfile countOfArtistProfilesBeginningWith:sectionLetter];
//            
//            NSArray *artistProfiles = [SearchableArtistProfile artistProfilesBeginningWith:sectionLetter];
//            
//            for (ArtistProfile *artistProfile in artistProfiles){
//                NSLog( @"name: %@ %@ profileID: %d objectID: %@", artistProfile.firstName, artistProfile.lastName, [artistProfile.profileID intValue], artistProfile.objectID);
//            }
        }
        
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    }
    
    SearchableArtistProfile *artistProfile;
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        artistProfile = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        artistProfile = [self artistForIndexPath:indexPath];
    }
    
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:14.0f]];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", artistProfile.firstName, artistProfile.lastName]];
    return cell;

}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchableArtistProfile *artistProfile;
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        artistProfile = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        artistProfile = [self artistForIndexPath:indexPath];
    }
    //NSLog(@"Search for artwork from %@ %@", artistProfile.firstName, artistProfile.lastName);
    if ([self.delegate respondsToSelector:@selector(showArtworkForArtistProfile:)]) {
        [self.delegate performSelector:@selector(showArtworkForArtistProfile:) withObject:artistProfile];
    }
}

- (SearchableArtistProfile*)artistForIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return [self.miscArtistProfilesArray objectAtIndex:indexPath.row];
    } else {
        NSString *sectionLetter = [self.sectionArray objectAtIndex:indexPath.section];
        NSArray *profilesForLetter = [SearchableArtistProfile artistProfilesBeginningWith:sectionLetter];
        return [profilesForLetter objectAtIndex:indexPath.row];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        return nil;
    } else {
        return self.sectionArray;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        return nil;
    } else {
        return [self.sectionArray objectAtIndex:section];
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    UIColor *darkGrayColor = [[UIColor alloc] initWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    [headerView setBackgroundColor:darkGrayColor];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, self.tableView.bounds.size.width, 23.0f)];
    
    
    [sectionLabel setTextColor:[UIColor whiteColor]];
    [sectionLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:14.0f]];
    
    [sectionLabel setText:[self.sectionArray objectAtIndex:section]];
    
    [headerView addSubview:sectionLabel];
    
    return headerView;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
//    NSPredicate *resultPredicate = [NSPredicate
//                                    predicateWithFormat:@"SELF contains[cd] %@",
//                                    searchText];
//    
//    NSLog( @"This is scope %@", scope);
    self.searchResults = [SearchableArtistProfile artistProfilesWithSearchString:searchText];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //[self setCorrectSearchBarFrames];
    [self.tableView setHidden:YES];
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.tableView setHidden:NO];
}



@end
