//
//  TFPostGameViewController.m
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 3/14/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import "TFPostGameViewController.h"
#import "TechnologyFlashcardGameButton.h"
#import "Constants.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface TFPostGameViewController ()

#pragma mark - High	Scores Labels
@property (weak, nonatomic) IBOutlet UILabel *highScoresLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstHighScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondHighScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdHighScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthHighScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthHighScoreLabel;

#pragma mark - New Scores Views
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addHighScoreLabel;
@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *addNewHighScoreLabel;

@property (nonatomic, strong) NSArray * topFiveHighScores;
@property (nonatomic, strong) NSArray * topFiveHighScoreNames;

#pragma mark - VIEW
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageTimePerCardLabel;

//for the audio player
@property (nonatomic, strong) AVAudioPlayer * yeahPlayer;
@property (nonatomic, strong) AVAudioPlayer * sadTrombonesPlayer;

@end

@implementation TFPostGameViewController

-(BOOL) prefersStatusBarHidden
{
	return YES;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	if (!self.numberCards) self.numberCards = 1;
	// Do any additional setup after loading the view.
	
	[self setupView];
	
	switch (self.difficultyLevel)
	{
		case 1:
			self.topFiveHighScores = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORES_EASY];
			self.topFiveHighScoreNames = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORE_NAMES_EASY];
			break;
		case 2:
			self.topFiveHighScores = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORES_MEDIUM];
			self.topFiveHighScoreNames = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORE_NAMES_MEDIUM];
			break;
		case 3:
			self.topFiveHighScores = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORES_HARD];
			self.topFiveHighScoreNames = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORE_NAMES_HARD];
			break;
		default:
			self.topFiveHighScores = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORES_EASY];
			self.topFiveHighScoreNames = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORE_NAMES_EASY];
			break;
	}
	
	
	double score = (double)self.numberCorrect / self.numberCards;
	if (score < 0.5) self.feedbackLabel.text = @"Try Again...";
	if (self.averageTimePerCard) {
		if(self.averageTimePerCard != 1) self.averageTimePerCardLabel.text = [NSString stringWithFormat:@"%ld Seconds Per Card", (long)self.averageTimePerCard];
		if(self.averageTimePerCard == 1) self.averageTimePerCardLabel.text = [NSString stringWithFormat:@"%ld Second Per Card", (long)self.averageTimePerCard];
	} else self.averageTimePerCardLabel.text = @"";
	if (!self.topFiveHighScores || ([self.topFiveHighScores count] < 5))
	{
		[self setupAddHighScore];
	}
	else
		if ((score >= [self.topFiveHighScores[0] doubleValue]) ||
				(score >= [self.topFiveHighScores[1] doubleValue]) ||
				(score >= [self.topFiveHighScores[2] doubleValue]) ||
				(score >= [self.topFiveHighScores[3] doubleValue]) ||
				(score >= [self.topFiveHighScores[4] doubleValue]))
		{
			[self setupAddHighScore];
		}
	else
		[self displayHighScores];
	
	self.scoreLabel.text = [NSString stringWithFormat:@"%ld / %ld", (long)self.numberCorrect, (long)self.numberCards];
	
	[self registerForKeyboardNotifications];
	
	self.nameTextField.delegate = self;
	
	[self setupAudioPlayer];
	
}

-(void) setupAudioPlayer
{
	NSURL *yeahFileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"yeah" ofType:@"mp3"]];
	self.yeahPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:yeahFileURL error:nil];
	NSURL *sadTrombonesFileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"sadTrombones" ofType:@"mp3"]];
	self.sadTrombonesPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:sadTrombonesFileURL error:nil];
}

- (void)registerForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(keyboardWillBeShown:)
																							 name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(keyboardWillBeHidden:)
																							 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
	NSDictionary* info = [aNotification userInfo];
	CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	CGRect aRect = self.view.frame;
	aRect.size.height -= keyboardSize.height;
	
	CGPoint lowerOrigin = CGPointMake(self.activeField.frame.origin.x, self.activeField.frame.origin.y + self.activeField.frame.size.height);
	
	if (!CGRectContainsPoint(aRect, lowerOrigin) ) {
		CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-keyboardSize.height + 8);
		[self.scrollView setContentOffset:scrollPoint animated:YES];
	}
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
	CGPoint scrollPoint = CGPointZero;
	[self.scrollView setContentOffset:scrollPoint animated:YES];
	UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	self.scrollView.contentInset = contentInsets;
	self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	self.activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self addNewScore];
	//[textField resignFirstResponder];
	return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if([textField.text length] > 6)
		return NO;
	return YES;
}

- (IBAction)backButonPressed
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	[super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
	if ((float)self.numberCorrect / self.numberCards >= 0.5)
	{
		[self.yeahPlayer setCurrentTime:0.0];
		[self.yeahPlayer play];
	}
	else
	{
		[self.sadTrombonesPlayer setCurrentTime:0.0];
		[self.sadTrombonesPlayer play];
	}
}

-(void) setupAddHighScore
{
	if (!self.topFiveHighScores) self.topFiveHighScores = [[NSArray alloc] init];
	if (!self.topFiveHighScoreNames) self.topFiveHighScoreNames = [[NSArray alloc] init];
	
	self.nameLabel.hidden = NO;
	self.nameTextField.hidden = NO;
	self.addHighScoreLabel.hidden = NO;
	self.addNewHighScoreLabel.hidden = NO;
	
	self.highScoresLabel.hidden = YES;
	self.firstHighScoreLabel.hidden = YES;
	self.secondHighScoreLabel.hidden = YES;
	self.thirdHighScoreLabel.hidden = YES;
	self.fourthHighScoreLabel.hidden = YES;
	self.fifthHighScoreLabel.hidden = YES;
}

-(void) setupView
{
	//background color?
	if (!BACKGROUND_USE_UNDERPAGE_COLOR)
		[self.view setBackgroundColor:[UIColor colorWithRed:BACKGROUND_RED green:BACKGROUND_GREEN blue:BACKGROUND_BLUE alpha:1]];
	else
		[self.view setBackgroundColor:[UIColor underPageBackgroundColor]];
}
- (IBAction)tappedBackground:(UITapGestureRecognizer *)sender
{
	if (self.activeField)
	{
		[self.activeField resignFirstResponder];
	}
}

- (IBAction)addNewScore
{
	[self.activeField resignFirstResponder];
	BOOL scoreAdded = NO;
	
	double score = (double)self.numberCorrect / self.numberCards;
	NSString * newHighScoreName = self.nameTextField.text;
	
	NSMutableArray * topFiveHighScoresCopy = [self.topFiveHighScores mutableCopy];
	NSMutableArray * topFiveHighScoreNamesCopy = [self.topFiveHighScoreNames mutableCopy];
	
	int index = 0;
	for (NSNumber * highScore in topFiveHighScoresCopy)
	{
    double highScoreDouble = [highScore doubleValue];
		if (score > highScoreDouble)
		{
			[topFiveHighScoresCopy insertObject:[NSNumber numberWithDouble:score] atIndex:index];
			[topFiveHighScoreNamesCopy insertObject:newHighScoreName atIndex:index];
			scoreAdded = YES;
			break;
		}
		index++;
	}
	
	if (index < 5 && scoreAdded == NO)
	{
		[topFiveHighScoresCopy addObject:[NSNumber numberWithDouble:score]];
		[topFiveHighScoreNamesCopy addObject:newHighScoreName];
		scoreAdded = YES;
	}
	
	self.topFiveHighScores = [topFiveHighScoresCopy copy];
	self.topFiveHighScoreNames = [topFiveHighScoreNamesCopy copy];
	
	self.nameLabel.hidden = YES;
	self.nameTextField.hidden = YES;
	self.addHighScoreLabel.hidden = YES;
	self.addNewHighScoreLabel.hidden = YES;
	
	self.highScoresLabel.hidden = NO;
	self.firstHighScoreLabel.hidden = NO;
	self.secondHighScoreLabel.hidden = NO;
	self.thirdHighScoreLabel.hidden = NO;
	self.fourthHighScoreLabel.hidden = NO;
	self.fifthHighScoreLabel.hidden = NO;
	[self displayHighScores];
	
	switch (self.difficultyLevel)
	{
		case 1:
			[[NSUserDefaults standardUserDefaults] setObject:self.topFiveHighScores forKey:TF_FIVE_HIGH_SCORES_EASY];
			[[NSUserDefaults standardUserDefaults] setObject:self.topFiveHighScoreNames forKey:TF_FIVE_HIGH_SCORE_NAMES_EASY];
			break;
		case 2:
			[[NSUserDefaults standardUserDefaults] setObject:self.topFiveHighScores forKey:TF_FIVE_HIGH_SCORES_MEDIUM];
			[[NSUserDefaults standardUserDefaults] setObject:self.topFiveHighScoreNames forKey:TF_FIVE_HIGH_SCORE_NAMES_MEDIUM];
			break;
		case 3:
			[[NSUserDefaults standardUserDefaults] setObject:self.topFiveHighScores forKey:TF_FIVE_HIGH_SCORES_HARD];
			[[NSUserDefaults standardUserDefaults] setObject:self.topFiveHighScoreNames forKey:TF_FIVE_HIGH_SCORE_NAMES_HARD];
			break;
		default:
			[[NSUserDefaults standardUserDefaults] setObject:self.topFiveHighScores forKey:TF_FIVE_HIGH_SCORES_EASY];
			[[NSUserDefaults standardUserDefaults] setObject:self.topFiveHighScoreNames forKey:TF_FIVE_HIGH_SCORE_NAMES_EASY];
			break;
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) displayHighScores
{
	NSMutableString * title;
	for (int i = 0; i < [self.topFiveHighScoreNames count]; i++)
	{
		if (i == 0) title = [self.firstHighScoreLabel.text mutableCopy];
		if (i == 1) title = [self.secondHighScoreLabel.text mutableCopy];
		if (i == 2) title = [self.thirdHighScoreLabel.text mutableCopy];
		if (i == 3) title = [self.fourthHighScoreLabel.text mutableCopy];
		if (i == 4) title = [self.fifthHighScoreLabel.text mutableCopy];
		
		[title appendFormat:@" %@ %d%%", self.topFiveHighScoreNames[i], (int)([self.topFiveHighScores[i] doubleValue] * 100)];
		
		if (i == 0) self.firstHighScoreLabel.text =  [title copy];
		else if (i == 1) self.secondHighScoreLabel.text = [title copy];
		else if (i == 2) self.thirdHighScoreLabel.text = [title copy];
		else if (i == 3) self.fourthHighScoreLabel.text = [title copy];
		else if (i == 4) self.fifthHighScoreLabel.text = [title copy];
		
	}
	
	if ([self.fifthHighScoreLabel.text length] <= 2)
		self.fifthHighScoreLabel.hidden = YES;
	if ([self.fourthHighScoreLabel.text length] <= 2)
		self.fourthHighScoreLabel.hidden = YES;
	if ([self.thirdHighScoreLabel.text length] <= 2)
		self.thirdHighScoreLabel.hidden = YES;
	if ([self.secondHighScoreLabel.text length] <= 2)
		self.secondHighScoreLabel.hidden = YES;
	if ([self.firstHighScoreLabel.text length] <= 2)
		self.firstHighScoreLabel.hidden = YES;
	
}

@end
