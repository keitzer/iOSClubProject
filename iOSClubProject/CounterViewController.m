//
//  CounterViewController.m
//  iOSClubProject
//
//  Created by Alex Ogorek on 2/17/16.
//  Copyright © 2016 iosclub. All rights reserved.
//

#import "CounterViewController.h"

@interface CounterViewController ()

@property (nonatomic, weak) IBOutlet UILabel *timerLabel;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *startButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger currentTimeRemaining;
@property (nonatomic, assign) NSInteger defaultTime;

@property (nonatomic, assign) BOOL isTimerRunning;

@end

@implementation CounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.defaultTime = 30 * 60; //30 mins * 60 secs in a minute
	self.currentTimeRemaining = self.defaultTime;
	self.isTimerRunning = NO;
	[self updateLabelWithTime];
}

-(IBAction)startPressed {
	if (self.isTimerRunning) {
		[self pauseTimer];
		[self.startButton setTitle:@"Start" forState:UIControlStateNormal];
	}
	else {
		[self startTimer];
		[self.startButton setTitle:@"Pause" forState:UIControlStateNormal];
	}
	
	self.isTimerRunning = !self.isTimerRunning;
}

-(IBAction)cancelPressed {
	self.isTimerRunning = NO;
	[self cancelTimer];
	[self.startButton setTitle:@"Start" forState:UIControlStateNormal];
}


-(void)timerExecuted {
	self.currentTimeRemaining--;
	if (self.currentTimeRemaining < 0) {
		[self pauseTimer];
		self.currentTimeRemaining = 0;
	}
	
	[self updateLabelWithTime];
}

-(void)startTimer {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1
												  target:self
												selector:@selector(timerExecuted)
												userInfo:nil
												 repeats:YES];
}

-(void)pauseTimer {
	[self.timer invalidate];
	self.timer = nil;
}

-(void)cancelTimer {
	[self pauseTimer];
	self.currentTimeRemaining = self.defaultTime;
	[self updateLabelWithTime];
}

-(void)updateLabelWithTime {
	NSInteger secondsRemaining;
	NSInteger minutesRemaining;
	
	minutesRemaining = self.currentTimeRemaining / 60;
	secondsRemaining = self.currentTimeRemaining % 60;
	
	NSString *secondString;
	if (secondsRemaining < 10) {
		secondString = [NSString stringWithFormat:@"0%zd", secondsRemaining];
	}
	else {
		secondString = [NSString stringWithFormat:@"%zd", secondsRemaining];
	}
	
	self.timerLabel.text = [NSString stringWithFormat:@"%zd:%@", minutesRemaining, secondString];
}


@end
