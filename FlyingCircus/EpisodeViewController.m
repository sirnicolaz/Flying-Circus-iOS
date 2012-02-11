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
#import "Season.h"

#import "Constants.h"

@interface EpisodeViewController (Private) 
- (void)configureView;
- (void)displayPart:(int)number;
@end

@implementation EpisodeViewController

@synthesize episode                 = _episode;
@synthesize videoContainerView      = _videoContainerView;
@synthesize detailDescriptionLabel  = _detailDescriptionLabel;
@synthesize currentPartLabel        = _currentPartLabel;
@synthesize totPartsLabel           = _totPartsLabel;
@synthesize currentPart             = _currentPart;
@synthesize nextButton              = _nextButton;
@synthesize previousButton          = _previousButton;

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
    
    // Reuse an already loaded PartView if possible
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
    // Current part label
    [self.currentPartLabel setFont:[UIFont fontWithName:@"AlikeAngular-Regular" size:20.0]];
    [self.currentPartLabel setTextColor:kDefaultTextColor];
    [self.currentPartLabel setTextAlignment:UITextAlignmentCenter];
    [self.currentPartLabel setShadowColor:[UIColor blackColor]];
    [self.currentPartLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    // Tot parts label
    [self.totPartsLabel setFont:[UIFont fontWithName:@"AlikeAngular-Regular" size:20.0]];
    [self.totPartsLabel setTextColor:kDefaultTextColor];
    [self.totPartsLabel setTextAlignment:UITextAlignmentCenter];
    [self.totPartsLabel setShadowColor:[UIColor blackColor]];
    [self.totPartsLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    // Amend buttons
    [self.nextButton setBackgroundColor:[UIColor clearColor]];
    [self.previousButton setBackgroundColor:[UIColor clearColor]];
    
    // Custom backbutton in navigation bar
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 45, 28)]; /* initialize your button */
    [button setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"back_button-highlighted"] forState:UIControlStateHighlighted];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:kDefaultFont size:12.0]];
    [button.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor brownColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 9, 2, 0)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    if (self.episode.number != self.currentPart.episode.number ||
        self.episode.season.number != self.currentPart.episode.season.number) {
        // Episode has been changed, thus
        // - Reset
        for(UIView *subview in [self.videoContainerView subviews]) {
            [subview removeFromSuperview];
        }
        self.currentPart = nil;
        
        // - And Reload
        self.detailDescriptionLabel.text = [self.episode title];
        [self.totPartsLabel setText:[NSString stringWithFormat:@"/ %i", [self.episode.parts count]]];
        [self displayPart:1];      
    }
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
