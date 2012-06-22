//
//  PhotoTableViewController.m
//  table view example
//
//  Created by Jiamin Hu on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "ZoomableUIViewController.h"

@interface PhotoTableViewController ()

@end

@implementation PhotoTableViewController
@synthesize myPlace;
@synthesize fetcher;
@synthesize thumbnailCell;

NSArray *photos;
dispatch_queue_t queue;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    fetcher = [[FlickrFetcher alloc] init];
    //fetch top photos in place
    if (myPlace) {
        photos = [[fetcher class] photosInPlace:myPlace maxResults:50];
    }
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)setPlace:(NSDictionary *)place {
    myPlace = place;
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
    return [photos count] > 0 ? [photos count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *MyIdentifier = @"PhotoThumbnailCell";
    cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ThumbnailCell" owner:self options:nil];
        cell = thumbnailCell;
        self.thumbnailCell = nil;
    }

    //set place title and its description
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    title.text = [self getPhotoTitle:indexPath.row inSection:indexPath.section];    
    UILabel *description = (UILabel *)[cell viewWithTag:2];
    description.text = [self getPhotoDescriptionForRow:indexPath.row inSection:indexPath.section];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:0];
    
    //async call to fetch photo
    dispatch_async(queue, ^{
        NSURL* url = [self getPhotoURLForRow:indexPath.row inSection:indexPath.section];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        
        //crop image and set it into imageview
        dispatch_sync(dispatch_get_main_queue(), ^{
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(10, 2, 42, 42));
            [imageView setImage:[UIImage imageWithCGImage:imageRef]]; 
            CGImageRelease(imageRef);
            [cell setNeedsLayout];
        });
    });
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"thumbToPhoto"]){
        //segue into zoomable photo view
        ZoomableUIViewController *ctrl = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *selectedData = [self getMyDataForRow:selectedIndexPath.row inSection:selectedIndexPath.section];
        [ctrl setPhoto:selectedData];
    }
}

- (NSDictionary *)getMyDataForRow:(NSInteger)row inSection:(NSInteger)section {
    return (NSDictionary *)[photos objectAtIndex:row];
}

- (NSString *)getPhotoDescriptionForRow:(NSInteger)row inSection:(NSInteger)section {
    NSDictionary *photo = (NSDictionary *)[photos objectAtIndex:row];
    NSString *description = [photo valueForKeyPath:@"description._content"];
    if(!description || [description compare:@""] == 0) {
        return @"Unknown";
    }
    return (NSString *)description;
}

- (NSURL *)getPhotoURLForRow:(NSInteger)row inSection:(NSInteger)section {
    NSDictionary *photo = (NSDictionary *)[photos objectAtIndex:row];
    NSURL *photoURL = [[fetcher class] urlForPhoto:photo format:FlickrPhotoFormatLarge];
    return photoURL;
}

- (NSString *)getPhotoTitle:(NSInteger)row inSection:(NSInteger)section {
    NSDictionary *photo = (NSDictionary *)[photos objectAtIndex:row];
    NSString *value = [photo objectForKey:@"title"];
    if(!value || [value compare:@""] == 0) {
        value = [photo valueForKeyPath:@"description._content"];
    }
    if(!value || [value compare:@""] == 0) {
        value = @"Unknown";
    }
    return (NSString *)value;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    NSDictionary *photo = [self getMyDataForRow:indexPath.row inSection:indexPath.section];
    // Navigation logic may go here. Create and push another view controller.
    
    ZoomableUIViewController *viewController = [[ZoomableUIViewController alloc] init];
    [viewController setPhoto:photo];
     // ...
   //   Pass the selected object to the new view controller.
     [self.navigationController pushViewController:viewController animated:YES];
     
}


@end
