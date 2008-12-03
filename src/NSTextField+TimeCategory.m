//
//  NSTextField+TimeCategory.m
//  ShortBoard
//
//  Created by Mike Chambers on 12/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSTextField+TimeCategory.h"


@implementation NSTextField (TimeCategory)

#define UTC_CLOCK_FORMAT @"HH:mm:ss"

-(void)updateTime
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	[dateFormatter setDateFormat:UTC_CLOCK_FORMAT];
	
	NSDate *date = [NSDate date];
	NSString *formattedDateString = [dateFormatter stringFromDate:date];

	[self setStringValue:[NSString stringWithFormat:@"%@ UTC", formattedDateString]];
	
	[dateFormatter release];
}

-(void)handlerTimer:(NSTimer *) timer
{
	[self updateTime];
}

-(void)startTimer
{
	[self updateTime];
	
	NSTimer *timer;
	
	timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
											 target: self
										   selector: @selector(handlerTimer:)
										   userInfo: nil
											repeats: YES];	
}


@end
