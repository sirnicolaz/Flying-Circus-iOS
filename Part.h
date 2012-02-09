//
//  Part.h
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Episode;

@interface Part : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) Episode *episode;

@end
