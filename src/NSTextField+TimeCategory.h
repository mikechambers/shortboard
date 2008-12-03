//
//  NSTextField+TimeCategory.h
//  ShortBoard
//
//  Created by Mike Chambers on 12/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTextField (TimeCategory)

-(void)updateTime;
-(void)startTimer;
-(void)handlerTimer:(NSTimer *) timer;

@end