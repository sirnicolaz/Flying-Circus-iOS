//
//  Seeder.h
//  MontyPython
//
//  Created by Nicola Miotto on 2/8/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Seeder : NSObject

+ (void) populateWithContext:(NSManagedObjectContext*)context;
+ (BOOL) isPopulated:(NSManagedObjectContext*)context;
+ (void) fixDB:(NSManagedObjectContext*)context;

@end
