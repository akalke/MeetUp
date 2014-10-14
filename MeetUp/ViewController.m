//
//  ViewController.m
//  MeetUp
//
//  Created by Amaeya Kalke on 10/13/14.
//  Copyright (c) 2014 Amaeya Kalke. All rights reserved.
//

#import "ViewController.h"
#import "MeetUpDetailViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *meetUpArray;
@property NSDictionary *meetupDictionary;
@property (strong, nonatomic) IBOutlet UITextField *textFieldSearch;
@property NSString *searchString;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFieldSearch.placeholder = @"Enter your keyword search here";
    [self loadJSONData];


    // Do any additional setup after loading the view, typically from a nib.

}


#pragma setup Table View
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    self.meetupDictionary = [self.meetUpArray objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCellID" forIndexPath:indexPath];
    cell.textLabel.text = [self.meetupDictionary objectForKey: @"name"];
    cell.textLabel.numberOfLines = 4;
    cell.detailTextLabel.text = [[self.meetupDictionary objectForKey:@"venue"] objectForKey: @"address_1"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"%lu", (unsigned long)self.meetUpArray.count);
    return self.meetUpArray.count;
}

#pragma initial data load
-(void)loadJSONData{

    NSURL *url = [NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=4819446a798715cb5279415717550"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Meetup Data: %@", jsonString);

        NSError *jsonError = nil;
        self.meetupDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error: &jsonError];
        self.meetUpArray= [self.meetupDictionary objectForKey:@"results"];

        [self.tableView reloadData];
        //NSLog(@"%lu",(unsigned long)self.meetUpArray.count);

        //NSLog(@"Connection error: %@", connectionError);
        //NSLog(@"JSON Error: %@", jsonError);
    }];
    
}

#pragma search for events using textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *urlString = [[NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=4819446a798715cb5279415717550", textField.text] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Meetup Data: %@", jsonString);

        NSError *jsonError = nil;
        self.meetupDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error: &jsonError];
        self.meetUpArray= [self.meetupDictionary objectForKey:@"results"];

        [self.tableView reloadData];

        //NSLog(@"Connection error: %@", connectionError);
        //NSLog(@"JSON Error: %@", jsonError);

    }];
    return YES;
}


#pragma Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"meetupDetailSegue"]){
        MeetUpDetailViewController *meetUpDetailViewController = segue.destinationViewController;
        meetUpDetailViewController.meetupDetailDictionary = [self.meetUpArray objectAtIndex: self.tableView.indexPathForSelectedRow.row];
    }

}

@end
