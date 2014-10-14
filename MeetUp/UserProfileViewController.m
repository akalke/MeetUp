//
//  UserProfileViewController.m
//  MeetUp
//
//  Created by Amaeya Kalke on 10/14/14.
//  Copyright (c) 2014 Amaeya Kalke. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()
@property NSDictionary *userProfileDictionary;
@property NSArray *userProfileArray;
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadJSONData];

    NSLog(@"%@", [[self.userProfileDictionary objectForKey:@"results"] objectForKey:@"name"]);
    // Do any additional setup after loading the view.
}

-(void)loadJSONData{

    NSString *urlString = [NSString stringWithFormat:@"https://api.meetup.com/2/members?&sign=true&photo-host=public&member_id=%@&page=20&key=4819446a798715cb5279415717550", self.userID];

    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Profile Data: %@", jsonString);

        NSError *jsonError = nil;
        self.userProfileDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error: &jsonError];
        self.userProfileArray = [self.userProfileDictionary objectForKey:@"results"];

        NSLog(@"%lu",(unsigned long)self.userProfileArray.count);

        NSLog(@"Connection error: %@", connectionError);
        NSLog(@"JSON Error: %@", jsonError);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    animated = NO;
    self.navigationItem.title = [self.userProfileDictionary objectForKey:@"name"];
}
@end
