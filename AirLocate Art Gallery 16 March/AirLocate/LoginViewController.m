//
//  LoginViewController.m
//  AirLocate
//
//  Created by Rohit Boolchandani on 3/11/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "LoginViewController.h"
#import "APLDefaults.h"
#import "MyLogInViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    MyLogInViewController *logInController = [[MyLogInViewController alloc] init];
    logInController.delegate = self;
    logInController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsFacebook | PFLogInFieldsDismissButton | PFLogInFieldsSignUpButton | PFLogInFieldsTwitter | PFLogInFieldsSignUpButton;
    logInController.logInView.frame = self.view.frame;
    
    //[self presentViewController:logInController animated:YES completion:NULL];
    [self.view addSubview:logInController.view];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    [[APLDefaults sharedDefaults] setLogInActionDone:YES];
    [[APLDefaults sharedDefaults] callbackWithResult:nil error:nil];
    if (netStatus == NotReachable)
    {
        
        [[APLDefaults sharedDefaults] callbackWithResult:nil error:nil];
    }
    else
    {
        PFQuery *query = [PFQuery queryWithClassName:@"ArtBeacon"];
        [query findObjectsInBackgroundWithTarget:[APLDefaults sharedDefaults] selector:@selector(callbackWithResult:error:)];
    }
    
    self.navigationController.navigationBar.topItem.title = @"Authenticate";
    
}


- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    
    
    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:[error description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [failureAlert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:@"Congrats" message:@"You are logged in now. Have a great time" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [failureAlert show];
    
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}





- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
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
