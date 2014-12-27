//
//  EventsWithTKLibViewController.h
//  hospitality
//
//  Created by Nghiem Toan Trung on 7/10/14.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
#import <TapkuLibrary/TKCalendarMonthTableViewController.h>

@interface EventsWithTKLibViewController : TKCalendarMonthViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
- (void) updateTableOffset:(BOOL)animated;

@end
