//
//  NSArrayFormatter.m
//  ShortBoard
//
//  Created by Mike Chambers on 11/28/08.
//  Copyright 2008 Mike Chambers. All rights reserved.
//

#import "NSArrayFormatter.h"


@implementation NSArrayFormatter

- (NSString *)stringForObjectValue:(NSArray *)array
{
    if ((array == nil))
	{
		return @"";
	}
	
	if(![array isKindOfClass:[NSArray class]])
	{
		return @"";
	}
	
	
	
	NSString *out = [array componentsJoinedByString:@", "];
	
	return out;
}

/*
- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)attributes
{
	//not implemented
	return [super attributedStringForObjectValue:anObject withDefaultAttributes:attributes];
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error
{
	//not implemented
	return [super getObjectValue:anObject forString:string errorDescription:error];
}
*/
@end
