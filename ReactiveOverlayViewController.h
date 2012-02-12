//
//  ReactiveOverlayViewController.h
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/12/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReactiveOverlayViewController : UIViewController

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@end
