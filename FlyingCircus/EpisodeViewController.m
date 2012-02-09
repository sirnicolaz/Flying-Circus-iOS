//
//  DetailViewController.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/8/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "EpisodeViewController.h"
#import "PartView.h"

#import "Episode.h"
#import "Part.h"

@interface EpisodeViewController (Private) 
- (void)configureView;
- (void)displayPart:(int)number;
@end

@implementation EpisodeViewController

@synthesize episode                 = _episode;
@synthesize videoContainerView      = _videoContainerView;
@synthesize detailDescriptionLabel  = _detailDescriptionLabel;
@synthesize currentPartLabel        = _currentPartLabel;
@synthesize currentPart             = _currentPart;


- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
              episode:(Episode*)anEpisode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.episode = anEpisode;
    
    return self;
}

#pragma mark - Managing the detail item

- (void)setEpisode:(id)newEpisode
{
    if (_episode != newEpisode) {
        _episode = newEpisode;
        
        _cachedSortedParts = [self.episode.parts sortedArrayUsingDescriptors:
                              [NSArray arrayWithObject:
                               [[NSSortDescriptor alloc] initWithKey:@"number" 
                                                           ascending:YES]]];
    }
}

// Show the _number_ part on the partContainer view
- (void)displayPart:(int)number
{
    // Update the current part
    self.currentPart = [_cachedSortedParts objectAtIndex:number - 1];
    
    CGRect container = self.videoContainerView.frame;
    container.origin.y = 0; container.origin.x = 0;
    
    PartView *aView = [[PartView alloc] initWithFrame:container
                                              andPart:self.currentPart];
    
    // Check whether a view for the same part has already been added
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"tag == %@", aView.part.number];
    NSArray *filteredViews = [self.videoContainerView.subviews filteredArrayUsingPredicate:filter];
    
    if([filteredViews count] > 0) {
        // Bring it to front
        [self.videoContainerView bringSubviewToFront:[filteredViews objectAtIndex:0]];
    }
    else {
        // Add it
        aView.tag = [self.currentPart.number intValue];
        [self.videoContainerView addSubview:aView];
    }
    
    // Update current part label
    [self.currentPartLabel setText:[self.currentPart.number stringValue]];
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.episode) {
        self.detailDescriptionLabel.text = [self.episode title];
        
        [self displayPart:1];      
    }
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

#pragma mark - Actions

- (IBAction)next:(id)sender
{
    int nextPart = [self.currentPart.number intValue] + 1;
    if ([_cachedSortedParts count] >= nextPart) {
        [self displayPart:nextPart];
    }
}

- (IBAction)previous:(id)sender
{
    int previousPart = [self.currentPart.number intValue] - 1;
    if (1 <= previousPart) {
        [self displayPart:previousPart];
    }
}

							
@end
