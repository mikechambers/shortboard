//
//  HoursMinutes.m
//  ShortBoard
//
//  Created by Mike Chambers on 12/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "HoursMinutes.h"


@implementation HoursMinutes

@synthesize hours;
@synthesize minutes;

-(id) init
{
	if(![super init])
	{
		return nil;
	}
	
	return self;
}

-(void) dealloc
{
	[super dealloc];
}

-(id) initWithString:(NSString *) hoursAndMinutes
{
	if(![self init])
	{
		return nil;
	}
	
	if([hoursAndMinutes length] != 4)
	{
		//should i throw an error here?
		return nil;
	}
	
	self.hours = [hoursAndMinutes substringToIndex:2];
	self.minutes = [hoursAndMinutes substringFromIndex:2];
	
	return self;
}

@end
