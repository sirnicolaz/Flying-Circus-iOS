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

+ (NSString *)stripDoubleSpaceFrom:(NSString *)str {
    while ([str rangeOfString:@"  "].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return str;
}


+ (CXMLDocument*)getXMLDbHandler:(NSString*)fileName
{
    //  using local resource file
    NSString *XMLPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSData *XMLData   = [NSData dataWithContentsOfFile:XMLPath];
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:XMLData options:0 error:nil];
    return doc;
}

// Just roughly parsing XML to populate DB
+ (void) populateWithContext:(NSManagedObjectContext*)context {
    
    // Get handlers
    CXMLDocument *seasonDoc = [Seeder getXMLDbHandler:@"info.xml"];
    CXMLDocument *videoDoc = [Seeder getXMLDbHandler:@"links.xml"];
    
    
    NSArray *nodes = [seasonDoc nodesForXPath:@"//season" error:nil];
    
    // Loop through seasons
    for (CXMLElement *node in nodes) {
        Season *season = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Season" 
                          inManagedObjectContext:context];
        int number =  [[[node attributeForName:@"number"] stringValue] intValue];
        season.number = [NSNumber numberWithInt:number];
        
        // Get season's episodes
        NSMutableSet *episodes = [[NSMutableSet alloc] init];
        NSArray *episodeNodes = [seasonDoc nodesForXPath:[NSString stringWithFormat:@"//season[@number=%i]/episode", [season.number intValue]] error:nil];
        ;
        
        // Loop thourgh episodes
        for (CXMLElement *episodeNode in episodeNodes) {
            Episode *episode = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Episode" 
                                inManagedObjectContext:context];
            
            int number =  [[[episodeNode attributeForName:@"number"] stringValue] intValue];
            NSString *title = [[episodeNode attributeForName:@"title"] stringValue];
            
            episode.title = title;
            episode.number = [NSNumber numberWithInt:number];
            episode.season = season;
            
            // Set sketches, separating their titles with a comma
            CXMLElement *summaryElement = [[seasonDoc nodesForXPath:[NSString stringWithFormat:@"//season[@number=%i]/episode[@number=%i]/summary", [season.number intValue], [episode.number intValue]] error:nil] objectAtIndex:0];
            NSString *amendedString = [[summaryElement stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            amendedString = [Seeder stripDoubleSpaceFrom:amendedString];
            amendedString = [amendedString stringByReplacingOccurrencesOfString:@"\n " withString:@"\n"];
            amendedString = [amendedString stringByReplacingOccurrencesOfString:@" \n " withString:@"\n"];
            amendedString = [amendedString stringByReplacingOccurrencesOfString:@" \n" withString:@"\n"];
            episode.sketches = [amendedString stringByReplacingOccurrencesOfString:@"\n" withString:@","];
            
            // Set broadcast date from string
            CXMLElement *dateElement = [[seasonDoc nodesForXPath:[NSString stringWithFormat:@"//season[@number=%i]/episode[@number=%i]/broadcastDate", [season.number intValue], [episode.number intValue]] error:nil] objectAtIndex:0];
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd MMMM yyyy"];
            episode.broadcastDate = [dateFormatter dateFromString:[dateElement stringValue]];
            
            // Thumbnails
            NSArray *thumbnails = [videoDoc nodesForXPath:[NSString stringWithFormat:@"//season[@number=%i]/episode[@number=%i]/part[1]/thumbnail", [season.number intValue], [episode.number intValue]] error:nil];
            
            if ([thumbnails count] > 0) {
                CXMLElement *thumbnailElement = (CXMLElement*)[thumbnails objectAtIndex:0];
                episode.thumbnailUrl = [thumbnailElement stringValue];
                
                NSArray *partElements = [videoDoc nodesForXPath:[NSString stringWithFormat:@"//season[@number=%i]/episode[@number=%i]/part", [season.number intValue], [episode.number intValue]] error:nil];
                
                NSMutableSet *parts = [[NSMutableSet alloc] init];
                int duration = 0;
                
                // Loop through parts
                for (CXMLElement *partElement in partElements) {
                    Part *part = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Part" inManagedObjectContext:context];
                    part.episode = episode;
                    part.number = [NSNumber numberWithInt:[[[partElement attributeForName:@"number"] stringValue] intValue]];
                    part.url = [(CXMLElement*)[[partElement elementsForName:@"url"] objectAtIndex:0] stringValue]; 
                    
                    // Compute the total episode duration as the sum of the parts' duration
                    duration += [[(CXMLElement*)[[partElement elementsForName:@"duration"] objectAtIndex:0] stringValue] intValue];
                    [parts addObject:part];
                }
                
                int minutesDuration = duration / 60;
                int secondsDuration = duration - (60 * minutesDuration);
                
                // To avoid xx:y when should be xx:0y
                int secondsDec = secondsDuration / 10;
                int secondsUnit = secondsDuration % 10;
                episode.duration = [NSString stringWithFormat:@"%i:%i%i", minutesDuration, secondsDec, secondsUnit];
                episode.parts = parts;
            }

            [episodes addObject:episode];
        }
        
        [season addEpisodes:[NSSet setWithArray:[episodes allObjects]]];
    }

    NSError *error;
    if (![context save:&error]) {
        DLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

+ (BOOL) isPopulated:(NSManagedObjectContext*)context {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Season" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *seasons = [context executeFetchRequest:fetchRequest error:&error];
    
    return [seasons count] > 0 ? YES : NO;
}

@end
