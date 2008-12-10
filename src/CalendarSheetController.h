//
//  CalendarSheet.h
//  ShortBoard
//
//  Created by Mike Chambers on 12/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Broadcast;


@interface CalendarSheetController : NSWindowController
{
	IBOutlet NSWindow *sheet;
	
	IBOutlet NSButton *alertCheckBox;
	IBOutlet NSPopUpButton *alertSoundsPopup;
	IBOutlet NSPopUpButton *calendarListPopup;
	
	IBOutlet NSTextField *titleField;
	IBOutlet NSTextField *noteField;
	
	IBOutlet NSButton *launchICalCheckBox;
	
	Broadcast *broadcast;
}

- (void)showSheet: (NSWindow *)window forBroadcast:(Broadcast *)broadcast;
-(void)populateCalendarPopup;

-(IBAction) handleCancelButton:(id)sender;
-(IBAction) handleCreateAlertCheck:(id)sender;
-(IBAction) handleAlertSoundClick:(id)sender;
-(IBAction) handleCreateICalEntryClick:(id)sender;

-(void) closeSheet;

@end
