//
//  LoginViewController.h
//  AirLocate
//
//  Created by Rohit Boolchandani on 3/11/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "APLRangingViewController.h"

@interface LoginViewController : UIViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end
