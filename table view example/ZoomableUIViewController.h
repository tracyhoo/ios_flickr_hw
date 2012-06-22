//
//  ZoomableUIViewController.h
//  table view example
//
//  Created by Jiamin Hu on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"

@interface ZoomableUIViewController : UIViewController <UIScrollViewDelegate> {
    FlickrFetcher *fetcher;
    
    
}

@property (nonatomic, retain) FlickrFetcher *fetcher;
@property (nonatomic, retain) NSDictionary *myPhoto;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;

- (void)setPhoto: (NSDictionary *) photo;

@end
