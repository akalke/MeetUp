//
//  ViewController.m
//  MeetUp
//
//  Created by Amaeya Kalke on 10/13/14.
//  Copyright (c) 2014 Amaeya Kalke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *meetUpArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadJSONData];


    // Do any additional setup after loading the view, typically from a nib.

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *meetupDictionary = [[self.meetUpArray valueForKey:@"results"] objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCellID" forIndexPath:indexPath];
    cell.textLabel.text = [meetupDictionary objectForKey: @"name"];
    cell.detailTextLabel.text = [meetupDictionary objectForKey:@"description"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu", (unsigned long)self.meetUpArray.count);
    return self.meetUpArray.count;
}

-(void)loadJSONData{

    NSURL *url = [NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=4819446a798715cb5279415717550"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Meetup Data: %@", jsonString);

        NSError *jsonError = nil;
        self.meetUpArray = [NSJSONSerialization JSONObjectWithData:data options:0 error: &jsonError];

        [self.tableView reloadData];

        NSLog(@"Connection error: %@", connectionError);
        NSLog(@"JSON Error: %@", jsonError);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
