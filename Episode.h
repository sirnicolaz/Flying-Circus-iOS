//
//  Episode.h
//  MontyPython
//
//  Created by Nicola Miotto on 2/8/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Episode : NSManagedObject

@property (nonatomic, retain) NSDate *broadcastDate;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSManagedObject *season;
@property (nonatomic, retain) NSSet *parts;


@end
