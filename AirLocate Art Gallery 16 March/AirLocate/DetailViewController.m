//
//  DetailViewController.m
//  AnimationMaximize
//
//  Created by mayur on 7/31/13.
//  Copyright (c) 2013 mayur. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (retain, nonatomic) IBOutlet UILabel *labelForPlace;
@property (retain, nonatomic) IBOutlet UILabel *labelForCountry;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIButton *doneBtn;
@property (retain, nonatomic) IBOutlet UITextView *textviewForDetail;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;



- (IBAction)doneBtnPressed:(id)sender;

@end

@implementation DetailViewController




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
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(home:)];
    self.navigationItem.leftBarButtonItem=newBackButton;
    self.labelForPlace.text = [NSString stringWithFormat:@"%@",[self.dictForData objectForKey:@"Place"]];
    self.labelForCountry.text = [NSString stringWithFormat:@"%@",[self.dictForData objectForKey:@"Country"]];
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.dictForData objectForKey:@"Image"]]];

    [self animateOnEntry];
    self.navigationController.navigationBar.topItem.title = @"Information";
}

- (void) animateOnEntry
{
    //set initial frames
    self.backgroundImageView.alpha = 0;
    self.backgroundImageView.frame = CGRectMake(0, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.view.frame.size.width, self.labelForPlace.frame.size.height + self.labelForCountry.frame.size.height);
    self.labelForPlace.frame = CGRectMake(70, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.labelForPlace.frame.size.width, self.labelForPlace.frame.size.height);
    self.labelForCountry.frame = CGRectMake(70, self.labelForPlace.frame.origin.y + self.labelForPlace.frame.size.height, self.labelForCountry.frame.size.width, self.labelForCountry.frame.size.height);
    
    self.boardImageView.frame = CGRectMake(70, self.labelForPlace.frame.origin.y + self.labelForPlace.frame.size.height, self.labelForCountry.frame.size.width, self.labelForCountry.frame.size.height);
    self.imageView.frame = CGRectMake(10, self.yOrigin + IMAGEVIEW_Y_ORIGIN, 50, 50);
    self.doneBtn.frame = CGRectMake(self.doneBtn.frame.origin.x, 0-self.doneBtn.frame.size.height-20, self.doneBtn.frame.size.width, self.doneBtn.frame.size.height);
    self.textviewForDetail.alpha = 0;
    self.textviewForDetail.frame = CGRectMake(self.textviewForDetail.frame.origin.x, self.textviewForDetail.frame.size.height + self.view.frame.size.height, self.textviewForDetail.frame.size.width, self.textviewForDetail.frame.size.height);
    
    //apply animation on ENTERING INTO THE VIEW
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void)
     {
         self.labelForPlace.frame = CGRectMake(35, 180, self.labelForPlace.frame.size.width, self.labelForPlace.frame.size.height);
         self.labelForCountry.frame = CGRectMake(35, 250, self.labelForCountry.frame.size.width, self.labelForCountry.frame.size.height);
         self.boardImageView.frame = CGRectMake(35, 250, self.labelForCountry.frame.size.width, self.labelForCountry.frame.size.height);
         self.doneBtn.frame = CGRectMake(self.doneBtn.frame.origin.x, 20, self.doneBtn.frame.size.width, self.doneBtn.frame.size.height);
         self.backgroundImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
         self.backgroundImageView.alpha = 1;
         
         self.textviewForDetail.frame = CGRectMake(self.textviewForDetail.frame.origin.x, self.view.frame.size.height - self.textviewForDetail.frame.size.height, self.textviewForDetail.frame.size.width, self.textviewForDetail.frame.size.height);
         self.textviewForDetail.alpha = 1;
         
         NSLog(@"width %f height %f",self.imageView.frame.size.width,self.imageView.frame.size.height);
         
         self.imageView.frame = CGRectMake(110, 50, self.imageView.frame.size.width * 2, self.imageView.frame.size.height * 2);
     }
                     completion:NULL];
    //self.textviewForDetail.contentInset = UIEdgeInsetsMake(0.0, 0.0, 100.0, 0.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBtnPressed:(id)sender
{
    //animation on EXIT FROM CURRENT VIEW
    
}

-(void)home:(UIBarButtonItem *)sender
{
    [UIView animateWithDuration:0.4f animations:^
     {
         self.backgroundImageView.frame = CGRectMake(0, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.view.frame.size.width, self.labelForPlace.frame.size.height + self.labelForCountry.frame.size.height);
         self.labelForPlace.frame = CGRectMake(70, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.labelForPlace.frame.size.width, self.labelForPlace.frame.size.height);
         self.labelForCountry.frame = CGRectMake(70, self.labelForPlace.frame.origin.y + self.labelForPlace.frame.size.height, self.labelForCountry.frame.size.width, self.labelForCountry.frame.size.height);
         self.boardImageView.frame = CGRectMake(70, self.labelForPlace.frame.origin.y + self.labelForPlace.frame.size.height, self.labelForCountry.frame.size.width, 0);
         
         self.imageView.frame = CGRectMake(10, self.yOrigin + IMAGEVIEW_Y_ORIGIN, CGRectGetWidth(self.imageView.frame) / 2, CGRectGetHeight(self.imageView.frame) / 2);
         self.doneBtn.frame = CGRectMake(self.doneBtn.frame.origin.x, 0-self.doneBtn.frame.size.height-20, self.doneBtn.frame.size.width, self.doneBtn.frame.size.height);
         self.textviewForDetail.frame = CGRectMake(self.textviewForDetail.frame.origin.x, self.textviewForDetail.frame.size.height + self.view.frame.size.height, self.textviewForDetail.frame.size.width, self.textviewForDetail.frame.size.height);
         self.textviewForDetail.alpha = 0;
         self.backgroundImageView.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         [self.navigationController popViewControllerAnimated:NO];
     }
     ];
}

-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        
    }
    [super viewWillDisappear:animated];
}

@end
