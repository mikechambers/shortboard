//
//  HoursMinutes.h
//  ShortBoard
//
//  Created by Mike Chambers on 12/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HoursMinutes : NSObject
{
	NSString *hours;
	NSString *minutes;
}

@property(readwrite, copy) NSString *hours;
@property(readwrite, copy) NSString *minutes;

@end
