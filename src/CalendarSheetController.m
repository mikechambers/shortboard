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
#import "NSSound+SoundList.h"
#import "NSPopUpButton+ArrayData.h"
#import "HoursMinutes.h"

#import "iCal.h"

#define NO_SOUND @"None"

#define DEFAULT_CALENDAR_NAME @"ShortBoard"
#define DEFAULT_ALERT_INTERVAL -300.00


//preferences
#define DefaultCreateAlert @"DefaultCreateAlert"
#define DefaultAlertSound @"DefaultAlertSound"
#define DefaultLaunchIcal @"DefaultLaunchIcal"
#define DefaultCalendarName @"DefaultCalendarName"

@implementation CalendarSheetController


-(id)init
{
	if(![super init])
	{
		return nil;
	}
	

	//todo : should I store this in a class / instance variable?
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSArray *keys = [NSArray arrayWithObjects:DefaultCreateAlert, 
													DefaultAlertSound, DefaultLaunchIcal, nil];
	NSArray *objects = [NSArray arrayWithObjects:@"FALSE", NO_SOUND , @"TRUE", nil];
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
								 	
    [defaults registerDefaults:appDefaults];	
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}


//add category to popup to populate from array and key
-(void)populateSoundPopup
{
	NSArray *sounds = [NSSound availableSounds];
	
	[alertSoundsPopup populateAndResetFromArray:sounds];
	[alertSoundsPopup insertItemWithTitle:NO_SOUND atIndex:0];
	
	//todo : what if the default titled doesnt exists anymore? should we check first?
	NSString *defaultTitle = [[NSUserDefaults standardUserDefaults] stringForKey:DefaultAlertSound];
	[alertSoundsPopup selectItemWithTitle:defaultTitle];
	
	[alertSoundsPopup setEnabled:([alertCheckBox state] == NSOnState)];	
}

-(void)populateCalendarPopup
{	
	CalCalendarStore *store = [CalCalendarStore defaultCalendarStore];
	
	//get all of the calendars
	NSArray *calendars = [store calendars];	
	
	[calendarListPopup populateAndResetFromArray:calendars withKey:@"title"];
	
	
	NSString *defaultTitle = [[NSUserDefaults standardUserDefaults] stringForKey:DefaultCalendarName];
	
	if(defaultTitle != nil)
	{
		[calendarListPopup selectItemWithTitle:defaultTitle];
	}
}

-(NSInteger)getStateForDefault:(NSString *)defaultName
{
	NSInteger state ;
	if([[NSUserDefaults standardUserDefaults] boolForKey:defaultName])
	{
		state = NSOnState;
	}
	else
	{
		state = NSOffState;
	}
	
	return state;
}

- (void)showSheet: (NSWindow *)window forBroadcast:(Broadcast *)b
{
	//todo: do we need to retain broadcast / b
	broadcast = b;
	[broadcast retain];
	
    if(sheet == nil)
	{
		[NSBundle loadNibNamed: @"CalendarSheet" owner: self];
	}
	
	//initialize control values
	[alertCheckBox setState:[self getStateForDefault:DefaultCreateAlert]];
	[launchICalCheckBox setState:[self getStateForDefault:DefaultLaunchIcal]];		
	[self populateCalendarPopup];
	[self populateSoundPopup];
		
	NSString *note = [NSString stringWithFormat:@"%@ - %@\n%@\n%@", 
					  b.station, b.country, [b.frequencies componentsJoinedByString:@", "],
					  b.notes];
	
	[noteField setStringValue:note];
	
	[titleField setStringValue:[NSString stringWithFormat:@"%@ Broadcast", b.station]];	
	
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

-(void) addICalEntry
{
	CalCalendarStore *store = [CalCalendarStore defaultCalendarStore];
	
	//get all of the calendars
	NSArray *calendars = [store calendars];
	
	CalCalendar *cal = nil;
	
	NSString *calName = [calendarListPopup titleOfSelectedItem];
	
	//check and see if the calendar already exists
	for(CalCalendar *c in calendars)
	{
		if([[c title] compare:calName] == NSOrderedSame)
		{
			cal = c;
			break;
		}
	}
	
	/*
	//this shouldnt be called 
	if(cal == nil)
	{
		//create the new calendar
		cal = [CalCalendar calendar];
		cal.title = DEFAULT_CALENDAR_NAME;
		
		NSError *cError;
		[store saveCalendar:cal error:&cError];
		
		if (cError == FALSE)
		{
			NSAlert *alertPanel = [NSAlert alertWithError:cError];
			[alertPanel runModal];
			return;
		}	
	}
	*/
	
	CalEvent *event = [CalEvent event];
	event.calendar = cal;
	
	//todo : validate?
	event.title = [titleField stringValue];
	
	HoursMinutes *startTime = [[HoursMinutes alloc] initWithString:broadcast.startTime];
	HoursMinutes *endTime = [[HoursMinutes alloc] initWithString:broadcast.endTime];
	//release theses
	
	NSDate *date = [NSDate date];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	
	[dateFormatter setDateFormat:@"yyyy"];
	NSString *year = [dateFormatter stringFromDate:date];
	
	[dateFormatter setDateFormat:@"MM"];
	NSString *month = [dateFormatter stringFromDate:date];	
	
	[dateFormatter setDateFormat:@"dd"];
	NSString *day = [dateFormatter stringFromDate:date];
	
	NSString *start = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00 +0000", 
					   year, month, day, startTime.hours, startTime.minutes];
	
	NSString *end = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00 +0000", 
					 year, month, day, endTime.hours, endTime.minutes];
	
	
	NSDate *startDate = [NSDate dateWithString:start];
	NSDate *endDate = [NSDate dateWithString:end];
	
	//check and see if the start time has alread passed for today.
	//if it has, then add a day to the start date.
	if([startDate compare:date] == NSOrderedAscending)
	{
		//1 day in seconds
		NSTimeInterval oneDay = 86400;
		
		//is this a leak?
		startDate = [startDate addTimeInterval:oneDay];
		endDate = [endDate addTimeInterval:oneDay];
	}
	
	
	//YYYY-MM-DD HH:MM:SS ±HHMM
	event.startDate = startDate;
	event.endDate = endDate;
	
	event.notes = [noteField stringValue];
	
	if([alertCheckBox state] == NSOnState)
	{
		CalAlarm *alarm = [CalAlarm alarm];
		
		NSString *alarmSound = [alertSoundsPopup titleOfSelectedItem];
		if([alarmSound compare:NO_SOUND] != NSOrderedSame)
		{
			[alarm setSound:alarmSound];
			[alarm setAction:CalAlarmActionSound];
		}
		
		alarm.relativeTrigger = DEFAULT_ALERT_INTERVAL;
		
		event.alarms = [NSArray arrayWithObject:alarm];
	}
	
	// Save changes to an event
	NSError *calError;
	[store saveEvent:event span:CalSpanThisEvent error:&calError];
	
	if (calError == NO)
	{
		NSAlert *alertPanel = [NSAlert alertWithError:calError];
		[alertPanel runModal];
		return;
	}
	
	if([launchICalCheckBox state] == NSOnState)
	{
		iCalApplication *ical= [SBApplication applicationWithBundleIdentifier:@"com.apple.iCal"];
		[ical activate];
		[ical viewCalendarAt:event.startDate];
		[ical release];
	}
	
	[dateFormatter release];
	[startTime release];
	[endTime release];
}

-(void) closeSheet
{

/*
 #define DefaultCreateAlert @"DefaultCreateAlert"
 #define DefaultAlertSound @"DefaultAlertSound"
 #define DefaultLaunchIcal @"DefaultLaunchIcal"
 #define DefaultCalendarName @"DefaultCalendarName"
*/
		
	[broadcast release];
	[NSApp endSheet:sheet];
}

/************ actions **************/

-(IBAction) handleCreateICalEntryClick:(id)sender
{
	[self addICalEntry];
	
	[[NSUserDefaults standardUserDefaults]
	 setBool:([alertCheckBox state] == NSOnState) forKey:DefaultCreateAlert];
	[[NSUserDefaults standardUserDefaults]
	 setObject:[alertSoundsPopup titleOfSelectedItem] forKey:DefaultAlertSound];	
	[[NSUserDefaults standardUserDefaults]
	 setBool:([launchICalCheckBox state] == NSOnState) forKey:DefaultLaunchIcal];	
	[[NSUserDefaults standardUserDefaults]
	 setObject:[calendarListPopup titleOfSelectedItem] forKey:DefaultCalendarName];		
	
	[self closeSheet];
}

-(IBAction) handleCancelButton:(id)sender
{
	[self closeSheet];
}

-(IBAction) handleCreateAlertCheck:(id)sender
{
	[alertSoundsPopup setEnabled:([alertCheckBox state] == (NSOnState))];
}

-(IBAction)handleAlertSoundClick:(id)sender
{
	NSString *soundName = [alertSoundsPopup titleOfSelectedItem];
	
	if([soundName compare:NO_SOUND] == NSOrderedSame)
	{
		return;
	}
	
	NSSound *previewSound = [NSSound soundNamed:soundName];
	
	//todo: we might need to retain this to be sure it isnt
	//garbage collected while playing
	[previewSound play];
	
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

/*
- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
	NSLog(@"string end");
}
 */

@end
