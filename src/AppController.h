/*
 
 The MIT License
 
 Copyright (c) 2010 Mike Chambers (mikechambers@gmail.com)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE. 
 
 */

#import <Cocoa/Cocoa.h>
@class Broadcast;
@class CalendarSheetController;

@interface AppController : NSObject
{
	IBOutlet NSTableView *broadcastTable;

	NSMutableArray *filteredBroadcasts;
	NSMutableArray *broadcasts;
	
	CalendarSheetController *calendarSheet;

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
