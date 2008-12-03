//
//  Broadcast.m
//  ShortBoard
//
//  Created by Mike Chambers on 11/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Broadcast.h"

@implementation Broadcast

@synthesize startTime;
@synthesize endTime;
@synthesize country;
@synthesize station;
@synthesize notes;
@synthesize frequencies;

-(id)init
{
	if(![super init])
	{
		return nil;
	}
		
	return self;
}

- (id) initWithCoder: (NSCoder *)coder
{
	if (![super init])
	{
		return nil;
	}
	
	[self setStartTime: [coder decodeObjectForKey:@"startTime"]];
	[self setEndTime: [coder decodeObjectForKey:@"endTime"]];
	[self setCountry: [coder decodeObjectForKey:@"country"]];
	[self setStation: [coder decodeObjectForKey:@"station"]];
	[self setNotes: [coder decodeObjectForKey:@"notes"]];
	[self setFrequencies: [coder decodeObjectForKey:@"frequencies"]];
	
	return self;
}


-(void)dealloc
{
	[super dealloc];
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject: startTime forKey:@"startTime"];
	[coder encodeObject: endTime     forKey:@"endTime"];
	[coder encodeObject: country     forKey:@"country"];
	[coder encodeObject: station     forKey:@"station"];
	[coder encodeObject: notes     forKey:@"notes"];
	[coder encodeObject: frequencies     forKey:@"frequencies"];
}

@end
