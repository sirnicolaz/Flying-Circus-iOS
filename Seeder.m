//
//  Seeder.m
//  MontyPython
//
//  Created by Nicola Miotto on 2/8/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "Seeder.h"

#import "Season.h"
#import "Episode.h"
#import "Part.h"

#define kNumberOfSeasons 7

@implementation Seeder

+ (void) populateWithContext:(NSManagedObjectContext*)context {
        
    // Generate seasons
    for (int i = 0; i < kNumberOfSeasons; i++) {
        Season *season = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Season" 
                          inManagedObjectContext:context];
        
        season.number = [NSNumber numberWithInt:i+1];
        season.fromDate = [NSDate date];
        season.toDate = [NSDate date];
        NSMutableSet *episodes = [[NSMutableSet alloc] init];
        
        // Generate episodes
        for (int j = 0; j < 8; j++) {
            Episode *episode = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Episode" 
                                inManagedObjectContext:context];
            
            episode.title = j == 0 ? 
            [NSString stringWithFormat:@"And now for something completely different not the movie, the episode %i", j] :
            [NSString stringWithFormat:@"The pine tree %i", j];
            
            episode.number = [NSNumber numberWithInt:j+1];
            episode.season = season;
            
            NSMutableSet *parts = [[NSMutableSet alloc] init];
            for(int k = 0; k < 2; k++) {
                
                Part *part = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Part" inManagedObjectContext:context];
                
                part.url = k == 0 ? @"http://www.youtube.com/watch?v=jT3_UCm1A5I" :
                                    @"http://www.youtube.com/watch?v=ODshB09FQ8w";
                part.episode = episode;
                part.number = [NSNumber numberWithInt:k+1];
                
                [parts addObject:part];
            }
            
            episode.parts = parts;
            [episodes addObject:episode];
        }
        
        [season addEpisodes:[NSSet setWithArray:[episodes allObjects]]];
        
    }

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

+ (BOOL) populated:(NSManagedObjectContext*)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Season" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *seasons = [context executeFetchRequest:fetchRequest error:&error];
    
    return [seasons count] > 0 ? YES : NO;
}

@end
