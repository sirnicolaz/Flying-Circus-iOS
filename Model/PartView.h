//
//  PartView.h
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Part;

@interface PartView : UIView <UIWebViewDelegate>

@property (strong, nonatomic) Part                      *part;
@property (strong, nonatomic) UIActivityIndicatorView   *activityIndicator;

- (id) initWithFrame:(CGRect)frame
             andPart:(Part*)aPart;

@end
