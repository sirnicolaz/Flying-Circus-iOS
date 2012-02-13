//
//  SeasonHeaderView.h
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeasonHeaderView : UIView

@property (strong, nonatomic) NSString *title;

- (id)initWithTitle:(NSString*)aTitle;

@end
