//
//  TFPreGameViewController.m
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 3/14/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import "TFPreGameViewController.h"
#import "TFGameViewController.h"
#import "TechnologyFlashcardGameButton.h"
#import "Constants.h"

@interface TFPreGameViewController ()

@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *startGameButton;
@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *resetHighScoresButton;

@property (weak, nonatomic) IBOutlet UILabel *firstHighScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondHighScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdHighScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthHighScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthHighScoreLabel;


@end

@implementation TFPreGameViewController

-(BOOL) prefersStatusBarHidden
{
	return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self setupButtons];
	[self setupView];
	[self displayHighScores];
	
	
}

-(void) setupButtons
{
	[self.startGameButton setBackgroundColor:[UIColor colorWithRed:255.0f / 255.0f
																													 green:0.0f / 255.0f
																														blue:0.0f / 255.0f
																													 alpha:1.0f]];
	[self.backButton setBackgroundColor:[UIColor colorWithRed:150.0f / 255.0f
																													 green:0.0f / 255.0f
																														blue:150.0f / 255.0f
																													 alpha:1.0f]];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	[super viewWillAppear:animated];
}


-(void) setupView
{
	//background color?
	if (!BACKGROUND_USE_UNDERPAGE_COLOR)
		[self.view setBackgroundColor:[UIColor colorWithRed:BACKGROUND_RED green:BACKGROUND_GREEN blue:BACKGROUND_BLUE alpha:1]];
	else
		[self.view setBackgroundColor:[UIColor underPageBackgroundColor]];
}
- (IBAction)backButtonPressed
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetHighScores
{
	switch (self.difficultyLevel)
	{
		case 1:
			[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORES_EASY];
			[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORE_NAMES_EASY];
			break;
		case 2:
			[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORES_MEDIUM];
			[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORE_NAMES_MEDIUM];
			break;
		case 3:
			[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORES_HARD];
			[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORE_NAMES_HARD];
			break;
		default:
			[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORES_EASY];
			[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORE_NAMES_EASY];
			break;
	}
	
	self.firstHighScoreLabel.text = @"1.";
	self.secondHighScoreLabel.text = @"2.";
	self.thirdHighScoreLabel.text = @"3.";
	self.fourthHighScoreLabel.text = @"4.";
	self.fifthHighScoreLabel.text = @"5.";
	
	[self displayHighScores];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[super prepareForSegue:segue sender:sender];
	// Make sure your segue name in storyboard is the same as this line
	if ([[segue identifier] isEqualToString:@"startGameSegue"])
	{
		// Get reference to the destination view controller
		TFGameViewController *gameViewController = [segue destinationViewController];
		
		// Pass any objects to the view controller here, like...
		gameViewController.technologyDeck = self.cardDeck;
		gameViewController.difficultyLevel = self.difficultyLevel;
	}
}

-(void) displayHighScores
{
	NSArray * topFiveHighScores;
	NSArray * topFiveHighScoreNames;
	switch (self.difficultyLevel)
	{
		case 1:
			topFiveHighScores = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORES_EASY];
			topFiveHighScoreNames = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORE_NAMES_EASY];
			break;
		case 2:
			topFiveHighScores = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORES_MEDIUM];
			topFiveHighScoreNames = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORE_NAMES_MEDIUM];
			break;
		case 3:
			topFiveHighScores = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORES_HARD];
			topFiveHighScoreNames = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORE_NAMES_HARD];
			break;
		default:
			topFiveHighScores = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORES_EASY];
			topFiveHighScoreNames = [[NSUserDefaults standardUserDefaults] arrayForKey:TF_FIVE_HIGH_SCORE_NAMES_EASY];
			break;
	}
	
	
	NSMutableString * title;
	for (int i = 0; i < [topFiveHighScoreNames count]; i++)
	{
		if (i == 0) title = [self.firstHighScoreLabel.text mutableCopy];
		if (i == 1) title = [self.secondHighScoreLabel.text mutableCopy];
		if (i == 2) title = [self.thirdHighScoreLabel.text mutableCopy];
		if (i == 3) title = [self.fourthHighScoreLabel.text mutableCopy];
		if (i == 4) title = [self.fifthHighScoreLabel.text mutableCopy];
		
		[title appendFormat:@" %@ %d%%", topFiveHighScoreNames[i], (int)([topFiveHighScores[i] doubleValue] * 100)];
		
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
