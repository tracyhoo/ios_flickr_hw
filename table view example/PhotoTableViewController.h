//
//  PhotoTableViewController.h
//  table view example
//
//  Created by Jiamin Hu on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"

@interface PhotoTableViewController : UITableViewController {
        FlickrFetcher *fetcher;
        UITableViewCell *thumbnailCell;
}

@property (nonatomic, retain) FlickrFetcher *fetcher;
@property (nonatomic, retain) NSDictionary *myPlace;
@property (nonatomic, retain) IBOutlet UITableViewCell *thumbnailCell;

- (NSInteger)numberOfectionsInTableView:(UITableView *)sender;
- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section;
- (void)setPlace: (NSDictionary *) place;

@end


