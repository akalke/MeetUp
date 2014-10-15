//
//  MeetUpDetailViewController.m
//  MeetUp
//
//  Created by Amaeya Kalke on 10/13/14.
//  Copyright (c) 2014 Amaeya Kalke. All rights reserved.
//

#import "MeetUpDetailViewController.h"
#import "WebViewController.h"
#import "UserProfileViewController.h"

@interface MeetUpDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *eventName;
@property (strong, nonatomic) IBOutlet UILabel *rsvpCount;
@property (strong, nonatomic) IBOutlet UITextView *hostingInformation;
@property (strong, nonatomic) IBOutlet UITextView *eventDescription;
@property (strong, nonatomic) IBOutlet UIButton *webButton;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) NSArray *commentsArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *commentsDictionary;


@end

@implementation MeetUpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventName.text = [NSString stringWithFormat:@"Event Name: %@",[self.meetupDetailDictionary objectForKey: @"name"]];
    self.rsvpCount.text = [NSString stringWithFormat:@"Number of RSVPs: %@", [self.meetupDetailDictionary objectForKey: @"yes_rsvp_count"]];
    self.hostingInformation.text = [NSString stringWithFormat:@"Hosting Information: %@", [self.meetupDetailDictionary objectForKey: @"how_to_find_us"]];
    self.eventDescription.text = [NSString stringWithFormat:@"Description: %@", [self.meetupDetailDictionary objectForKey: @"description"]];
    self.urlString = [self.meetupDetailDictionary objectForKey: @"event_url"];

    [self loadJSONData];
}

-(void)viewWillAppear:(BOOL)animated{
    animated = NO;
    self.navigationItem.title = [self.meetupDetailDictionary objectForKey: @"name"];
}


#pragma - load data
-(void)loadJSONData{
    //Construct URL with group_id information that is passed in for specific event
    NSString *urlString = [NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&group_id=%@&page=20&key=4819446a798715cb5279415717550", [[self.meetupDetailDictionary objectForKey:@"group"] objectForKey:@"id"]];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        //Load JSON data in
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Comments Data: %@", jsonString);

        NSError *jsonError = nil;
        self.commentsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error: &jsonError];
        self.commentsArray = [self.commentsDictionary objectForKey:@"results"];

        [self.tableView reloadData];
        //NSLog(@"%lu",(unsigned long)self.commentsArray.count);

        NSLog(@"Connection error: %@", connectionError);
        NSLog(@"JSON Error: %@", jsonError);
    }];

}

#pragma load comments
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Grab comments data
    //use local variables when/where possible. reduces bug potential
    self.commentsDictionary = [self.commentsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCommentsCellID" forIndexPath:indexPath];

    //Set title and linebreaks within cell
    cell.textLabel.text = [self.commentsDictionary objectForKey: @"comment"];
    cell.textLabel.numberOfLines = 4;

    //Convert time into date/timestamp
    double ms = [[self.commentsDictionary objectForKey:@"time"] doubleValue];
    NSTimeInterval seconds = ms/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];

    //Create subtitle text string - author and date
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", [self.commentsDictionary objectForKey:@"member_name"], date.description];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"%lu", (unsigned long)self.meetUpArray.count);
    return self.commentsArray.count;
}




#pragma prepare for segue - segue can go to either website or to user profile
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"webViewSegue"]){
        WebViewController *webViewVC = segue.destinationViewController;
        webViewVC.url = self.urlString;
    }
    else if([segue.identifier isEqualToString:@"userProfileSegue"]){
        UserProfileViewController *userProfileVC = segue.destinationViewController;
        userProfileVC.userID = [self.commentsDictionary objectForKey: @"member_id"];
    }
}


@end
