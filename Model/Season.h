//
//  Season.h
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Episode;

@interface Season : NSManagedObject

@property (nonatomic, retain) NSDate * fromDate;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSDate * toDate;
@property (nonatomic, retain) NSSet *episodes;
@end

@interface Season (CoreDataGeneratedAccessors)

- (void)addEpisodesObject:(Episode *)value;
- (void)removeEpisodesObject:(Episode *)value;
- (void)addEpisodes:(NSSet *)values;
- (void)removeEpisodes:(NSSet *)values;
@end
