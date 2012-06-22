//
//  PlaceTableViewController.m
//  table view example
//
//  Created by Jiamin Hu on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceTableViewController.h"
#import "PhotoTableViewController.h"
#import "FlickrFetcher.h"


@implementation PlaceTableViewController

@synthesize fetcher;
NSArray *places;


-(void)viewDidLoad {
    fetcher = [[FlickrFetcher alloc] init];
    self.tableView.rowHeight = 77;
    
    //fetch top place from flickr
    places = [[fetcher class] topPlaces];
    
    //sort by place name
    places = [places sortedArrayUsingComparator:^(id a, id b) {
        NSString *first = [(NSDictionary*)a valueForKey:@"_content"];
        NSString *second = [(NSDictionary*)b valueForKey:@"_content"];
        return [first caseInsensitiveCompare:second];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)sender 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //get a cell to use
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceDetail"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PlaceDetail"];
    }
    
    [self getAreaNameForRow:indexPath.row inSection:indexPath.section];
    cell.textLabel.text = [self getCityNameForRow:indexPath.row inSection:indexPath.section];
    cell.detailTextLabel.text = [self getAreaNameForRow:indexPath.row inSection:indexPath.section];
    return cell;
    
}

//"place_url" = "/Canada/British+Columbia/Vancouver"
- (NSString *)getCityName:(NSString *)content {
    return (NSString *)[[content pathComponents] lastObject];
}

- (NSString *)getCityNameForRow:(NSInteger)row inSection:(NSInteger)section {
    NSDictionary *item = (NSDictionary *)[places objectAtIndex:row];
    return [self getCityName:(NSString *)[item objectForKey:@"place_url"]];
}

- (NSString *)getAreaNameForRow:(NSInteger)row inSection:(NSInteger)section {
    NSDictionary *item = (NSDictionary *)[places objectAtIndex:row];
    NSString *placeURL = (NSString *)[item objectForKey:@"_content"];
    NSRange range = [placeURL rangeOfString:@", "];
    if(range.location != NSNotFound){
        return [placeURL substringFromIndex:(range.location + range.length)];
    }else {
        return @"";
    }
}

- (NSDictionary *)getMyDataForRow:(NSInteger)row inSection:(NSInteger)section {
    return (NSDictionary *)[places objectAtIndex:row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //go do sth based on information
    //aout my data structure corresponding to indexPath.row in indexPath.section
    NSDictionary *place = [self getMyDataForRow:indexPath.row inSection:indexPath.section];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"placeToPhoto"]){
        PhotoTableViewController *photoCtrl = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *selectedData = [self getMyDataForRow:selectedIndexPath.row inSection:selectedIndexPath.section];
        [photoCtrl setPlace:selectedData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section
{
    return [places count];
//    if([places count] > 0)
//        return [[places objectAtIndex:0] count];
//    return 0;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableView.delegate = self;
    }
    return self;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
