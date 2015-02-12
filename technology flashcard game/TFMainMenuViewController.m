//
//  TFMainMenuViewController.m
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 3/14/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import "TFMainMenuViewController.h"
#import "TFPreGameViewController.h"
#import "TechnologyFlashcardGameButton.h"
#import "TFDeckDealer.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@interface TFMainMenuViewController ()

#pragma mark - VIEW
@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *easyButton;
@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *mediumButton;
@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *hardButton;
@property (weak, nonatomic) IBOutlet UIView *EiELogoView;

#pragma mark - MODEL
@property (nonatomic, strong) TFDeckDealer * deckDealer;

@end

@implementation TFMainMenuViewController

-(BOOL) prefersStatusBarHidden
{
	return YES;
}

-(TFDeckDealer *)deckDealer
{
	if (!_deckDealer)
		_deckDealer = [[TFDeckDealer alloc] init];
	return _deckDealer;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	self.EiELogoView.layer.cornerRadius = 15;
	self.EiELogoView.clipsToBounds = YES;
	[super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupView];
	// Do any additional setup after loading the view.
}

-(void) setupView
{
	//background color?
	if (!BACKGROUND_USE_UNDERPAGE_COLOR)
		[self.view setBackgroundColor:[UIColor colorWithRed:BACKGROUND_RED green:BACKGROUND_GREEN blue:BACKGROUND_BLUE alpha:1]];
	else
		[self.view setBackgroundColor:[UIColor underPageBackgroundColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[super prepareForSegue:segue sender:sender];
	// Make sure your segue name in storyboard is the same as this line
	if ([[segue identifier] isEqualToString:@"startEasyGameSegue"])
	{
		// Get reference to the destination view controller
		TFPreGameViewController *gameViewController = [segue destinationViewController];
		
		// Pass any objects to the view controller here, like...
		gameViewController.cardDeck = [self.deckDealer dealADeckWithDifficultyLevel:1];
		gameViewController.difficultyLevel = 1;
	}
	
	if ([[segue identifier] isEqualToString:@"startMediumGameSegue"])
	{
		// Get reference to the destination view controller
		TFPreGameViewController *gameViewController = [segue destinationViewController];
		
		// Pass any objects to the view controller here, like...
		gameViewController.cardDeck = [self.deckDealer dealADeckWithDifficultyLevel:2];
		gameViewController.difficultyLevel = 2;
	}

	if ([[segue identifier] isEqualToString:@"startHardGameSegue"])
	{
		// Get reference to the destination view controller
		TFPreGameViewController *gameViewController = [segue destinationViewController];
		
		// Pass any objects to the view controller here, like...
		gameViewController.cardDeck = [self.deckDealer dealADeckWithDifficultyLevel:3];
		gameViewController.difficultyLevel = 3;
	}


}
- (IBAction)resetHighScoresButtonTouchUpInside
{
	[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORES_EASY];
	[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORE_NAMES_EASY];
	[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORES_MEDIUM];
	[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORE_NAMES_MEDIUM];
	[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORES_HARD];
	[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORE_NAMES_HARD];
	[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORES_EASY];
	[[NSUserDefaults standardUserDefaults] setObject:NULL forKey:TF_FIVE_HIGH_SCORE_NAMES_EASY];
}

@end
