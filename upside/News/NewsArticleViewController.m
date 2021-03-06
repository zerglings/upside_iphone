//
//  NewsArticleViewController.m
//  StockPlay
//
//  Created by Victor Costan on 1/10/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "NewsArticleViewController.h"

#import "ControllerSupport.h"
#import "NewsItem.h"


@implementation NewsArticleViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        connectionIndicator = NO;
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
-(void)loadView {
}
*/

-(void)viewDidDisappear:(BOOL)animated {
  [(UIWebView*)self.view stopLoading];
  if (connectionIndicator) {
    connectionIndicator = NO;
    [ZNNetworkProgress connectionDone];
  }
  [super viewDidDisappear:animated];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad {
    [super viewDidLoad];
}
*/

// Override to allow orientations other than the default portrait orientation.
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


-(void)dealloc {
  [newsItem release];
    [super dealloc];
}


@synthesize newsItem;

-(void)setNewsItem:(NewsItem*) theNewsItem {
  [theNewsItem retain];
  [newsItem release];
  newsItem = theNewsItem;

  self.navigationItem.title = [newsItem title];
  [(UIWebView*)self.view loadRequest:[NSURLRequest requestWithURL:
                    [NSURL URLWithString:[newsItem url]]]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
  if (!connectionIndicator) {
    connectionIndicator = YES;
    [ZNNetworkProgress connectionStarted];
  }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
  if (connectionIndicator) {
    connectionIndicator = NO;
    [ZNNetworkProgress connectionDone];
  }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  if (connectionIndicator) {
    connectionIndicator = NO;
    [ZNNetworkProgress connectionDone];
  }
}

@end
