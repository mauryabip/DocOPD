//
//  termsViewController.m
//  docOPD
//
//  Created by Virinchi Software on 3/2/16.
//  Copyright © 2016 DocOPD Technologies Pvt. Ltd. All rights reserved.
//

#import "termsViewController.h"
#import "AKTimerProgressView.h"
#import "SVWebViewControllerActivityChrome.h"
#import "SVWebViewControllerActivitySafari.h"
@interface termsViewController ()
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarButtonItem;
@property (strong, nonatomic) AKTimerProgressView *progressView;
@end

@implementation termsViewController
@synthesize indicatorSpinner;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.headerTitleText isEqualToString:@"Contact Us"]) {
        screenName=@"ContactUS";
    }
    else{
         screenName=@"Term&Condition";
    }
    
    self.LblTitle.text = self.headerTitleText;
    NSURL *url = [NSURL URLWithString:self.fullURL];
    // NSURL *url = [NSURL URLWithString:@"www.virinchisoftware.com"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    [self setNeedsStatusBarAppearanceUpdate];
    [self updateToolbarItems];
    _progressView = [[AKTimerProgressView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 1)];
    [self.topbarView addSubview:_progressView];
//    NSLog(@"full url%@",self.fullURL);
    
}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleDefault;
//}
-(void)dealloc {
    [_progressView loadInvalidStopActivity];
}

-(void)viewWillAppear:(BOOL)animated{
//    NSLog(@"viewwill Appear");
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value
                :[NSString stringWithFormat:@"%@Screen",screenName]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [Localytics tagEvent:[NSString stringWithFormat:@"%@Screen",screenName]];
}
- (IBAction)GoToBack:(id)sender {
     [Localytics tagEvent:[NSString stringWithFormat:@"%@AboutUSClick",screenName]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
/*
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [indicatorSpinner startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.progressView.progress = 0;
    isVisible = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicatorSpinner stopAnimating];
    indicatorSpinner.hidden = TRUE;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    isVisible = true;
    self.progressView.progress = 1.0;
}
-(void)timerCallback {
    if (isVisible) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = true;
            [timer invalidate];
        }
        else {
            self.progressView.progress += 0.1;
        }
    }
    else {
        self.progressView.progress += 0.02;
        if (self.progressView.progress >= 0.8)
        {
            if (self.progressView.progress >= 0.97)
            {
                self.progressView.progress = 0.97;
            }else{
                self.progressView.progress += 0.01;
            }
            
        }
    }
}
*/
- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/SVWebViewControllerBack"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(goBackTapped:)];
        _backBarButtonItem.width = 18.0f;
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/SVWebViewControllerNext"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(goForwardTapped:)];
        _forwardBarButtonItem.width = 18.0f;
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped:)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopTapped:)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    if (!_actionBarButtonItem) {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
    }
    return _actionBarButtonItem;
}


#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.self.webView.canGoForward;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat toolbarWidth = 250.0f;
        fixedSpace.width = 35.0f;
        
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          refreshStopBarButtonItem,
                          fixedSpace,
                          self.backBarButtonItem,
                          fixedSpace,
                          self.forwardBarButtonItem,
                          fixedSpace,
                          self.actionBarButtonItem,
                          nil];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        toolbar.items = items;
        toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationItem.rightBarButtonItems = items.reverseObjectEnumerator.allObjects;
    }
    
    else {
        NSArray *items = [NSArray arrayWithObjects:
                          fixedSpace,
                          self.backBarButtonItem,
                          flexibleSpace,
                          self.forwardBarButtonItem,
                          flexibleSpace,
                          refreshStopBarButtonItem,
                          flexibleSpace,
                          self.actionBarButtonItem,
                          fixedSpace,
                          nil];
        
//        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
//        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
//        self.toolbarItems = items;
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, [UIScreen mainScreen].bounds.size.height-44, self.webView.frame.size.width, 44.0f)];
        toolbar.items = items;
        [self.view addSubview:toolbar];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
      [self.progressView loadStart];
//    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
//        [self.delegate webViewDidStartLoad:webView];
//    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
//    if (self.navigationItem.title == nil) {
//        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    }
    self.LblTitle.text =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateToolbarItems];
      [self.progressView loadFinished];
//    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
//        [self.delegate webViewDidFinishLoad:webView];
//    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
    [self.progressView loadFaild];
//    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
//        [self.delegate webView:webView didFailLoadWithError:error];
//    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
//        return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
//    }
    
    return YES;
}

#pragma mark - Target actions

- (void)goBackTapped:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (void)goForwardTapped:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (void)reloadTapped:(UIBarButtonItem *)sender {
    [self.webView reload];
}

- (void)stopTapped:(UIBarButtonItem *)sender {
    [self.webView stopLoading];
    [self updateToolbarItems];
}


- (void)actionButtonTappeds:(id)sender {


}


- (void)actionButtonTapped:(id)sender {
//    NSURL *url = self.webView.request.URL ? self.webView.request.URL : [NSURL URLWithString:self.fullURL];
    NSURL *url = [NSURL URLWithString:self.fullURL];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor],NSForegroundColorAttributeName,
      nil]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
   // [self setStatusBarBackgroundColor:[UIColor blackColor]];

    if (url != nil) {
        NSArray *activities = @[[SVWebViewControllerActivitySafari new], [SVWebViewControllerActivityChrome new]];
        
        if ([[url absoluteString] hasPrefix:@"file:///"]) {
            UIDocumentInteractionController *dc = [UIDocumentInteractionController interactionControllerWithURL:url];
            [dc presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
        } else {
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:activities];
            
#ifdef __IPHONE_8_0
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 &&
                UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                UIPopoverPresentationController *ctrl = activityController.popoverPresentationController;
                ctrl.sourceView = self.view;
                ctrl.barButtonItem = sender;
            }
#endif
            
            [self presentViewController:activityController animated:YES completion:nil];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
//- (void)setStatusBarBackgroundColor:(UIColor *)color {
//    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = [UIColor dOPDThemeColor];
//    }
//}
@end
