//
//  BeaconsModel.m
//  Bipbipbipbip
//
//  Created by maksa on 3/1/14.
//  Copyright (c) 2014 MM. All rights reserved.
//

#import "BeaconsModel.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation BeaconsModel
-(id)init {
	self = [ super init ];
	if( self ) {
		self.knownBeacons = [[ NSMutableArray alloc ] init];
		self.soundTimers = [[ NSMutableArray alloc ] init];
	}
	
	return self;
}
-(void)updateWithBeacon:(ESTBeacon*)beaconUpdate {
	NSInteger index = [ self.knownBeacons indexOfObjectPassingTest:^BOOL(ESTBeacon* bcn, NSUInteger idx, BOOL *stop) {
		return ( bcn.minor == beaconUpdate.minor && bcn.major == beaconUpdate.major );
	}];
	
	if( index == NSNotFound ) {
		[self.knownBeacons addObject:beaconUpdate];
		NSTimer* timer = [ NSTimer scheduledTimerWithTimeInterval:[beaconUpdate.distance doubleValue] target:self selector:@selector(playSound:) userInfo:beaconUpdate repeats:NO ];
	} else {
		self.knownBeacons[index] = beaconUpdate;
	}
}

-(void)playSound:(NSTimer*)timer {
	
	ESTBeacon* beacon = timer.userInfo;
	
	NSInteger beaconIndex = [ self.knownBeacons indexOfObjectPassingTest:^BOOL(ESTBeacon* obj, NSUInteger idx, BOOL *stop) {
		return ( obj.minor == beacon.minor && obj.major == beacon.major );
	} ];
	
	NSAssert( beaconIndex != NSNotFound, @"beacon must be known" );
	
	// I currently have only three beacons, so 3 distinct sounds are enough.
	static char* soundnames[] = { "blip", "blip1", "blip2" };
	
	NSInteger soundcount = sizeof(soundnames)/sizeof(char**);
	
	NSString* soundName = @( soundnames[beaconIndex % soundcount] );
	
	NSString *pewPewPath = [[NSBundle mainBundle]
							pathForResource:soundName ofType:@"aiff"];
	NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(pewPewURL), &soundID);
	AudioServicesPlaySystemSound( soundID );

	if( beacon.distance.doubleValue > 0 ) {
		NSTimer* newTimer = [ NSTimer scheduledTimerWithTimeInterval:[beacon.distance doubleValue] target:self selector:@selector(playSound:) userInfo:beacon repeats:NO];
	}
	
}
@end
