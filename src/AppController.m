//
//  AppController.m
//  ShortBoard
//
//  Created by Mike Chambers on 11/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "Broadcast.h"
#import "NSStringTSVCategory.h"
#import "NSArrayFormatter.h"
#import "NSTextField+TimeCategory.h"
#import <CalendarStore/CalendarStore.h>
#import "HoursMinutes.h"


#define ALL_MENU_TAG 20
#define START_MENU_TAG 21
#define END_MENU_TAG 22
#define COUNTRY_MENU_TAG 23
#define STATION_MENU_TAG 24
#define NOTES_MENU_TAG 25
#define FREQUENCY_MENU_TAG 26
#define NOW_MENU_TAG 28

#define CLEAR_CACHE_MENU 58
#define MAIN_WINDOW_MENU_TAG 150

@implementation AppController
 
@synthesize broadcasts;

-(id)init
{
	if(![super init])
	{
		return nil;
	}
	
	broadcasts = [[NSMutableArray alloc] init];
	
	allSearch = TRUE;
	startSearch = FALSE;
	endSearch = FALSE;
	countrySearch = FALSE;
	stationSearch = FALSE;
	notesSearch = FALSE;
	frequencySearch = FALSE;
	nowSearch = FALSE;
	
	return self;
}

-(void)dealloc
{
	[broadcasts release];
	[filteredBroadcasts release];
	[super dealloc];
}


-(void)awakeFromNib
{
	[countLabel setStringValue:@""];
	[timerLabel startTimer];
	
	[mainWindow setReleasedWhenClosed:FALSE];
	
	NSArrayFormatter *arrayFormatter = [[NSArrayFormatter alloc] init];
	
	NSTableColumn *fCol = [broadcastTable tableColumnWithIdentifier:@"frequencies"];
	NSCell *fCell = [fCol dataCell];
	[fCell setFormatter:arrayFormatter];
	
	//this is to work around some Interface Builder bugs.
	//basically, it wont remove some of the items, so we have to do it manually
	[topToolBar removeItemAtIndex:4];
	[topToolBar removeItemAtIndex:0];
	
	//[mainWindow setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
	//[mainWindow setContentBorderThickness: 32.0 forEdge: NSMinYEdge];
	
	[self loadBroadcastData];
}

-(void)updateBroadcasts:(NSMutableArray *)b
{
	[broadcasts removeAllObjects];
	[broadcasts addObjectsFromArray:b];
	
	filteredBroadcasts = [broadcasts mutableCopy];
}

-(void)refreshData
{
	NSLog(@"refreshData");
	[broadcastTable reloadData];
	[countLabel setStringValue:[NSString stringWithFormat:@"%i of %i broadcasts", [filteredBroadcasts count], [broadcasts count]]];
}

-(void)filterBroadcastsForNow
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	[dateFormatter setDateFormat:@"HHmm"];
	
	NSDate *date = [NSDate date];
	
	NSString *current = [dateFormatter stringFromDate:date];
	
	[dateFormatter release];	
	
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ BETWEEN {startTime, endTime}", current];
	
	[filteredBroadcasts filterUsingPredicate:predicate];
}

-(void)importFromFilePath:(NSString *)filePath
{	
	NSStringEncoding enc;
	NSString *data = [NSString stringWithContentsOfFile:filePath
										   usedEncoding:&enc 
												  error:NULL];

	if(data == nil)
	{
		NSAlert *alert = [[NSAlert alloc] init];
		[alert addButtonWithTitle:@"OK"];
		[alert setMessageText:@"Error importing data."];
		[alert setInformativeText:@"Please ensure the file is in the correct format."];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert runModal];
		[alert release];		
		return;
	}
	
	NSMutableArray *b = [[data arrayOfBroadcastsFromTSV] retain];

	[self updateBroadcasts:b];

	[self saveBroadcastData];
	[self refreshData];
}

-(NSString *) appName
{
	return [[NSProcessInfo processInfo] processName];
}

/***************  data persitence apis **************/

-(void)saveBroadcastData
{
	NSString *path = [self pathForDataFile];
	
	NSMutableDictionary *rootObject = [NSMutableDictionary dictionary];
    
	[rootObject setValue: [self broadcasts] forKey:@"broadcasts"];
	[NSKeyedArchiver archiveRootObject: rootObject toFile: path];
}

-(void)loadBroadcastData
{
	NSString *path = [self pathForDataFile];
	
	if(![self fileExistsAtPath:path])
	{
		return;
	}
	
	NSDictionary * rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path]; 
	
	NSMutableArray *b = [rootObject valueForKey:@"broadcasts"];
	
	if([b count] == 0)
	{
		return;
	}
	
	[self updateBroadcasts:b];
	
	[self refreshData];
}

- (NSString *) pathForDataFile
{
	NSString *appName = [self appName];
    
	NSString *folder = [NSString stringWithFormat:@"~/Library/Application Support/%@/", appName];
	folder = [folder stringByExpandingTildeInPath];
	
	if ([self fileExistsAtPath:folder] == NO)
	{
		NSFileManager *fMan = [NSFileManager defaultManager];
		[fMan createDirectoryAtPath: folder attributes: nil];
	}
    
	NSString *fileName = [NSString stringWithFormat:@"%@.broadcasts", appName];
	
	return [folder stringByAppendingPathComponent: fileName];    
}

-(Boolean)fileExistsAtPath:(NSString *)path
{
	NSFileManager *fMan = [NSFileManager defaultManager];
	
	return [fMan fileExistsAtPath:path];
}


/*************** app menu actions******************/

//MAIN_WINDOW_MENU_TAG

-(IBAction)handleNewMainWindowMenu:(NSMenuItem *)sender
{
	[mainWindow makeKeyAndOrderFront:self];
}

-(IBAction)handleFileImportMenu:(NSMenuItem *)sender
{
    int result;
	NSArray *fileTypes = [NSArray arrayWithObjects: @"txt", @"text",
						  NSFileTypeForHFSTypeCode( 'TEXT' ), nil];
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
	
    [oPanel setAllowsMultipleSelection:NO];
	[oPanel setCanChooseDirectories:NO];
    result = [oPanel runModalForDirectory:NSHomeDirectory()
									 file:nil types:fileTypes];	
	
	NSString *importPath;
	if(result == NSOKButton)
	{
		//todo: should i check that it contains anything?
		importPath = [[oPanel filenames] objectAtIndex:0];
	}
	else
	{
		return;
	}
	
	[self importFromFilePath:importPath];
}

-(IBAction)handleClearCacheMenu:(NSMenuItem *)sender
{
	NSString *path = [self pathForDataFile];
	
	NSFileManager *fMan = [NSFileManager defaultManager];
	
	Boolean suc = [fMan removeItemAtPath:path error:NULL];

	if(!suc)
	{
		NSLog(@"Could not delete cache.");
	}
}
	
- (BOOL)validateMenuItem:(NSMenuItem *)item
{
	if([item tag] == CLEAR_CACHE_MENU)
	{
		NSString *path = [self pathForDataFile];
		return [self fileExistsAtPath:path];
	}
	else if([item tag] == MAIN_WINDOW_MENU_TAG)
	{
		return ![mainWindow isVisible];
	}
	
	return TRUE;
}

/************** calendar actions ******************/


# define DEFAULT_CALENDAR_NAME @"ShortBoard"
-(IBAction)handleAddCalendar:(id)sender
{
	NSLog(@"handleAddCalendar");
	
	NSInteger row = [broadcastTable selectedRow];
	
	if(row == -1)
	{
		//we should never get here
		NSAssert(FALSE, @"handleAddCalender called when no Broadcast was selected.");
		return;
	}
	
	CalCalendarStore *store = [CalCalendarStore defaultCalendarStore];
	
	//get all of the calendars
	NSArray *calendars = [store calendars];
	
	CalCalendar *cal = nil;

	//check and see if the calendar already exists
	for(CalCalendar *c in calendars)
	{
		if([[c title] compare:DEFAULT_CALENDAR_NAME] == NSOrderedSame)
		{
			cal = c;
			break;
		}
	}
	
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
		
	Broadcast *b = [filteredBroadcasts objectAtIndex:row];
	
	CalEvent *event = [CalEvent event];
	event.calendar = cal;
	event.title = b.station;
	
	HoursMinutes *startTime = [[HoursMinutes alloc] initWithString:b.startTime];
	HoursMinutes *endTime = [[HoursMinutes alloc] initWithString:b.endTime];
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
	
	event.notes = [NSString stringWithFormat:@"%@ - %@\n%@\n%@", 
							b.station, b.country, [b.frequencies componentsJoinedByString:@", "],
							b.notes];
	
	// Save changes to an event
	NSError *calError;
	[store saveEvent:event span:CalSpanThisEvent error:&calError];
	
	if (calError == NO)
	{
		NSAlert *alertPanel = [NSAlert alertWithError:calError];
		[alertPanel runModal];
		return;
	}	
}

/**************** search actions ******************/

-(IBAction)handleNowSearch:(NSMenuItem *)nowMenuItem
{
	NSLog(@"handleNowSearch");
	
	NSInteger state;
	
	if([nowMenuItem state] == NSOffState)
	{
		state = NSOnState;
		nowSearch = TRUE;
	}
	else
	{
		state = NSOffState;
		nowSearch = FALSE;
	}
	
	[nowMenuItem setState:state];
	
	[self filterBroadcastsForNow];
	
	//todo: this doesnt always need to be called
	[self refreshData];
}

-(IBAction)handleSearchMenuItems:(NSMenuItem *)menuItem
{
	NSLog(@"handleSearchMenuItems");
	
	if([menuItem state] == NSOffState)
	{
		[menuItem setState:NSOnState];
		
		NSMenu *menu = [menuItem menu];
		NSArray *menuItems = [menu itemArray];
	
		for(NSMenuItem *item in menuItems)
		{
			if(item != menuItem)
			{
				if([item tag] == NOW_MENU_TAG)
				{
					continue;
				}
				
				[item setState:NSOffState];
			}
		}
	}
	
	allSearch = FALSE;
	startSearch = FALSE;
	endSearch = FALSE;
	countrySearch = FALSE;
	stationSearch = FALSE;
	notesSearch = FALSE;
	frequencySearch = FALSE;	
	
	//NSString *title = [menuItem title];
	NSInteger tag = [menuItem tag];
	
	if(tag == ALL_MENU_TAG)
	{
		allSearch = TRUE;
	}
	else if(tag == START_MENU_TAG)
	{
		startSearch = TRUE;
	}
	else if(tag == END_MENU_TAG)
	{
		endSearch = TRUE;
	}
	else if(tag == COUNTRY_MENU_TAG)
	{
		countrySearch = TRUE;
	}
	else if(tag == STATION_MENU_TAG)
	{
		stationSearch = TRUE;
	}
	else if(tag == NOTES_MENU_TAG)
	{
		notesSearch = TRUE;
	}
	else if(tag == FREQUENCY_MENU_TAG)
	{
		frequencySearch = TRUE;
	}
}

-(IBAction)handleSearch:(NSSearchField *)searchField
{
	NSLog(@"handleSearch");
	NSString *searchString = [searchField stringValue];
	
	//todo : the array somestimes get copied when it doesnt need to be
	//specifically, if the searchString is empty and Current menu item
	//is not selected.
	[filteredBroadcasts release];
	filteredBroadcasts = [broadcasts mutableCopy];
	
	if(nowSearch)
	{
		[self filterBroadcastsForNow];
	}	
	
	if([searchString length] == 0)
	{
		[self refreshData];
		return;
	}

	NSPredicate *startPredicate = [NSPredicate predicateWithFormat:@"startTime contains[c] %@", searchString];
	NSPredicate *endPredicate = [NSPredicate predicateWithFormat:@"endTime contains[c] %@", searchString];
	NSPredicate *countryPredicate = [NSPredicate predicateWithFormat:@"country contains[c] %@", searchString];
	NSPredicate *stationPredicate = [NSPredicate predicateWithFormat:@"station contains[c] %@", searchString];
	NSPredicate *notesPredicate = [NSPredicate predicateWithFormat:@"notes contains[c] %@", searchString];
	NSPredicate *frequencyPredicate = [NSPredicate predicateWithFormat:@"ANY frequencies contains[c] %@", searchString];
	
	NSPredicate *predicate;
	
	if(startSearch)
	{
		predicate = startPredicate;
	}
	else if(endSearch)
	{
		predicate = endPredicate;
	}
	else if(countrySearch)
	{
		predicate = countryPredicate;
	}
	else if(stationSearch)
	{
		predicate = stationPredicate;
	}
	else if(notesSearch)
	{
		predicate = notesPredicate;
	}
	else if(frequencySearch)
	{
		predicate = frequencyPredicate;
	}
	else
	{
		predicate = [NSCompoundPredicate
					 orPredicateWithSubpredicates:[NSArray arrayWithObjects:
													startPredicate,
													endPredicate,
													countryPredicate,
													stationPredicate,
													notesPredicate,
													frequencyPredicate,
													nil
					 ]];
	}

	[filteredBroadcasts filterUsingPredicate:predicate];
	
	[self refreshData];
}

/******* NSTableView dataProvider methods **********/

-(id)tableView:(NSTableView *)table objectValueForTableColumn:(NSTableColumn *)column row:(int)row
{
	NSString *identifier = [column identifier];
	
	Broadcast *b = [filteredBroadcasts objectAtIndex:row];
	
	return [b valueForKey:identifier];
}

-(int)numberOfRowsInTableView:(NSTableView *)TableDirectoryRecord
{
	return [filteredBroadcasts count];
}

-(void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
	NSArray *newDescriptors = [tableView sortDescriptors];
	
	[filteredBroadcasts sortUsingDescriptors:newDescriptors];

	[self refreshData];
}

/********** NSTableView delegate methods ****************/

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	NSInteger selectedCount = [broadcastTable numberOfSelectedRows];
	Boolean enabled = (selectedCount > 0);
	
	[calendarButton setEnabled:enabled];
	[addToIcalMenuItem setEnabled:enabled];
}


@end
