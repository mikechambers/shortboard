/*
 
 The MIT License
 
 Copyright (c) 2010 Mike Chambers (mikechambers@gmail.com)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE. 
 
 */

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
