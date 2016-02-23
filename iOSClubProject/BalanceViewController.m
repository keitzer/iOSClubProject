//
//  BalanceViewController.m
//  iOSClubProject
//
//  Created by Alex Ogorek on 2/22/16.
//  Copyright © 2016 iosclub. All rights reserved.
//

#import "BalanceViewController.h"
#import <CoreMotion/CoreMotion.h>


@interface BalanceViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *leftArrowImageView;
@property (nonatomic, weak) IBOutlet UIImageView *rightArrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *handImageView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) NSTimer *longTimer;
@property (nonatomic, strong) NSTimer *shortTimer;
@property (nonatomic, assign) CGFloat currentTime;
@property (nonatomic, assign) BOOL isTimerRunning;
@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.motionManager = [[CMMotionManager alloc] init];
	self.motionManager.accelerometerUpdateInterval = 0.05;
	
	[self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
		
		self.rightArrowImageView.hidden = YES;
		self.leftArrowImageView.hidden = YES;
		self.handImageView.hidden = YES;
		self.timerLabel.hidden = YES;
		
		if (accelerometerData.acceleration.x < -0.05) {
			self.rightArrowImageView.hidden = NO;
			[self stopTimer];
		}
		else if (accelerometerData.acceleration.x > 0.05) {
			self.leftArrowImageView.hidden = NO;
			[self stopTimer];
		}
		else {
			self.handImageView.hidden = NO;
			self.timerLabel.hidden = NO;
			
			if (!self.isTimerRunning) {
				[self startTimer];
			}
		}

	}];
	
}

-(void)startTimer {
	self.isTimerRunning = YES;
	
	self.currentTime = 10;
	
	self.longTimer = [NSTimer scheduledTimerWithTimeInterval:10
													  target:self
												selector:@selector(longTimerExecuted)
													userInfo:nil
													 repeats:NO];
	
	self.shortTimer = [NSTimer scheduledTimerWithTimeInterval:.01
													   target:self
												selector:@selector(shortTimerExecuted)
													 userInfo:nil
													  repeats:YES];
}

-(void)stopTimer {
	self.isTimerRunning = NO;
	[self.longTimer invalidate];
	self.longTimer = nil;
	
	[self.shortTimer invalidate];
	self.shortTimer = nil;
}

-(void)shortTimerExecuted {
	self.currentTime -= .01;
	
	if (self.currentTime < 0) {
		self.currentTime = 0;
	}
	
	self.timerLabel.text = [NSString stringWithFormat:@"%.02f", self.currentTime];
}

-(void)longTimerExecuted {
	self.view.backgroundColor = [UIColor greenColor];
	[self.motionManager stopAccelerometerUpdates];
	
	self.timerLabel.text = @"CONGRATZ!";
	
	self.leftArrowImageView.hidden = YES;
	self.rightArrowImageView.hidden = YES;
	self.handImageView.hidden = YES;
	
	[self stopTimer];
}














/*
 self.motionManager.accelerometerUpdateInterval = .2;
 [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
 }];
 
 self.accX.text = [NSString stringWithFormat:@" %.2fg",acceleration.x];
 */


@end
