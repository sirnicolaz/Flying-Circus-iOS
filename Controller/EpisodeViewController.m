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

#import "Imports.h"

@interface EpisodeViewController (Private) 
- (void) configureView;
- (void) displayPart:(int)number;
- (CGFloat) getSizeToFitText:(NSString*)text
                       inBox:(CGSize)size;
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
@synthesize sketchesTextView        = _sketchesTextView;

#pragma mark - Managing the detail item

- (void) setEpisode:(id)newEpisode
{
    if (_episode != newEpisode) {
        _episode = newEpisode;
        
        _cachedSortedParts = [self.episode.parts sortedArrayUsingDescriptors:
                              [NSArray arrayWithObject:
                               [[NSSortDescriptor alloc] initWithKey:@"number" 
                                                           ascending:YES]]];
    }
}

- (void) handleBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.episode.number         != self.currentPart.episode.number ||
        self.episode.season.number  != self.currentPart.episode.season.number) {
        
        // Episode has been changed, thus
        // - Reset parts
        for(UIView *subview in [self.videoContainerView subviews]) {
            [subview removeFromSuperview];
        }
        self.currentPart = nil;
        
        // - Reset labels
        self.detailDescriptionLabel.text = [self.episode title];
        [self.totPartsLabel setText:[NSString stringWithFormat:@"/ %i", [self.episode.parts count]]];
        [self displayPart:1];     
        
        // - Reset sketches
        [self.sketchesTextView setText:[self.episode.sketches stringByReplacingOccurrencesOfString:@"," 
                                                                                       withString:@"\n------------\n"]];
        
        // - Reset title
        CGFloat titleViewWidth = 200.0;
        CGFloat titleFontSize = [self getSizeToFitText:self.episode.title 
                                                 inBox:CGSizeMake(titleViewWidth, 420.0)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleViewWidth, NAVIGATION_BAR_HEIGHT)];
        [titleLabel setNumberOfLines:42];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        [titleLabel setLineBreakMode:UILineBreakModeWordWrap];
        [titleLabel setFont:kDefaultFontAndSize(titleFontSize)];
        [titleLabel setTextColor:kDefaultTextColor];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:self.episode.title];
        
        self.navigationItem.titleView = titleLabel;
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || 
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown );
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - Actions

- (IBAction) next:(id)sender
{
    int nextPart = [self.currentPart.number intValue] + 1;
    if ([_cachedSortedParts count] >= nextPart) {
        [self displayPart:nextPart];
    }
}

- (IBAction) previous:(id)sender
{
    int previousPart = [self.currentPart.number intValue] - 1;
    if (1 <= previousPart) {
        [self displayPart:previousPart];
    }
}
							
@end


// Private
#pragma mark
#pragma mark - Private

@implementation EpisodeViewController(Private)

- (void) configureView
{
    // Current part label
    [self.currentPartLabel setFont:kDefaultFontAndSize(20)];
    [self.currentPartLabel setTextColor:kDefaultTextColor];
    [self.currentPartLabel setTextAlignment:UITextAlignmentCenter];
    [self.currentPartLabel setShadowColor:[UIColor blackColor]];
    [self.currentPartLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    // Tot parts label
    [self.totPartsLabel setFont:kDefaultFontAndSize(20)];
    [self.totPartsLabel setTextColor:kDefaultTextColor];
    [self.totPartsLabel setTextAlignment:UITextAlignmentCenter];
    [self.totPartsLabel setShadowColor:[UIColor blackColor]];
    [self.totPartsLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    // Amend buttons
    [self.nextButton setBackgroundColor:[UIColor clearColor]];
    [self.previousButton setBackgroundColor:[UIColor clearColor]];
    
    // Text field with sketches
    [self.sketchesTextView setBackgroundColor:[UIColor clearColor]];
    [self.sketchesTextView setFont:kDefaultFontAndSize(14.0)];
    [self.sketchesTextView setTextColor:[UIColor blackColor]];
    [self.sketchesTextView setTextAlignment:UITextAlignmentCenter];
    
    // Custom backbutton for navigation bar
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 45, 28)];
    [button setBackgroundImage:[UIImage imageNamed:kImageBackButton] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:kImageBackButtonHighlighted] forState:UIControlStateHighlighted];
    [button setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [button.titleLabel setFont:kDefaultFontAndSize(12)];
    [button.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor brownColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 9, 2, 0)];
    [button addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}


- (CGFloat) getSizeToFitText:(NSString*)text
                       inBox:(CGSize)size
{
    CGFloat textFontSize = 0.0; 
    BOOL found = NO;
    
    // Decrease font size until the text fits in the box 
    for (float x = 18.0; x > 8.0 && !found; x -= 1.0) {
        textFontSize = x;
        CGSize titleSize = [self.episode.title sizeWithFont:kDefaultFontAndSize(x) 
                                          constrainedToSize:size 
                                              lineBreakMode:UILineBreakModeWordWrap];
        
        if (titleSize.height <= NAVIGATION_BAR_HEIGHT) found = YES;
    } 
    
    return textFontSize;
}

// Show the <number> part on the partContainer view
- (void) displayPart:(int)number
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


@end
