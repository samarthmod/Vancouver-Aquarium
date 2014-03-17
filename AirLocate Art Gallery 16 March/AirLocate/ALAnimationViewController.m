//
//  ALAnimationViewController.m
//  AirLocate
//
//  Created by Rohit Boolchandani on 3/15/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "ALAnimationViewController.h"


@interface ALAnimationViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webViewAnimation;

@end

@implementation ALAnimationViewController

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
    
    
    
    NSURL * dancerGIFURL = [[NSBundle mainBundle] URLForResource:@"Video_magic.gif" withExtension:nil];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:dancerGIFURL];
    self.webViewAnimation.delegate = self;
    self.webViewAnimation.userInteractionEnabled = NO;
    [self.webViewAnimation loadRequest:urlRequest];

    // Do any additional setup after loading the view.
    //[self targetMethod:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    //UITabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"rootControl"];
    //[self presentViewController:controller animated:NO completion:NULL];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
    [NSTimer scheduledTimerWithTimeInterval:15.0
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) targetMethod:(id)userInfo
{
    UITabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"rootControl"];
//    NSArray *tabs =  controller.viewControllers;
//    UIViewController *tab1 = [tabs objectAtIndex:0];
//    tab1.tabBarItem.image = [UIImage imageNamed:@"Home.png"];
//    UIViewController *tab2 = [tabs objectAtIndex:1];
//    tab2.tabBarItem.image = [UIImage imageNamed:@"nearest.png"];
    [self presentViewController:controller animated:NO completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
