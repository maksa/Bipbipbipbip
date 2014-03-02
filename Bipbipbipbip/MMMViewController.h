//
//  MMMViewController.h
//  Bipbipbipbip
//
//  Created by maksa on 2/28/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeaconManager.h"
#import "BeaconsModel.h"

@interface MMMViewController : UIViewController <ESTBeaconManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property ESTBeaconManager* beaconManager;
@property (strong, nonatomic) BeaconsModel* beaconModel;
@property (weak, nonatomic) IBOutlet UITableView *beaconsTable;
@property (nonatomic) NSArray* proxyStrings;
@property (weak, nonatomic) IBOutlet UILabel *beaconCountLabel;
@end
