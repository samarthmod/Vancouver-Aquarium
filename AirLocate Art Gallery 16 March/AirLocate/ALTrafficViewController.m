//
//  ALTrafficViewController.m
//  AirLocate
//
//  Created by Rohit Boolchandani on 3/15/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "ALTrafficViewController.h"
#import "JBBarChartView.h"

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

#define Graph_Factor    50

@interface ALTrafficViewController () <JBBarChartViewDataSource,JBBarChartViewDelegate>

@property float roximityTraffic;
@property float lightBlueTraffic;
@property float darkBlueTraffic;
@property float macbookTraffic;
@property float greenTraffic;
@property float totalTraffic;
@property NSMutableArray *percentageTraffic;

@property JBBarChartView *barChartView;
@property (strong, nonatomic) IBOutlet UIView *graphBaseView;

@end

@implementation ALTrafficViewController

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
    self.barChartView = [[JBBarChartView alloc] init];
    self.barChartView.frame = CGRectMake(100, 100, 500, 800);
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    
//    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 10)];
//    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
//    footerLabel.text = @"iBeacons Traffic - Touch the bar to know details";
//    [tempView addSubview:footerLabel];
//    self.barChartView.footerView = tempView;
    [self.view addSubview:self.barChartView];
    self.navigationController.navigationBar.topItem.title = @"Real Time Analytics";
    //[self.barChartView reloadData];

    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self backgroundOperations];
    
    
}

- (void) backgroundOperations
{
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
        [self.barChartView reloadData];
    }];
    
}


- (NSInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return 5; // number of bars in chart
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSInteger)index
{
    CGFloat height = 0;
    
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
        if(height == 0)
        {
            height = 3;
        }
        NSLog(@"heght %f",height);
        
    }
    else
    {
        height = 2;
    }
    return height;
}

- (UIColor *)selectionBarColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor lightTextColor]; // color of selection view
}

- (UIView *)barViewForBarChartView:(JBBarChartView *)barChartView atIndex:(NSInteger)index
{
    UIView *tempView = [[UIView alloc] init];
    
    UILabel *beaconLabel = [[UILabel alloc] init];
    [beaconLabel setFrame:CGRectMake(10, 0, 150, 25)];
    
    UILabel *beaconPercent = [[UILabel alloc] init];
    [beaconPercent setFrame:CGRectMake(10, 30, 150, 25)];
    
    
    switch(index)
    {
        case 0 :
            [beaconLabel setText:@"Roximity"];
            [beaconPercent setText:[NSString stringWithFormat:@"Hits: %.1f",self.roximityTraffic]];
            tempView.backgroundColor = [UIColor lightGrayColor];
            break;
        case 1 :
            [beaconLabel setText:@"Dark Blue"];
            [beaconPercent setText:[NSString stringWithFormat:@"Hits: %.1f",self.darkBlueTraffic]];
            tempView.backgroundColor = [UIColor blueColor];
            break;
        case 2 :
            [beaconLabel setText:@"Light Blue"];
            [beaconPercent setText:[NSString stringWithFormat:@"Hits: %.1f",self.lightBlueTraffic]];
            tempView.backgroundColor = [UIColor colorWithRed:0 green:100 blue:100 alpha:1];
            break;
        case 3 :
            [beaconLabel setText:@"Green"];
            [beaconPercent setText:[NSString stringWithFormat:@"Hits: %.1f",self.greenTraffic]];
            tempView.backgroundColor = [UIColor greenColor];
            break;
        case 4 :
            [beaconLabel setText:@"Macbook"];
            [beaconPercent setText:[NSString stringWithFormat:@"Hits: %.1f",self.macbookTraffic]];
            tempView.backgroundColor = [UIColor brownColor];
            break;
        default:
            
            break;
    }
    
    
    [tempView addSubview:beaconLabel];
    [tempView addSubview:beaconPercent];
    NSLog(@"temp View: %@",tempView);
    
    return tempView;
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
