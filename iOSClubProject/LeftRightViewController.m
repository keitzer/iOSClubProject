//
//  LeftRightViewController.m
//  iOSClubProject
//
//  Created by Alex Ogorek on 2/24/16.
//  Copyright © 2016 iosclub. All rights reserved.
//

#import "LeftRightViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface LeftRightViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *leftHandImageView;
@property (nonatomic, weak) IBOutlet UIImageView *rightHandImageView;

@property (nonatomic, assign) BOOL isGuessResetting;

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, assign) NSInteger totalGuesses;
@property (nonatomic, assign) NSInteger correctGuesses;

@property (nonatomic, weak) IBOutlet UILabel *guessRateLabel;

@property (nonatomic, weak) IBOutlet UILabel *leftHandGuessCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightHandGuessCountLabel;
@property (nonatomic, assign) NSInteger leftHandGuessCount;
@property (nonatomic, assign) NSInteger rightHandGuessCount;

@end

@implementation LeftRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"ding"
											  withExtension:@"mp3"];
	
	self.player = [[AVAudioPlayer alloc]
				   initWithContentsOfURL:soundURL error:nil];
}

-(IBAction)leftButtonPressed {
	[self playerGuessedWithLeftSide:YES];
}

-(IBAction)rightButtonPressed {
	[self playerGuessedWithLeftSide:NO];
}

-(void)playerGuessedWithLeftSide:(BOOL)didGuessWithLeft {
	
	if (self.isGuessResetting) {
		return;
	}
	
	self.isGuessResetting = YES;
	
	self.totalGuesses++;
	
	[self.player stop];
	[self.player setCurrentTime:0];
	
	
	//randomly generate a "side"
	NSInteger computerGuess = arc4random() % 2;
	
	//left side
	if (computerGuess == 0) {
		self.leftHandImageView.image = [UIImage imageNamed:@"hand"];
		self.leftHandGuessCount++;
		self.leftHandGuessCountLabel.text =
			[NSString stringWithFormat:@"%zd", self.leftHandGuessCount];
		
		if (didGuessWithLeft) {
			[self playerGuessedCorrectly];
		}
		else {
			[self playerGuessedWrong];
		}
	}
	//right side
	else if (computerGuess == 1) {
		self.rightHandImageView.image = [UIImage imageNamed:@"hand"];
		self.rightHandGuessCount++;
		self.rightHandGuessCountLabel.text =
			[NSString stringWithFormat:@"%zd", self.rightHandGuessCount];
		
		if (!didGuessWithLeft) {
			[self playerGuessedCorrectly];
		}
		else {
			[self playerGuessedWrong];
		}
	}
	
	[NSTimer scheduledTimerWithTimeInterval:0.5
									 target:self
								   selector:@selector(resetHands)
								   userInfo:nil
									repeats:NO];
	
	
	CGFloat averageGuessRate = 100 * ((CGFloat)self.correctGuesses / (CGFloat)self.totalGuesses);
	self.guessRateLabel.text = [NSString stringWithFormat:@"%.02f%%", averageGuessRate];
}

-(void)resetHands {
	self.view.backgroundColor = [UIColor whiteColor];
	self.isGuessResetting = NO;
	
	self.leftHandImageView.image = [UIImage imageNamed:@"fist"];
	self.rightHandImageView.image = [UIImage imageNamed:@"fist"];
}

-(void)playerGuessedCorrectly {
	self.view.backgroundColor = [UIColor greenColor];
	self.correctGuesses++;
	[self.player play];
}

-(void)playerGuessedWrong {
	self.view.backgroundColor = [UIColor redColor];
}



@end
