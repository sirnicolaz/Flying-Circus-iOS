//
//  SharingSettingsViewController.m
//  Flying Circus Player
//
//  Created by Nicola Miotto on 3/11/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "SharingSettingsViewController.h"
#import "SharingFacade.h"
#import "SHKTwitter.h"
#import "SHK.h"

@implementation SharingSettingsViewController

@synthesize twitterSharingSwitcher;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.twitterSharingSwitcher.onTintColor = [UIColor blackColor];
    self.twitterSharingSwitcher.knobImage = [UIImage imageNamed:@"twitter.png"];
    [self.twitterSharingSwitcher addTarget:self action:@selector(switchTwitterSharing:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.twitterSharingSwitcher setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"twitterSharing"] 
                              animated:NO 
                   ignoreControlEvents:YES];
    
    [super viewWillAppear:animated];
    
}

#pragma mark - Actions

- (IBAction)switchTwitterSharing:(id)sender
{
    
    [self dismissModalViewControllerAnimated:YES];
    if (//![[NSUserDefaults standardUserDefaults] boolForKey:@"firstPost"] &&
        self.twitterSharingSwitcher.isOn) {
        
        // "I've started using bla bla"
        [SharingFacade share:nil];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstPost"];
    }
    
    else if (!twitterSharingSwitcher.isOn) {
        [SHKTwitter logout];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:self.twitterSharingSwitcher.isOn forKey:@"twitterSharing"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
