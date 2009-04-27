//
//  NewsArticleViewController.h
//  StockPlay
//
//  Created by Victor Costan on 1/10/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsItem;

@interface NewsArticleViewController : UIViewController {
  //IBOutlet UIWebView* articleView;

  BOOL connectionIndicator;

  NewsItem* newsItem;
}

@property (nonatomic, retain) NewsItem* newsItem;

@end
