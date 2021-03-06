//
//  MeetingViewController.m
//  FORCE
//
//  Created by Alex on 10/27/13.
//  Copyright (c) 2013 Middle Tennessee State University. All rights reserved.
//

#import "MeetingViewController.h"
#import "MeetingTabBarController.h"
#import "SWRevealViewController.h"
#import "DataClass.h"
#import "Meeting.h"

@interface MeetingViewController ()

@end

@implementation MeetingViewController

NSArray *meetings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DataClass *data=[DataClass getInstance];
    meetings = [data.meetings sortedArrayUsingComparator:^(Meeting *m1, Meeting *m2) {
        return [[m1 date] compare:[m2 date]];
    }];
    
    
    
    self.title = @"Meetings";
    //self.view.backgroundColor = [UIColor clearColor];
    //self.view.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.477 blue: 1.0 alpha:1.0];
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    //_sidebarButton.target = self.revealViewController;
    //_sidebarButton.action = @selector(revealToggle:);
    
    /* navigation bar button button */
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(10.0, 2.0, 25.5, 24.0)];
    [btn setBackgroundImage:[UIImage imageNamed:@"Nav_Icon.png"] forState:UIControlStateNormal];
    [btn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem=barBtn;
    /* navigation bar button */
    
    /* search bar button */
    UIButton *btn2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(10.0, 2.0, 25.5, 24.0)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"Search_Magnify_Icon.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self.navigationController.searchDisplayController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    self.navigationItem.rightBarButtonItem=barBtn2;
    /* search bar button */

}

// This is called both on load and after returning to this view
// The gestures need to be set both times, so that was moved here.
- (void)viewDidAppear:(BOOL)animated
{
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [meetings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MeetingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier/* forIndexPath:indexPath*/];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:3];
    UILabel *companyLabel = (UILabel *)[cell viewWithTag:4];
    UILabel *peopleCountLabel = (UILabel *)[cell viewWithTag:5];
    UILabel *filesCountLabel = (UILabel *)[cell viewWithTag:6];
    
    Meeting *meet = [meetings objectAtIndex:indexPath.row];
    
    nameLabel.text = meet.name;
    companyLabel.text = meet.company;
    
    peopleCountLabel.text = [NSString stringWithFormat:@"%d", [meet.people count]];
    filesCountLabel.text = [NSString stringWithFormat:@"%d", [meet.files count]];
    
    //stuff for current date
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEE MMM dd yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    //tomorrow's date
    NSString *tDate = [dateFormatter stringFromDate:[currDate dateByAddingTimeInterval:60*60*24]];
    
    
    //stuff for stored date and time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE MMM dd yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:meet.date];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *time = [formatter stringFromDate:meet.date];
    
    //figure out if the date is today or tomorrow only.
    if([stringFromDate isEqualToString:dateString])
        dateLabel.text = @"Today";
    else if ([dateString isEqualToString:tDate])
        dateLabel.text = @"Tomorrow";
    else
        dateLabel.text = stringFromDate;
    
    timeLabel.text = time;
    
    return cell;
}


// Called when you click on an item in the search results
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Create a new meeting page, using the identifier defined in Storyboard
    MeetingTabBarController *stubController = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetingTabBar"];
    stubController.view.backgroundColor = [UIColor whiteColor];
    
    Meeting *meet = [meetings objectAtIndex:indexPath.row];
    stubController.title = meet.name;
    stubController.meeting = meet;
    
    // Push the new meeting page on top of the current page
    [(UINavigationController*)self.revealViewController.frontViewController pushViewController:stubController animated:YES];
    
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}


- (void) viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        MeetingTabBarController *stubController = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetingTabBar"];
        [stubController setSelectedIndex:4];
        stubController.view.backgroundColor = [UIColor whiteColor];
        
        Meeting *meet = [[DataClass getInstance] next];
        stubController.title = meet.name;
        stubController.meeting = meet;
        
        // Push the new meeting page on top of the current page
        [(UINavigationController*)self.revealViewController.frontViewController pushViewController:stubController animated:YES];
    }
    [super motionEnded:motion withEvent:event];
}


@end
