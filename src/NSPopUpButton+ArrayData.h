//
//  NSPopupButton+ArrayData.h
//  ShortBoard
//
//  Created by Mike Chambers on 12/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSPopUpButton (ArrayData)

-(void)populateFromArray:(NSArray *)arr withKey:(NSString *)key;
-(void)populateFromArray:(NSArray *)arr;
-(void)populateAndResetFromArray:(NSArray *)arr;
-(void)populateAndResetFromArray:(NSArray *)arr withKey:(NSString *)key;

@end
