//
//  PlaceTableViewController.h
//  table view example
//
//  Created by Jiamin Hu on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"

@interface PlaceTableViewController : UITableViewController{
    FlickrFetcher *fetcher;
}

- (NSInteger)numberOfectionsInTableView:(UITableView *)sender;
- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section;
@property (nonatomic, retain) FlickrFetcher *fetcher;

@end
