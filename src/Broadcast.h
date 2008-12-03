//
//  Broadcast.h
//  ShortBoard
//
//  Created by Mike Chambers on 11/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Broadcast : NSObject <NSCoding>
{
	NSString *startTime;
	NSString *endTime;
	NSString *country;
	NSString *station;
	NSString *notes;
	NSArray *frequencies;
}

@property(readwrite, copy) NSString *startTime;
@property(readwrite, copy) NSString *endTime;
@property(readwrite, copy) NSString *country;
@property(readwrite, copy) NSString *station;
@property(readwrite, copy) NSString *notes;
@property(readwrite, retain) NSArray *frequencies;

@end
