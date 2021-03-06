//
//  Episode.h
//  Flying Circus Player
//
//  Created by Nicola Miotto on 2/14/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Part, Season;

@interface Episode : NSManagedObject

@property (nonatomic, retain) NSDate * broadcastDate;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSNumber * isWatched;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * sketches;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *parts;
@property (nonatomic, retain) Season *season;
@end

@interface Episode (CoreDataGeneratedAccessors)

- (void)addPartsObject:(Part *)value;
- (void)removePartsObject:(Part *)value;
- (void)addParts:(NSSet *)values;
- (void)removeParts:(NSSet *)values;
@end
