//
//  RssFeedTableViewController.h
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AutoRotatingTableViewController.h"

@interface RssFeedTableViewController : AutoRotatingTableViewController {
	NSString* feedTitle;
}

@property (nonatomic, retain) NSString* feedTitle;

@end
