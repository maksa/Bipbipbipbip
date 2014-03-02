//
//  BeaconCell.h
//  Bipbipbipbip
//
//  Created by maksa on 3/1/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *majorminorLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
