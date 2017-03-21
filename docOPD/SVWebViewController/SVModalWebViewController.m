//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"

@interface SVModalWebViewController ()

@property (nonatomic, strong) SVWebViewController *webViewController;

@end

@interface SVWebViewController (DoneButton)

- (void)doneButtonTapped:(id)sender;

@end


@implementation SVModalWebViewController

#pragma mark - Initialization


- (instancetype)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:URL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request {
    self.webViewController = [[SVWebViewController alloc] initWithURLRequest:request];
    if (self = [super initWithRootViewController:self.webViewController]) {
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"white-cancel.png"] forState:UIControlStateNormal];
        [button addTarget:self.webViewController action:@selector(doneButtonTapped:)forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, 0, 40, 40)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(12, 0, 12, 24)];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = barButton;
        
        
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                    target:self.webViewController
//                                                                                    action:@selector(doneButtonTapped:)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            self.webViewController.navigationItem.leftBarButtonItem = barButton;
        else
            self.webViewController.navigationItem.leftBarButtonItem = barButton;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.webViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Helvetica" size:15],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,
      nil]];
//    [[UINavigationBar appearance] setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor whiteColor],
//       NSFontAttributeName:[UIFont fontWithName:@"system" size:15]}];
}

#pragma mark - Delegate

- (void)setWebViewDelegate:(id<UIWebViewDelegate>)webViewDelegate {
    self.webViewController.delegate = webViewDelegate;
}

- (id<UIWebViewDelegate>)webViewDelegate {
    return self.webViewController.delegate;
}

@end
