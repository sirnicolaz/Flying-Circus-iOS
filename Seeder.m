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
#import "TouchXML.h"

#define kNumberOfSeasons 7

@implementation Seeder

+ (CXMLDocument*)getSeasonDoc
{
    //  using local resource file
    NSString *XMLPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.xml"];
    NSData *XMLData   = [NSData dataWithContentsOfFile:XMLPath];
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:XMLData options:0 error:nil];
    return doc;
}

+ (CXMLDocument*)getVideoDoc
{
    //  using local resource file
    NSString *XMLPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"links.xml"];
    NSData *XMLData   = [NSData dataWithContentsOfFile:XMLPath];
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:XMLData options:0 error:nil];
    return doc;
}

+ (void) populateWithContext:(NSManagedObjectContext*)context {
        
    // Generate seasons
    CXMLDocument *seasonDoc = [self getSeasonDoc];
    
    
    NSArray *nodes = [seasonDoc nodesForXPath:@"//season" error:nil];
    
    for (CXMLElement *node in nodes) {
        Season *season = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Season" 
                          inManagedObjectContext:context];
        int number =  [[[node attributeForName:@"number"] stringValue] intValue];
        season.number = [NSNumber numberWithInt:number];
        
        NSMutableSet *episodes = [[NSMutableSet alloc] init];
        NSArray *episodeNodes = [seasonDoc nodesForXPath:[NSString stringWithFormat:@"//season[@number=%i]/episode", [season.number intValue]] error:nil];
        ;
        
        for (CXMLElement *episodeNode in episodeNodes) {
            Episode *episode = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Episode" 
                                inManagedObjectContext:context];
            
            int number =  [[[episodeNode attributeForName:@"number"] stringValue] intValue];
            NSString *title = [[episodeNode attributeForName:@"title"] stringValue];
            
            episode.title = title;
            episode.number = [NSNumber numberWithInt:number];
            episode.season = season;
            
            CXMLElement *summaryElement = [[seasonDoc nodesForXPath:[NSString stringWithFormat:@"//season[@number=%i]/episode[@number=%i]/summary", [season.number intValue], [episode.number intValue]] error:nil] objectAtIndex:0];
            NSString *trimmedSummary = [[summaryElement stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            episode.summary = [trimmedSummary stringByReplacingOccurrencesOfString:@"\n" withString:@" - "];
            
            CXMLElement *dateElement = [[seasonDoc nodesForXPath:[NSString stringWithFormat:@"//season[@number=%i]/episode[@number=%i]/broadcastDate", [season.number intValue], [episode.number intValue]] error:nil] objectAtIndex:0];
        
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
            [dateFormatter setDateFormat:@"dd MMMM yyyy"];
            
            episode.broadcastDate = [dateFormatter dateFromString:[dateElement stringValue]];
            
            CXMLDocument *videoDoc = [self getVideoDoc];
            NSArray *videoElemens = [videoDoc nodesForXPath:[NSString stringWithFormat:@"//season[@number=%i]/episode[@number=%i]/part[1]/thumbnail", [season.number intValue], [episode.number intValue]] error:nil];
            
            
            if ([videoElemens count] > 0) {
                CXMLElement *aPartElement = (CXMLElement*)[videoElemens objectAtIndex:0];
                episode.thumbnailUrl = [aPartElement stringValue];
                //NSArray *videoElemens = [doc nodesForXPath:[NSString stringWithFormat:@"//season[@number=%i]/episode[@number=%i]/part[1]/thumbnail/text()", season.number, episode.number] error:nil];
                
                NSArray *partNodes = [videoDoc nodesForXPath:[NSString stringWithFormat:@"//season[@number=%i]/episode[@number=%i]/part", [season.number intValue], [episode.number intValue]] error:nil];
                
                NSMutableSet *parts = [[NSMutableSet alloc] init];
                int duration = 0;
                for (CXMLElement *partNode in partNodes) {
                    Part *part = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Part" inManagedObjectContext:context];
                    part.episode = episode;
                    part.number = [NSNumber numberWithInt:[[[partNode attributeForName:@"number"] stringValue] intValue]];
                    part.url = [(CXMLElement*)[[partNode elementsForName:@"url"] objectAtIndex:0] stringValue]; 
                    duration += [[(CXMLElement*)[[partNode elementsForName:@"duration"] objectAtIndex:0] stringValue] intValue];
                    [parts addObject:part];
                }
                
                int minutesDuration = duration / 60;
                int secontsDuration = duration - (60 * minutesDuration);
                episode.duration = [NSString stringWithFormat:@"%i:%i", minutesDuration, secontsDuration];
                episode.parts = parts;
            }

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
    [Seeder getVideoDoc];
    [Seeder getSeasonDoc];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Season" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *seasons = [context executeFetchRequest:fetchRequest error:&error];
    
    return [seasons count] > 0 ? YES : NO;
}

@end
