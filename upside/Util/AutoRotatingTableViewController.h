//
//  AutoRotatingTableViewController.h
//  upside
//
//  Created by Victor Costan on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AutoRotatingTableViewController : UITableViewController {
	NSString* wideCellReuseIdentifier;
	NSString* wideCellNib;
	NSString* narrowCellReuseIdentifier;
	NSString* narrowCellNib;
	Class cellClass;
}

// Subclasses should set this to the reuse identifier for landscape mode cells.
@property (nonatomic, retain) NSString* wideCellReuseIdentifier;
// Subclasses should set this to the NIB for landscape mode cells.
@property (nonatomic, retain) NSString* wideCellNib;
// Subclasses should set this to the reuse identifier for portrait mode cells.
@property (nonatomic, retain) NSString* narrowCellReuseIdentifier;
// Subclasses should set this to the NIB for portrait mode cells.
@property (nonatomic, retain) NSString* narrowCellNib;
// Subclasses should set this to class of the table cells.
@property (nonatomic, retain) Class cellClass;

// Subclasses should override this and call the super version.
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
