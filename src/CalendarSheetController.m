//
//  CalendarSheet.m
//  ShortBoard
//
//  Created by Mike Chambers on 12/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CalendarStore/CalendarStore.h>

#import "CalendarSheetController.h"
#import "Broadcast.h"


@implementation CalendarSheetController


-(id)init
{
	if(![super init])
	{
		return nil;
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

-(void)populateCalendarPopup
{
	[calendarListPopup removeAllItems];
	
	CalCalendarStore *store = [CalCalendarStore defaultCalendarStore];
	
	//get all of the calendars
	NSArray *calendars = [store calendars];	
	
	for(CalCalendar *c in calendars)
	{
		[calendarListPopup addItemWithTitle:c.title];
	}	
}

- (void)showSheet: (NSWindow *)window forBroadcast:(Broadcast *)b
{
	//todo: do we need to retain broadcast / b
	
    if(sheet == nil)
	{
		[NSBundle loadNibNamed: @"CalendarSheet" owner: self];
	}
	
	[self populateCalendarPopup];
		
	NSString *note = [NSString stringWithFormat:@"%@ - %@\n%@\n%@", 
					  b.station, b.country, [b.frequencies componentsJoinedByString:@", "],
					  b.notes];
	
	[noteField setStringValue:note];
	[titleField setStringValue:b.station];	
	
    [NSApp beginSheet: sheet
	   modalForWindow: window
		modalDelegate: self
	   didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
		  contextInfo: nil];
}

- (void)didEndSheet:(NSWindow *)s returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    [sheet orderOut:self];
}

/************ actions **************/

-(IBAction) handleCancelButton:(id)sender
{
	[NSApp endSheet:sheet];
}

-(IBAction) handleCreateAlertCheck:(id)sender
{
	[alertSoundsPopup setEnabled:([alertCheckBox state] == (NSOnState))];
}

/********* notes NSTextField delegate methods ***********/


//todo: still need to look at this
- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
	
    if (commandSelector == @selector(insertNewline:))
    {
        // new line action:
        // always insert a line-break character and don’t cause the receiver to end editing
        [textView insertNewlineIgnoringFieldEditor:self];
        result = YES;
    }
    else if (commandSelector == @selector(insertTab:))
    {
        // tab action:
        // always insert a tab character and don’t cause the receiver to end editing
        [textView insertTabIgnoringFieldEditor:self];
        result = YES;
    }
	
    return result;
}


@end
