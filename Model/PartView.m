//
//  PartView.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "PartView.h"
#import "Part.h"
#import "Imports.h"
#import "SharingFacade.h"

@implementation PartView

@synthesize part                = _part;
@synthesize activityIndicator   = _activityIndicator;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
             andPart:(Part*)aPart;
{
    self = [self initWithFrame:frame];
    self.part = aPart;
    
    [self setBackgroundColor:[UIColor blackColor]];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setHidesWhenStopped:YES];
    self.activityIndicator.center = self.center;
    self.userInteractionEnabled = YES;
    [self addSubview:self.activityIndicator];
    
    return self;
}


- (void) drawRect:(CGRect)rect
{
    NSString* html =  kHTMLYouTubeEmbedding(self.part.url, self.frame.size.width, self.frame.size.height);
    
    
    UIWebView *aWebView = [[UIWebView alloc] initWithFrame:self.frame]; 
    aWebView.delegate = self;
    [aWebView loadHTMLString:html baseURL:nil];
    [aWebView setBackgroundColor:[UIColor blackColor]];
    [aWebView setHidden:YES];
    
    [self addSubview:aWebView];
    
}


#pragma mark - UIWebViewDelegate callbacks

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
    DLog(@"FAIL");
    
    [[[UIAlertView alloc] initWithTitle:kAlertConnectionErrorTitle message:kAlertConnectionErrorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"FINISHED");
    
    [self.activityIndicator stopAnimating];
    [webView setHidden:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DLog(@"START");
    
    [self.activityIndicator startAnimating];
}

#pragma mark - UIView delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    DLog(@"Touches began");
}


@end
