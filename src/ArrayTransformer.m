//
//  ArrayTransformer.m
//  ShortBoard
//
//  Created by Mike Chambers on 11/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ArrayTransformer.h"


@implementation ArrayTransformer

+ (Class)transformedValueClass
{
    return [NSString self];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(NSArray *)beforeObject
{
    if (beforeObject == nil)
	{
		return nil;
	}
	
	NSString *out = [beforeObject componentsJoinedByString:@", "];

	return out;
}

@end
