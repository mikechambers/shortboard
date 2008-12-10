//
//  NSPopupButton+ArrayData.m
//  ShortBoard
//
//  Created by Mike Chambers on 12/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSPopUpButton+ArrayData.h"


@implementation NSPopUpButton (ArrayData)

-(void)populateFromArray:(NSArray *)arr withKey:(NSString *)key
{
	for(id obj in arr)
	{
		[self addItemWithTitle: [obj valueForKey:key]];
	}
}
		 
-(void)populateFromArray:(NSArray *)arr
{
	for(NSString *s in arr)
	{
		[self addItemWithTitle:s];
	}
}

-(void)populateAndResetFromArray:(NSArray *)arr
{
	[self removeAllItems];
	
	[self populateFromArray:arr];
}
		
-(void)populateAndResetFromArray:(NSArray *)arr withKey:(NSString *)key
{
	[self removeAllItems];
	
	[self populateFromArray:arr withKey:key];	
}
	
		
@end
