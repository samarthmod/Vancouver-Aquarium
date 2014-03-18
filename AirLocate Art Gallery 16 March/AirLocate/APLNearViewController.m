//
//  APLNearViewController.m
//  AirLocate
//
//  Created by Rohit Boolchandani on 3/13/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "APLNearViewController.h"
#import "APLDefaults.h"

#define Major_LightBlue          40058
#define Major_Green         13401
#define Major_Blue      10177
#define Major_Roximity      1
#define Major_Macbook       0

@interface APLNearViewController () <CLLocationManagerDelegate>

@property NSMutableDictionary *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;
@property CLBeacon *nearBeacon;
@property CLBeacon *beaconProcossed;
@property UIActivityIndicatorView *spinner;
@property NSMutableDictionary *cellInformationDict;
@property NSMutableArray* arrayForPlaces;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@property (weak, nonatomic) IBOutlet UIWebView *artWiki;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UILabel *artName;

@property (weak, nonatomic) IBOutlet UIWebView *artVideo;
@property (weak, nonatomic) IBOutlet UIImageView *artImage;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@end

@implementation APLNearViewController

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
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"SampleData" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.arrayForPlaces = [plistDict objectForKey:@"Data"];
    
    self.beacons = [[NSMutableDictionary alloc] init];
    self.beaconProcossed = nil;
    // This location manager will be used to demonstrate how to range beacons.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Populate the regions we will range once.
    self.rangedRegions = [[NSMutableDictionary alloc] init];
    
    // Do any additional setup after loading the view.
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.spinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)]; // I do this because I'm in landscape mode
    //[self.view addSubview:self.spinner]; // spinner is not visible until started
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    for (NSUUID *uuid in [APLDefaults sharedDefaults].supportedProximityUUIDs)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        self.rangedRegions[region] = [NSArray array];
    }
    // Start ranging when the view appears.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
    
    
    
    
    self.navigationController.navigationBar.topItem.title = @"Contextual Informaton";
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Stop ranging when the view goes away.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
    self.beaconProcossed = nil;
}

#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    /*
     CoreLocation will call this delegate method at 1 Hz with updated range information.
     Beacons will be categorized and displayed by proximity.  A beacon can belong to multiple
     regions.  It will be displayed multiple times if that is the case.  If that is not desired,
     use a set instead of an array.
     */
    self.rangedRegions[region] = beacons;
    [self.beacons removeAllObjects];
    
    NSMutableArray *allBeacons = [NSMutableArray array];
    
    for (NSArray *regionResult in [self.rangedRegions allValues])
    {
        [allBeacons addObjectsFromArray:regionResult];
    }
    NSLog(@"All beacons: %@",allBeacons);
    if ([allBeacons count])
    {
        for (int i = 0; i < [allBeacons count]; i++)
        {
            CLBeacon *tempBeacon = [allBeacons objectAtIndex:i];
            if ([tempBeacon accuracy] > 3.0 || [tempBeacon accuracy] == -1)
            {
                [allBeacons removeObject:tempBeacon];
            }
        }
        self.nearBeacon = [allBeacons objectAtIndex:0];
        
        NSString *uuidStringBeaconFound = [[self.nearBeacon proximityUUID] UUIDString];
        NSString *majorBeaconFound = [NSString stringWithFormat:@"%ld",(long)[[self.nearBeacon major] integerValue]];
        NSString *uniqueID = [NSString stringWithFormat:@"%@%@",uuidStringBeaconFound,majorBeaconFound];
        
        
        NSString *uuidStringBeaconProcessed = [[self.beaconProcossed proximityUUID] UUIDString];
        NSString *majorBeaconProcessed = [NSString stringWithFormat:@"%ld",(long)[[self.beaconProcossed major] integerValue]];
        NSString *uniqueIDProcessed = [NSString stringWithFormat:@"%@%@",uuidStringBeaconProcessed,majorBeaconProcessed];
        
        
        
        if ([uniqueID isEqualToString:uniqueIDProcessed])
        {
            //do nothing
        }
        else
        {
            //[self.spinner startAnimating];
            [self.activityView setHidden:NO];
            [self provideContextualInformationfor:self.nearBeacon];
            self.beaconProcossed = self.nearBeacon;
        }
    }
    
    
    
    
    
    
}





- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
    NSLog(@"Error in ranging: %@",[error description]);
}

- (void) stopScanning
{
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
}

- (void) startScanning
{
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
}

- (void) provideContextualInformationfor:(CLBeacon *) nearBeacon
{
    if (nearBeacon == self.beaconProcossed)
    {
        return;
    }
//    else
//    {
//        Reachability *reach = [Reachability reachabilityForInternetConnection];
//        
//        NetworkStatus netStatus = [reach currentReachabilityStatus];
//        [[APLDefaults sharedDefaults] setLogInActionDone:YES];
//        if (netStatus == NotReachable)
//        {
//            //fetch locally
//            [self.mainScrollView setAlpha:0.5];
//            [UIView beginAnimations:nil context:NULL];
//            [UIView setAnimationDuration: 3.0];
//            [UIView setAnimationBeginsFromCurrentState:true];
//            
//            
//         
//            
//            
//            self.artImage.image = [UIImage imageNamed:@"artnew.jpg"];
//            //[self.artVideo loadRequest:[NSURLRequest requestWithURL:videoURL]];
//            //[self.artWiki loadRequest:[NSURLRequest requestWithURL:wikiURL]];
//            self.headingLabel.text = @"Local Fetching";
//            
//            
//            NSLog(@"Received update");
//            //[self.spinner stopAnimating];
//            
//            
//            self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, 2000);
//            [self.mainScrollView setAlpha:1];
//            [UIView commitAnimations];
//            [self.activityView setHidden:YES];
//            
//        }
//        else
//        {
//            
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                                      @"UID = %@ AND Major = %d",[nearBeacon.proximityUUID UUIDString],[[nearBeacon major] integerValue]];
//            PFQuery *query = [PFQuery queryWithClassName:@"ArtBeacon" predicate:predicate];
//            [query findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
//        }
//    }
    
    NSString *stringMajor = [NSString stringWithFormat:@"%@",nearBeacon.major];
    for (int i = 0; i < [self.arrayForPlaces count]; i++)
    {
        NSDictionary *tempDict = [self.arrayForPlaces objectAtIndex:i];
        NSArray *allValues = [tempDict allValues];
        
        if([allValues containsObject:stringMajor])
        {
            NSString *frontImageString = [tempDict valueForKey:@"Image"];
            NSString *backImageString = [tempDict valueForKey:@"backImage"];
            NSString *regionString = [tempDict valueForKey:@"Country"];
            NSString *colorString = [tempDict valueForKey:@"Color"];
            NSString *combinedString = [regionString stringByAppendingFormat:@"- %@",colorString];
            
            Reachability *reach = [Reachability reachabilityForInternetConnection];
            
            NetworkStatus netStatus = [reach currentReachabilityStatus];
            
            if (netStatus != NotReachable)
            {
                NSString *videoURLString = [tempDict valueForKey:@"VideoURL"];
                NSString *wikiURLString = @"http://www.vanaqua.org/";
                NSURL *videoURL = [NSURL URLWithString:videoURLString];
                NSURL *wikiURL = [NSURL URLWithString:wikiURLString];
                [self.artVideo loadRequest:[NSURLRequest requestWithURL:videoURL]];
                [self.artWiki loadRequest:[NSURLRequest requestWithURL:wikiURL]];

            }
            
            
            self.artImage.image = [UIImage imageNamed:frontImageString];
           
            self.headingLabel.text = combinedString;
            self.welcomeLabel.text = [@"Welcome to " stringByAppendingFormat:@"%@- %@",regionString,colorString];
            self.backImageView.image = [UIImage imageNamed:backImageString];
            
            break;
        }
    }
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, 2500);
    [self.mainScrollView setAlpha:1];
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:3.5
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) targetMethod:(id)userInfo
{
    [self.activityView setHidden:YES];
}

- (void) callbackWithResult:(NSArray *)result error:(NSError *)error
{
    
    if ([result count] >0)
    {
        
        
        
        PFObject *uidObject = [result objectAtIndex:0];
        NSString *imageLocationString = [uidObject valueForKey:@"imageLocation"];
        NSString *artVideoString = [uidObject valueForKey:@"VideoLink"];
        NSString *artNameString = [uidObject valueForKey:@"imageName"];
        NSString *artInfoString = [uidObject valueForKey:@"WikiLink"];
        
        NSURL *imageURL = [NSURL URLWithString:imageLocationString];
        NSURL *videoURL = [NSURL URLWithString:artVideoString];
        NSURL *wikiURL = [NSURL URLWithString:artInfoString];
        
        
        
        self.artImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        [self.artVideo loadRequest:[NSURLRequest requestWithURL:videoURL]];
        [self.artWiki loadRequest:[NSURLRequest requestWithURL:wikiURL]];
        self.headingLabel.text = artNameString;
        
        [self.mainScrollView setAlpha:0.5];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: 3.0];
        [UIView setAnimationBeginsFromCurrentState:true];
        NSLog(@"Received update");
        //[self.spinner stopAnimating];
        
        if ([artNameString isEqualToString:@"Demo - Light Blue"])
        {
            [self.mainScrollView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:20 alpha:1]];
        }
        else if ([artNameString isEqualToString:@"Demo - Dark Blue"])
        {
            [self.mainScrollView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:204 alpha:1]];
        }
        else if ([artNameString isEqualToString:@"Demo - Green"])
        {
            [self.mainScrollView setBackgroundColor:[UIColor colorWithRed:0 green:200 blue:0 alpha:1]];
        }
        else
        {
            [self.mainScrollView setBackgroundColor:[UIColor colorWithRed:10 green:100 blue:200 alpha:1]];
        }
        
        [self.mainScrollView setAlpha:1];
        [UIView commitAnimations];
        [self.activityView setHidden:YES];
        //[self startScanning];
        
    }
    
    // in case of connectivity issues, populate the default UUIDs
    else
    {
        NSLog(@"Error in fetching object: %@",[error description]);
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
