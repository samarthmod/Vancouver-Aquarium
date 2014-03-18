

#import "APLRangingViewController.h"
#import "APLDefaults.h"
#import "LoginViewController.h"
#import "ALBeaconCellTableViewCell.h"
#import "DetailViewController.h"
@import CoreLocation;

#define Major_LightBlue_R1          40058    //Region 1
#define Major_Green_R2         13401         //Region 2
#define Major_Blue_R3      10177             //Region 3
#define Major_Roximity_R4      1             //Region 4
#define Major_Macbook_R5       0             //Region 5

@interface APLRangingViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;
@property NSMutableDictionary *cellInformationDict;
@property NSMutableArray* arrayForPlaces;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL rangingShouldStopOnTransition;



@end


@implementation APLRangingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rangingShouldStopOnTransition = YES;
    self.cellInformationDict = [[NSMutableDictionary alloc] init];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"SampleData" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.arrayForPlaces = [plistDict objectForKey:@"Data"];
    
    self.beacons = [[NSMutableArray alloc] init];
    LoginViewController *loginScreen = [[LoginViewController alloc] init];
    [self presentViewController:loginScreen animated:NO completion:NULL];
    // This location manager will be used to demonstrate how to range beacons.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    // Populate the regions we will range once.
    self.rangedRegions = [[NSMutableDictionary alloc] init];
    

    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    if (![[APLDefaults sharedDefaults] logInActionDone])
    {
        LoginViewController *loginScreen = [[LoginViewController alloc] init];
        [self presentViewController:loginScreen animated:NO completion:NULL];
    }
    
    if (self.rangingShouldStopOnTransition)
    {
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
    }
    else
    {
        self.rangingShouldStopOnTransition = YES;
    }
        self.navigationController.navigationBar.topItem.title = @"Welcome";
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    // Stop ranging when the view goes away.
    if (self.rangingShouldStopOnTransition)
    {
        for (CLBeaconRegion *region in self.rangedRegions)
        {
            [self.locationManager stopRangingBeaconsInRegion:region];
        }
    }
    
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
    
    
    
    if ([allBeacons count] >0)
    {
        [allBeacons sortUsingDescriptors:
         [NSArray arrayWithObjects:
          [NSSortDescriptor sortDescriptorWithKey:@"major" ascending:NO],nil]];
        //NSLog(@"Beacons: %@",allBeacons);
        self.beacons = allBeacons;
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSArray *sectionValues = [self.beacons allValues];
    //return [sectionValues[section] count];
    
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
// Default is 1 if not implemented
{
    return self.beacons.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    switch(section)
    {
        case 0:
            title = NSLocalizedString(@"Region 1 - Star Fish", @"Immediate section header title");
            break;
            
        case 1:
            title = NSLocalizedString(@"Region 2 - Dolphins", @"Near section header title");
            break;
            
        case 2:
            title = NSLocalizedString(@"Region 3 - Whales", @"Far section header title");
            break;
        case 3:
            title = NSLocalizedString(@"Region 4 - Beluga", @"Far section header title");
            break;
        case 4:
            title = NSLocalizedString(@"Region 5 - Seal", @"Far section header title");
            break;
        default:
            title = NSLocalizedString(@"Unknown", @"Unknown section header title");
            break;
    }
    
    return title;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 110;
    }
    return 40;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"Cell";
	ALBeaconCellTableViewCell *cell = (ALBeaconCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Display the UUID, major, minor and accuracy for each beacon.
    
    CLBeacon *beacon = [self.beacons objectAtIndex:indexPath.section];
    NSDictionary *infoDict = [self.arrayForPlaces objectAtIndex:indexPath.section];
    NSString *beaconColor;
    
    
    cell.imageBeacon.image = [UIImage imageNamed:[infoDict valueForKey:@"Image"]];
    cell.backImageView.image = [UIImage imageNamed:[infoDict valueForKey:@"backImage"]];
    NSString *name = [NSString stringWithFormat:@"%@",[infoDict valueForKey:@"Place"]];
    NSString *colorBeacon = [NSString stringWithFormat:@" with color: %@",[infoDict valueForKey:@"Color"]];
    beaconColor = [name stringByAppendingString:colorBeacon];
    cell.lblBeaconInfo.text = [NSString stringWithFormat:@"Beacon %@",beaconColor];
    
    NSString *formatString = NSLocalizedString(@"You are %.2fm far away from this region", @"Format string for ranging table cells.");
    if (beacon.accuracy == -1)
    {
        cell.lblDistance.text = [NSString stringWithFormat:@"You are pretty far away from this region"];
    }
    else
    {
        cell.lblDistance.text = [NSString stringWithFormat:formatString, beacon.accuracy];
    }
    
    //cell.imageBeacon.image = [UIImage imageNamed:@"artnew.jpg"];
	cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect cellFrameInSuperview = [tableView convertRect:cellFrameInTableView toView:[tableView superview]];
    
    
    DetailViewController *controller = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"detailController"];
    
    
    NSMutableDictionary* dict = [self.arrayForPlaces objectAtIndex:indexPath.section];
    controller.dictForData = dict;
    controller.yOrigin = cellFrameInSuperview.origin.y;
    
    self.rangingShouldStopOnTransition = NO;
    [self.navigationController pushViewController:controller animated:NO];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
