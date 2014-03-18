//
//  ALBeaconCellTableViewCell.h
//  AirLocate
//
//  Created by Rohit Boolchandani on 3/14/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALBeaconCellTableViewCell : UITableViewCell

@property (weak, nonatomic,readonly) IBOutlet UIImageView *imageBeacon;

@property (weak, nonatomic,readonly) IBOutlet UILabel *lblBeaconInfo;
@property (weak, nonatomic,readonly) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic, readonly) IBOutlet UIImageView *backImageView;
@end
