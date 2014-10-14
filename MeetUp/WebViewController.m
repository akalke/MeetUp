//
//  WebViewController.m
//  MeetUp
//
//  Created by Amaeya Kalke on 10/13/14.
//  Copyright (c) 2014 Amaeya Kalke. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadPage{
    //NSString *urlString = [NSString stringWithFormat: @"http://en.wikipedia.org/wiki/%@", self.cityNameWeb];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self showHideNavButtons];
}


#pragma navigation
- (IBAction)onBackButtonPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
}

-(void)showHideNavButtons{
    //This method shows and hides the back and forward navigation items depending on if the browser has the ability to go back/forward a page.
    if(self.webView.canGoBack == YES){
        [self.backButton setEnabled:YES];
    }
    else{
        [self.backButton setEnabled: NO];
    }

    if(self.webView.canGoForward == YES){
        [self.forwardButton setEnabled: YES];
    }
    else{
        [self.forwardButton setEnabled: NO];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
