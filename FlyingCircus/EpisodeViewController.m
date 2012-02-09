//
//  DetailViewController.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/8/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "EpisodeViewController.h"

#import "Episode.h"
#import "Part.h"

@interface EpisodeViewController ()
- (void)configureView;
- (void)embedYouTube:(NSString*)url frame:(CGRect)frame;
@end

@implementation EpisodeViewController

@synthesize episode = _episode;
@synthesize webViews = _webViews;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize partsContainer = _partsContainer;

#pragma mark - Managing the detail item

- (void)setEpisode:(id)newEpisode
{
    if (_episode != newEpisode) {
        _episode = newEpisode;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.episode) {
        self.detailDescriptionLabel.text = [self.episode title];
        
        // Generate as many web views as the episode's parts
        for (Part *part in self.episode.parts) {
            UIWebView *aWebView = [[UIWebView alloc] initWithFrame:self.partsContainer.frame];
            
            aWebView.tag = [part.number intValue];
            [self.webViews addObject:aWebView];
            
        }
        
        //[self embedYouTube:self.episode.url frame:CGRectMake(40, 45, 240, 128)];
    }
}

- (void)embedYouTube:(NSString*)url frame:(CGRect)frame {  
    NSString* embedHTML = @"\
                            <html>\
                                <head>\
                                <style type=\"text/css\">\
                                body {\
                                    background-color: transparent;\
                                    color: white;\
                                }\
                                </style>\
                                </head>\
                                <body style=\"margin:0\">\
                                    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
                                            width=\"%0.0f\" height=\"%0.0f\"></embed>\
                                </body>\
                            </html>";  
    
    NSString* html = [NSString stringWithFormat:
                      embedHTML, 
                      url, 
                      frame.size.width, 
                      frame.size.height];

    //if(self.videoView == nil) {  
    //    self.videoView = [[UIWebView alloc] initWithFrame:frame];  
    //    [self.view addSubview:self.videoView];  
    //}  
    //[self.videoView loadHTMLString:html baseURL:nil];  
}  

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
@end
