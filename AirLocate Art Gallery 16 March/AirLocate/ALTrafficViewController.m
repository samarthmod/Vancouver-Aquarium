//
//  ALTrafficViewController.m
//  AirLocate
//
//  Created by Rohit Boolchandani on 3/15/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "ALTrafficViewController.h"
#import "JBBarChartView.h"
#import "XYPieChart.h"

#define Roximity_ObjectID   @"dM4zN00da8"
#define DarkBlue_ObjectID   @"QUEfntgJB5"
#define LightBlue_ObjectID  @"6jnRn2UEOZ"
#define Green_ObjectID      @"s4LlSBF0tZ"
#define Macbook_ObjectID    @"JTZTRbMicD"

#define Major_LightBlue          40058
#define Major_Green         13401
#define Major_Blue      10177
#define Major_Roximity      1
#define Major_Macbook       0

#define Graph_Factor    100

@interface ALTrafficViewController () <XYPieChartDelegate, XYPieChartDataSource>

@property float roximityTraffic;
@property float lightBlueTraffic;
@property float darkBlueTraffic;
@property float macbookTraffic;
@property float greenTraffic;
@property float totalTraffic;
@property NSMutableArray *percentageTraffic;

@property JBBarChartView *barChartView;
@property (strong, nonatomic) IBOutlet UIView *graphBaseView;
@property (strong, nonatomic) IBOutlet XYPieChart *pieChartRight;
@property (strong, nonatomic) IBOutlet XYPieChart *pieChartLeft;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) IBOutlet UITextField *numOfSlices;
@property (strong, nonatomic) IBOutlet UISegmentedControl *indexOfSlices;
@property (strong, nonatomic) IBOutlet UIButton *downArrow;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;


- (IBAction)showSlicePercentage:(id)sender;

@end

@implementation ALTrafficViewController

@synthesize pieChartRight = _pieChart;
@synthesize pieChartLeft = _pieChartCopy;
@synthesize percentageLabel = _percentageLabel;
@synthesize selectedSliceLabel = _selectedSlice;
@synthesize numOfSlices = _numOfSlices;
@synthesize indexOfSlices = _indexOfSlices;
@synthesize downArrow = _downArrow;
@synthesize slices = _slices;
@synthesize sliceColors = _sliceColors;

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
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
    [self.percentageLabel setHidden:YES];
    
    [self.pieChartLeft setDataSource:self];
    [self.pieChartLeft setStartPieAngle:M_PI_2];
    [self.pieChartLeft setAnimationSpeed:1.0];
    [self.pieChartLeft setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.pieChartLeft setLabelRadius:100];
    [self.pieChartLeft setShowPercentage:YES];
    [self.pieChartLeft setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChartLeft setPieCenter:CGPointMake(240, 240)];
    [self.pieChartLeft setUserInteractionEnabled:NO];
    [self.pieChartLeft setLabelShadowColor:[UIColor blackColor]];
    
    [self.pieChartRight setDelegate:self];
    [self.pieChartRight setDataSource:self];
    [self.pieChartRight setPieCenter:CGPointMake(240, 240)];
    [self.pieChartRight setShowPercentage:NO];
    [self.pieChartRight setLabelColor:[UIColor blackColor]];
    [self.pieChartRight setLabelFont:[UIFont systemFontOfSize:13]];
    [self.pieChartRight setLabelRadius:110];
    
    [self.percentageLabel.layer setCornerRadius:50];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:200/255.0 green:200/255.0 blue:180/255.0 alpha:1],
                       [UIColor colorWithRed:19/255.0 green:100/255.0 blue:255/255.0 alpha:1],
                       [UIColor colorWithRed:22/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:10/255.0 green:226/255.0 blue:100/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    //rotate up arrow
    self.downArrow.transform = CGAffineTransformMakeRotation(M_PI);

    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self backgroundOperations];
    
    
    self.navigationController.navigationBar.topItem.title = @"Real Time Analytics";
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.percentageLabel setHidden:YES];
    [_slices removeAllObjects];
}

- (void) backgroundOperations
{
    
    

    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    if (netStatus == NotReachable)
    {
        for(int i = 0; i < 5; i ++)
        {
            NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
            [_slices addObject:one];
        }
        
    }
    else
    {
        [_slices removeAllObjects];
        self.totalTraffic = 0;
        PFQuery *query = [PFQuery queryWithClassName:@"HotSpots"];
        [query selectKeys:@[@"Major", @"Traffic"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error)
         {
             for (int i = 0; i<[results count]; i++)
             {
                 PFObject *tempObj = [results objectAtIndex:i];
                 int major = [[tempObj objectForKey:@"Major"] intValue];
                 switch(major)
                 {
                     case Major_Roximity :
                         self.roximityTraffic = [[tempObj objectForKey:@"Traffic"] floatValue];
                         self.totalTraffic = self.totalTraffic + self.roximityTraffic;
                         break;
                         
                     case Major_LightBlue:
                         self.lightBlueTraffic = [[tempObj objectForKey:@"Traffic"] floatValue];
                         self.totalTraffic = self.totalTraffic + self.lightBlueTraffic;
                         break;
                         
                     case Major_Green:
                         self.greenTraffic = [[tempObj objectForKey:@"Traffic"] floatValue];
                         self.totalTraffic = self.totalTraffic + self.greenTraffic;
                         break;
                     case Major_Blue:
                         self.darkBlueTraffic = [[tempObj objectForKey:@"Traffic"] floatValue];
                         self.totalTraffic = self.totalTraffic + self.darkBlueTraffic;
                         break;
                     case Major_Macbook:
                         self.macbookTraffic = [[tempObj objectForKey:@"Traffic"] floatValue];
                         self.totalTraffic = self.totalTraffic + self.macbookTraffic;
                         break;
                     default:
                         
                         break;
                 }
                 
             }
             [self.pieChartLeft reloadData];
             [self.pieChartRight reloadData];
             [self.percentageLabel setHidden:NO];
             
         }];
    }
    
    
    
}

- (IBAction)showSlicePercentage:(id)sender
{
    UISwitch *perSwitch = (UISwitch *)sender;
    [self.pieChartRight setShowPercentage:!perSwitch.isOn];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 5;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    CGFloat height = 0.1f;
    
    if (self.totalTraffic != 0)
    {
        switch(index)
        {
            case 0 :
                
                height =  (self.roximityTraffic/self.totalTraffic)*Graph_Factor ;
                
                break;
            case 1 :
                
                height =  (self.darkBlueTraffic/self.totalTraffic)*Graph_Factor;
                break;
            case 2 :
                
                height =  (self.lightBlueTraffic/self.totalTraffic)*Graph_Factor;
                break;
            case 3 :
                
                height =  (self.greenTraffic/self.totalTraffic)*Graph_Factor;
                break;
            case 4 :
                
                height =  (self.macbookTraffic/self.totalTraffic)*Graph_Factor;
                break;
            default:
                height = 5;
                
                break;
        }
        
        NSLog(@"heght %f",height);
        
    }
    else
    {
        height = 2;
    }
    int h = (int) height;
    NSNumber *one = [NSNumber numberWithInt:h];
    [_slices addObject:one];
    return height;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    if(pieChart == self.pieChartRight) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    NSString *hitsCount;
    if (pieChart == self.pieChartRight)
    {
        if (index == 0)
        {
            hitsCount = [NSString stringWithFormat:@"Roximity - %.0f visits",self.roximityTraffic];
            
        }
        else if (index == 1)
        {
            hitsCount = [NSString stringWithFormat:@"Dark Blue - %.0f visits",self.darkBlueTraffic];
        }
        else if (index == 2)
        {
            hitsCount = [NSString stringWithFormat:@"Light Blue - %.0f visits",self.lightBlueTraffic];
        }
        else if (index == 3)
        {
            hitsCount = [NSString stringWithFormat:@"Green - %.0f visits",self.greenTraffic];
        }
        else if (index == 4)
        {
            hitsCount = [NSString stringWithFormat:@"MacBook - %.0f visits",self.macbookTraffic];
        }
        else
        {
            hitsCount = [NSString stringWithFormat:@"Roximity - %.0f visits",self.roximityTraffic];
        }
    }
    
    
    return hitsCount;
}

#pragma mark - XYPieChart Delegate

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    self.selectedSliceLabel.text = [NSString stringWithFormat:@"Hits Percentage is %@",[self.slices objectAtIndex:index]];
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
