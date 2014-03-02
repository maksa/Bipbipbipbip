//
//  MMMViewController.m
//  Bipbipbipbip
//
//  Created by maksa on 2/28/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "MMMViewController.h"
#import "ESTBeaconRegion.h"
#import "ESTBeacon.h"
#import "BeaconCell.h"

#define RGBCOLOR(r, g, b, a ) [ UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a ]

@interface MMMViewController ()

@end

@implementation MMMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.beaconModel = [[ BeaconsModel alloc ] init];
	
	self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;

    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                                  identifier:@"EstimoteSampleRegion"];
		
	self.proxyStrings = @[@"unknown", @"Immediate", @"Near", @"Far" ];
    
	[ self.beaconManager startRangingBeaconsInRegion:region ];
	
}

-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
	
	NSNumberFormatter* f = [[ NSNumberFormatter alloc ] init];
	f.maximumFractionDigits = 4;
	f.minimumFractionDigits = 2;

	self.beaconCountLabel.text = [NSString stringWithFormat:@"%lu",  (unsigned long)self.beaconModel.knownBeacons.count ];

	
    if([beacons count] > 0)
    {
		[beacons enumerateObjectsUsingBlock:^(ESTBeacon* beacon, NSUInteger idx, BOOL *stop) {
			CLProximity proximity = beacon.proximity;
			NSLog(@"%@: %@ - %@.%@",self.proxyStrings[proximity], [ f stringFromNumber:beacon.distance], beacon.major, beacon.minor);
			[self.beaconModel updateWithBeacon:beacon];
		}];
		[self.beaconsTable reloadData ];
	}
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)formatDistance:(NSNumber*)distance {
	NSNumberFormatter* fmt = [[ NSNumberFormatter alloc ] init];
	fmt.minimumIntegerDigits = 1;
	fmt.minimumFractionDigits = 4;

	double d = [distance doubleValue];
	if( d < 0.0 ) {
		return @"";
	}
	
	if( d < 1.0 ) {
		fmt.maximumFractionDigits = 2;
		return [ NSString stringWithFormat:@"%@  cm", [ fmt stringFromNumber:@(distance.doubleValue * 100)] ];
	}
	
	fmt.maximumFractionDigits = 2;
	return [ NSString stringWithFormat:@"%@  m", [ fmt stringFromNumber:distance]];
		
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	NSArray* colors = @[ [ UIColor grayColor ], //	 CLProximityUnknown
						 [ UIColor greenColor ], //  CLProximityImmediate
						 [ UIColor blueColor ], // 	 CLProximityNear
						 [ UIColor redColor ]]; // 	 CLProximityFar
	
	BeaconCell* cell = [ tableView dequeueReusableCellWithIdentifier:@"beaconcell" ];
	ESTBeacon* beacon = self.beaconModel.knownBeacons[indexPath.row];
	cell.majorminorLabel.text = [ NSString stringWithFormat:@"%@.%@", beacon.major, beacon.minor ];
	
	cell.distanceLabel.text = [ self formatDistance:beacon.distance ];
	
	cell.statusLabel.text =	self.proxyStrings[beacon.proximity];

	cell.statusLabel.textColor = colors[beacon.proximity];
	cell.statusLabel.textColor = [cell.statusLabel.textColor colorWithAlphaComponent:1/[beacon.distance doubleValue]];
	
	return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.beaconModel.knownBeacons.count;
}

@end
