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
