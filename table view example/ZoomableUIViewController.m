//
//  ZoomableUIViewController.m
//  table view example
//
//  Created by Jiamin Hu on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoomableUIViewController.h"

@interface ZoomableUIViewController ()
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer;
@end

@implementation ZoomableUIViewController
@synthesize myPhoto;
@synthesize fetcher;
@synthesize scrollView;
@synthesize imageView;
@synthesize label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setPhoto:(NSDictionary *)photo {
    myPhoto = photo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    fetcher = [[FlickrFetcher alloc] init];
    [super viewDidLoad];
    
    scrollView = [self.view.subviews objectAtIndex:0];
    label = [self.view.subviews objectAtIndex:1];
    imageView= [scrollView.subviews objectAtIndex:0];
    
    //set min and max scale for scroll view
    scrollView.minimumZoomScale=1;
    scrollView.maximumZoomScale=3.0;
    scrollView.delegate=self;
}

- (void)viewWillAppear:(BOOL)animated {
    NSURL *photoURL = [[fetcher class] urlForPhoto:myPhoto format:FlickrPhotoFormatLarge];
    NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
    
    
    UIImage *myImage = [UIImage imageWithData:imageData];
        
    //set title
    NSString *value = [myPhoto objectForKey:@"title"];
    if(!value || [value compare:@""] == 0) {
        value = [myPhoto valueForKeyPath:@"description._content"];
    }
    if(!value || [value compare:@""] == 0) {
        value = @"Unknown";
    }
    
    [label setText:value];
    [imageView setImage:myImage];

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {    
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;    
}

- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer {    
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;    
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, 
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
