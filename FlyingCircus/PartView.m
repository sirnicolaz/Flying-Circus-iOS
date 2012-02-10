//
//  PartView.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "PartView.h"
#import "Part.h"

@implementation PartView

@synthesize part                = _part;
@synthesize activityIndicator   = _activityIndicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
            andPart:(Part*)aPart;
{
    self = [self initWithFrame:frame];
    self.part = aPart;
    
    [self setBackgroundColor:[UIColor blackColor]];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setHidesWhenStopped:YES];
    self.activityIndicator.center = self.center;
    
    [self addSubview:self.activityIndicator];
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSString* embedHTML = @"\
                        <html>\
                            <head>\
                                <style type=\"text/css\">\
                                body {\
                                background-color: black;\
                                color: black;\
                                }\
                                </style>\
                            </head>\
                            <body style=\"margin:0\">\
                                <embed id=\"yt\" src=\"%@\"\
                                        type=\"application/x-shockwave-flash\" \
                                        width=\"%0.0f\" height=\"%0.0f\"\
                                        style=\"background-color:black;\">\
                                </embed>\
                            </body>\
                        </html>";  
    
    NSString* html = [NSString stringWithFormat:
                      embedHTML, 
                      self.part.url, 
                      self.frame.size.width, 
                      self.frame.size.height];
    
    UIWebView *aWebView = [[UIWebView alloc] initWithFrame:self.frame]; 
    aWebView.delegate = self;
    [aWebView loadHTMLString:html baseURL:nil];
    [aWebView setBackgroundColor:[UIColor blackColor]];
    
    [self addSubview:aWebView];
    [aWebView setHidden:YES];
    
}


#pragma mark - UIWebViewDelegate callbacks

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
    NSLog(@"FAIL");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"FINISHED");
    [self.activityIndicator stopAnimating];
    [webView setHidden:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"START");
    [self.activityIndicator startAnimating];
}

@end
