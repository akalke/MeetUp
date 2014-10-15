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

    // Do any additional setup after loading the view.
}

-(void)loadJSONData{

    NSString *urlString = [NSString stringWithFormat:@"https://api.meetup.com/2/members?&sign=true&photo-host=public&member_id=%@&page=20&key=4819446a798715cb5279415717550", self.userID];

    NSLog(@"%@", self.userID);

    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Profile Data: %@", jsonString);

        NSError *jsonError = nil;

        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error: &jsonError];

        NSArray *users = [jsonDictionary objectForKey:@"results"];

        self.userProfileDictionary = [users objectAtIndex:0];



        NSLog(@"Connection error: %@", connectionError);
        NSLog(@"JSON Error: %@", jsonError);

        NSLog(@"Name: %@",[self.userProfileDictionary objectForKey:@"name"]);
    }];
}

@end
