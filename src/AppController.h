//
//  AppController.h
//  ShortBoard
//
//  Created by Mike Chambers on 11/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Broadcast;

@interface AppController : NSObject
{
	IBOutlet NSTableView *broadcastTable;

	NSMutableArray *filteredBroadcasts;
	NSMutableArray *broadcasts;

	IBOutlet NSTextField *countLabel;
	IBOutlet NSTextField *timerLabel;
	
	IBOutlet NSWindow *mainWindow;
	
	IBOutlet NSToolbar *topToolBar;
	
	IBOutlet NSButton *calendarButton;
	
	IBOutlet NSMenuItem *addToIcalMenuItem;
	
	Boolean allSearch;
	Boolean startSearch;
	Boolean endSearch;
	Boolean countrySearch;
	Boolean stationSearch;
	Boolean notesSearch;
	Boolean frequencySearch;
	Boolean nowSearch;
}

@property(readwrite, retain) NSMutableArray *broadcasts;

-(void)updateBroadcasts:(NSMutableArray *)b;

-(void)refreshData;
-(void)filterBroadcastsForNow;
-(void)importFromFilePath:(NSString *)filePath;

-(Boolean)fileExistsAtPath:(NSString *)path;

//calendar actions
-(IBAction)handleAddCalendar:(id)sender;

//search actions
-(IBAction)handleSearchMenuItems:(NSMenuItem *)menuItem;
-(IBAction)handleSearch:(NSSearchField *)searchField;
-(IBAction)handleNowSearch:(NSMenuItem *)nowMenuItem;


//app menu actions
-(IBAction)handleFileImportMenu:(NSMenuItem *)sender;
-(IBAction)handleClearCacheMenu:(NSMenuItem *)sender;
-(IBAction)handleNewMainWindowMenu:(NSMenuItem *)sender;

//data persitence
- (NSString *) pathForDataFile;
- (void)saveBroadcastData;
- (void)loadBroadcastData;

@end
