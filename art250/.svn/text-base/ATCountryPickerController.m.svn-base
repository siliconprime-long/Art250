//
//  ATCountryPickerControllerViewController.m
//  art250
//
//  Created by Winfred Raguini on 3/21/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCountryPickerController.h"

@interface ATCountryPickerController ()

@end

@implementation ATCountryPickerController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.countryArray = [NSArray arrayWithObjects: @"United States",
                         @"Afghanistan",
                         @"Albania",
                         @"Algeria",
                         @"American Samoa",
                         @"Andorra",
                         @"Angola",
                         @"Anguilla",
                         @"Antarctica",
                         @"Antigua And Barbuda",
                         @"Argentina",
                         @"Armenia",
                         @"Aruba",
                         @"Australia",
                         @"Austria",
                         @"Azerbaijan",
                         @"Bahamas",
                         @"Bahrain",
                         @"Bangladesh",
                         @"Barbados",
                         @"Belarus",
                         @"Belgium",
                         @"Belize",
                         @"Benin",
                         @"Bermuda",
                         @"Bhutan",
                         @"Bolivia",
                         @"Bosnia And Herzegovina",
                         @"Botswana",
                         @"Bouvet Island",
                         @"Brazil",
                         @"British Indian Ocean Territory",
                         @"Brunei Darussalam",
                         @"Bulgaria",
                         @"Burkina Faso",
                         @"Burundi",
                         @"Cambodia",
                         @"Cameroon",
                         @"Canada",
                         @"Cape Verde",
                         @"Cayman Islands",
                         @"Central African Republic",
                         @"Chad",
                         @"Chile",
                         @"China",
                         @"Christmas Island",
                         @"Cocos (keeling) Islands",
                         @"Colombia",
                         @"Comoros",
                         @"Congo",
                         @"Congo, The Democratic Republic Of The",
                         @"Cook Islands",
                         @"Costa Rica",
                         @"Cote D'ivoire",
                         @"Croatia",
                         @"Cuba",
                         @"Cyprus",
                         @"Czech Republic",
                         @"Denmark",
                         @"Djibouti",
                         @"Dominica",
                         @"Dominican Republic",
                         @"East Timor",
                         @"Ecuador",
                         @"Egypt",
                         @"El Salvador",
                         @"Equatorial Guinea",
                         @"Eritrea",
                         @"Estonia",
                         @"Ethiopia",
                         @"Falkland Islands (malvinas)",
                         @"Faroe Islands",
                         @"Fiji",
                         @"Finland",
                         @"France",
                         @"French Guiana",
                         @"French Polynesia",
                         @"French Southern Territories",
                         @"Gabon",
                         @"Gambia",
                         @"Georgia",
                         @"Germany",
                         @"Ghana",
                         @"Gibraltar",
                         @"Greece",
                         @"Greenland",
                         @"Grenada",
                         @"Guadeloupe",
                         @"Guam",
                         @"Guatemala",
                         @"Guinea",
                         @"Guinea-bissau",
                         @"Guyana",
                         @"Haiti",
                         @"Heard Island And Mcdonald Islands",
                         @"Holy See (vatican City State)",
                         @"Honduras",
                         @"Hong Kong",
                         @"Hungary",
                         @"Iceland",
                         @"India",
                         @"Indonesia",
                         @"Iran, Islamic Republic Of",
                         @"Iraq",
                         @"Ireland",
                         @"Israel",
                         @"Italy",
                         @"Jamaica",
                         @"Japan",
                         @"Jordan",
                         @"Kazakstan",
                         @"Kenya",
                         @"Kiribati",
                         @"Korea, Democratic People's Republic Of",
                         @"Korea, Republic Of",
                         @"Kosovo",
                         @"Kuwait",
                         @"Kyrgyzstan",
                         @"Lao People's Democratic Republic",
                         @"Latvia",
                         @"Lebanon",
                         @"Lesotho",
                         @"Liberia",
                         @"Libyan Arab Jamahiriya",
                         @"Liechtenstein",
                         @"Lithuania",
                         @"Luxembourg",
                         @"Macau",
                         @"Macedonia, The Former Yugoslav Republic Of",
                         @"Madagascar",
                         @"Malawi",
                         @"Malaysia",
                         @"Maldives",
                         @"Mali",
                         @"Malta",
                         @"Marshall Islands",
                         @"Martinique",
                         @"Mauritania",
                         @"Mauritius",
                         @"Mayotte",
                         @"Mexico",
                         @"Micronesia, Federated States Of",
                         @"Moldova, Republic Of",
                         @"Monaco",
                         @"Mongolia",
                         @"Montserrat",
                         @"Montenegro",
                         @"Morocco",
                         @"Mozambique",
                         @"Myanmar",
                         @"Namibia",
                         @"Nauru",
                         @"Nepal",
                         @"Netherlands",
                         @"Netherlands Antilles",
                         @"New Caledonia",
                         @"New Zealand",
                         @"Nicaragua",
                         @"Niger",
                         @"Nigeria",
                         @"Niue",
                         @"Norfolk Island",
                         @"Northern Mariana Islands",
                         @"Norway",
                         @"Oman",
                         @"Pakistan",
                         @"Palau",
                         @"Palestinian Territory, Occupied",
                         @"Panama",
                         @"Papua New Guinea",
                         @"Paraguay",
                         @"Peru",
                         @"Philippines",
                         @"Pitcairn",
                         @"Poland",
                         @"Portugal",
                         @"Puerto Rico",
                         @"Qatar",
                         @"Reunion",
                         @"Romania",
                         @"Russian Federation",
                         @"Rwanda",
                         @"Saint Helena",
                         @"Saint Kitts And Nevis",
                         @"Saint Lucia",
                         @"Saint Pierre And Miquelon",
                         @"Saint Vincent And The Grenadines",
                         @"Samoa",
                         @"San Marino",
                         @"Sao Tome And Principe",
                         @"Saudi Arabia",
                         @"Senegal",
                         @"Serbia",
                         @"Seychelles",
                         @"Sierra Leone",
                         @"Singapore",
                         @"Slovakia",
                         @"Slovenia",
                         @"Solomon Islands",
                         @"Somalia",
                         @"South Africa",
                         @"South Sudan",
                         @"South Georgia And The South Sandwich Islands",
                         @"Spain",
                         @"Sri Lanka",
                         @"Sudan",
                         @"Suriname",
                         @"Svalbard And Jan Mayen",
                         @"Swaziland",
                         @"Sweden",
                         @"Switzerland",
                         @"Syrian Arab Republic",
                         @"Taiwan, Province Of China",
                         @"Tajikistan",
                         @"Tanzania, United Republic Of",
                         @"Thailand",
                         @"Togo",
                         @"Tokelau",
                         @"Tonga",
                         @"Trinidad And Tobago",
                         @"Tunisia",
                         @"Turkey",
                         @"Turkmenistan",
                         @"Turks And Caicos Islands",
                         @"Tuvalu",
                         @"Uganda",
                         @"Ukraine",
                         @"United Arab Emirates",
                         @"United Kingdom",
                         @"United States Minor Outlying Islands",
                         @"Uruguay",
                         @"Uzbekistan",
                         @"Vanuatu",
                         @"Venezuela",
                         @"Viet Nam",
                         @"Virgin Islands, British",
                         @"Virgin Islands, U.s.",
                         @"Wallis And Futuna",
                         @"Western Sahara",
                         @"Yemen",
                         @"Zambia",
                         @"Zimbabwe", nil];

    self.preferredContentSize = CGSizeMake(150.0, 140.0);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.countryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.countryArray objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectCountry:)]) {
        NSString *countryString = [self.countryArray objectAtIndex:indexPath.row];
        [self.delegate performSelector:@selector(didSelectCountry:) withObject:countryString];
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
