//
//  ALMapViewController.m
//  AirLocate
//
//  Created by Rohit Boolchandani on 3/15/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "APLDefaults.h"
#import "ALMapViewController.h"

@import CoreLocation;

#define Major_LightBlue          40058
#define Major_Green         13401
#define Major_Blue      10177
#define Major_Roximity      1
#define Major_Macbook       0


#define Location_Sam_Room_White     CGRectMake(189,891,54,52)
#define Location_Rohit_Room_LightBlue     CGRectMake(446,741,54,52)
#define Location_Kitchen_Room_Green     CGRectMake(218,232,54,52)
#define Location_Hall_Room_Blue     CGRectMake(425,153,54,52)

#define Roximity_ObjectID   @"dM4zN00da8"
#define DarkBlue_ObjectID   @"QUEfntgJB5"
#define LightBlue_ObjectID  @"6jnRn2UEOZ"
#define Green_ObjectID      @"s4LlSBF0tZ"
#define Macbook_ObjectID    @"JTZTRbMicD"

@interface ALMapViewController () <CLLocationManagerDelegate>

@property NSMutableDictionary *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;
@property CLBeacon *foundBeacon;
@property CLBeacon *beaconProcossed;


@property (weak, nonatomic) IBOutlet UIImageView *homeMap;

@property (weak, nonatomic) IBOutlet UIImageView *userLocation;

@end

@implementation ALMapViewController

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
    self.beaconProcossed = nil;
    self.beacons = [[NSMutableDictionary alloc] init];
    // This location manager will be used to demonstrate how to range beacons.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Populate the regions we will range once.
    self.rangedRegions = [[NSMutableDictionary alloc] init];
    
    
    // Do any additional setup after loading the view.
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
    
    self.navigationController.navigationBar.topItem.title = @"Indoor Positioning";
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Stop ranging when the view goes away.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
    self.userLocation.hidden = YES;
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
    
    for (NSNumber *range in @[@(CLProximityNear),@(CLProximityImmediate)])
    {
        NSArray *proximityBeacons = [allBeacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", [range intValue]]];
        NSMutableArray *proxArr = [[NSMutableArray alloc] initWithArray:proximityBeacons];
        
        for (int i = 0; i < [proxArr count]; i++)
        {
            CLBeacon *tempBeacon = [proximityBeacons objectAtIndex:i];
            if ([tempBeacon accuracy] > 3.0)
            {
                [proxArr removeObject:tempBeacon];
            }
        }
        
        if([proximityBeacons count] > 0)
        {
            
            self.beacons[range] = [proximityBeacons objectAtIndex:0];
            self.foundBeacon = [proximityBeacons objectAtIndex:0];
            
            NSString *uuidStringBeaconFound = [[self.foundBeacon proximityUUID] UUIDString];
            NSString *majorBeaconFound = [NSString stringWithFormat:@"%ld",(long)[[self.foundBeacon major] integerValue]];
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
                self.beaconProcossed = self.foundBeacon;
                self.userLocation.hidden = NO;
                [self provideContextualInformationfor:self.foundBeacon];
                
            }
            
            
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
 
    
    
    switch([nearBeacon.major integerValue])
    {
        case Major_Roximity :
            self.userLocation.frame = Location_Sam_Room_White;
            [self updatingTrafficInformationForObject:Roximity_ObjectID];
            break;
            
        case Major_LightBlue:
            self.userLocation.frame = Location_Rohit_Room_LightBlue;
            [self updatingTrafficInformationForObject:LightBlue_ObjectID];
            break;
            
        case Major_Green:
            self.userLocation.frame = Location_Kitchen_Room_Green;
            [self updatingTrafficInformationForObject:Green_ObjectID];
            break;
        case Major_Blue:
            self.userLocation.frame = Location_Hall_Room_Blue;
            [self updatingTrafficInformationForObject:DarkBlue_ObjectID];
            break;
        case Major_Macbook:
            //self.userLocation.frame = Location_Hall_Room_Blue;
            [self updatingTrafficInformationForObject:Macbook_ObjectID];
            break;
        default:
            
            break;
    }
    
    
}


- (void) updatingTrafficInformationForObject:(NSString *) objectID
{
    PFQuery *query = [PFQuery queryWithClassName:@"HotSpots"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objectID block:^(PFObject *monitorTraffic, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        [monitorTraffic incrementKey:@"Traffic"];
        [monitorTraffic saveInBackground];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
