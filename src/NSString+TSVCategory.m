//
//  NSStringTSVCategory.m
//  ShortBoard
//
//  Created by Mike Chambers on 11/27/08.
//  Copyright 2008 Mike Chambers. All rights reserved.
//

#import "NSString+TSVCategory.h"
#import "Broadcast.h"

#define START_INDEX 0
#define END_INDEX 1
#define COUNTRY_INDEX 2
#define STATION_INDEX 3
#define NOTES_INDEX 4
#define FREQUENCIES_INDEX 5


@implementation NSString (TSVCategory)
	
-(NSMutableArray *)arrayOfBroadcastsFromTSV
{

	NSString *data = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *cleanedData = [data stringByReplacingOccurrencesOfString:@"\"" withString:@""];
	
	NSArray *rows = [cleanedData componentsSeparatedByString:@"\n"];
	
	//[data release];
	
	int rowCount = [rows count];
	
	if(rowCount == 0)
	{
		[rows release];
		return nil;
	}
	
	NSMutableArray *out = [NSMutableArray arrayWithCapacity:rowCount];
	
	
	NSArray *column;
	
	NSArray *frequencies;
	
	Broadcast *b;
	
	Boolean first = TRUE;
	for(NSString *row in rows)
	{
		
		if(first)
		{
			first = FALSE;
			continue;
		}
		
		column = [row componentsSeparatedByString:@"\t"];
		
		b = [[Broadcast alloc] init];
		b.startTime = [column objectAtIndex:START_INDEX];
		b.endTime = [column objectAtIndex:END_INDEX];
		b.country = [column objectAtIndex:COUNTRY_INDEX];
		b.station = [column objectAtIndex:STATION_INDEX];
		b.notes = [column objectAtIndex:NOTES_INDEX];
		
		//"9660, 12080, 13690, 15240, 17715, 17750, 17775, 17795"
		
		NSString *fString = [column objectAtIndex:FREQUENCIES_INDEX];
		
		frequencies = [fString componentsSeparatedByString:@", "];
		
		b.frequencies = frequencies;
				
		[out addObject:b];
		
		[b release];
	}
	
	//todo make sure autorelease is being used correctly here
	[out autorelease];
	return out;
}

@end
