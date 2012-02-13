//
//  ReactiveOverlayViewController.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/12/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "ReactiveOverlayViewController.h"

@implementation ReactiveOverlayViewController

@synthesize target = _target;
@synthesize action = _action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

#pragma mark - Touch handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.target != nil && self.action != nil && 
        [self.target respondsToSelector:self.action]) {
        // This is not supposed to return any object, as far as this controller
        // is concerned. Thus, theoretically, there will be no leaks.
        [self.target performSelector:self.action];
    }
}

@end
