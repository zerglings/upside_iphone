//
//  NewsArticleViewController.h
//  upside
//
//  Created by Victor Costan on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsItem;

@interface NewsArticleViewController : UIViewController {
	IBOutlet UIWebView* articleView;

	BOOL connectionIndicator;	
	
	NewsItem* newsItem;
}

@property (nonatomic, retain) NewsItem* newsItem;

@end
