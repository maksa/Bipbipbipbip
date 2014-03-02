//
//  BeaconsModel.h
//  Bipbipbipbip
//
//  Created by maksa on 3/1/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESTBeacon.h"
#import <AudioToolbox/AudioToolbox.h>

@interface BeaconsModel : NSObject {
	SystemSoundID _pewPewSound;
}
@property NSMutableArray* knownBeacons;
@property NSMutableArray* soundTimers;
-(void)updateWithBeacon:(ESTBeacon*)beaconUpdate;
@end
