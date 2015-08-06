//
//  TFGameViewController.m
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 3/14/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#import "TFGameViewController.h"
#import "TFPostGameViewController.h"
#import "FlashcardView.h"
#import "Flashcard.h"
#import "TechnologyFlashcardGameButton.h"
#import "Constants.h"
#import <Parse/Parse.h>

#pragma mark - Interface/Properties
@interface TFGameViewController ()

#pragma mark - VIEW(self)
@property (nonatomic) CGRect cardOnScreenFrame;
@property (weak, nonatomic) IBOutlet UIProgressView *gameProgressView;
@property (weak, nonatomic) IBOutlet FlashcardView *currentFlashCardView;
@property (weak, nonatomic) IBOutlet UILabel *isThisTechnologyLabel;
@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *nextButton;
@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *yesTechnologyButton;
@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *noTechnologyButton;

#pragma mark - VIEW(flashcard)
@property (weak, nonatomic) IBOutlet UIImageView *correctImageView;
@property (weak, nonatomic) IBOutlet UILabel *correctLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

#pragma mark - MODEL
@property (nonatomic) NSInteger indexOfCurrentCard;
@property (nonatomic) NSInteger numberCorrect;
@property (nonatomic) NSInteger numberCards;

//constraints to keep flashcard centered
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flashcardHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flashcardWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboveFlashcardViewConstraint;

//timer properties
@property (strong, nonatomic) NSTimer * cardStatisticsTimer;
@property (nonatomic, strong) NSMutableArray * cardStatisticsArray;
@property (nonatomic, strong) NSMutableArray * cardCorrectArray;

@end

@implementation TFGameViewController

#pragma mark - View Lifecycle Methods

-(BOOL) prefersStatusBarHidden
{
	return YES;
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    
    self.flashcardHeightConstraint.constant = self.flashcardWidthConstraint.constant = 280.0f;
    if (IS_IPHONE_5) self.aboveFlashcardViewConstraint.constant = 50; 
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.numberCards = [self.technologyDeck count];
	
	self.numberCorrect = 0;
	self.gameProgressView.progress = self.numberCorrect / self.numberCards;
	self.cardNumberLabel.text = [NSString stringWithFormat:@"%ld / %ld", self.indexOfCurrentCard + 1, (long)self.numberCards];
    self.cardStatisticsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                target:self
                                                              selector:@selector(anotherSecondOnCard:)
                                                              userInfo:nil
                                                               repeats:YES];
    
    self.cardStatisticsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.technologyDeck count]; i++)
    {
        //add a 0 number to the statistics array for each card in the deck
        [self.cardStatisticsArray addObject:[[NSNumber alloc] initWithInt:0]];
    }
}

//card stistics method. adds one to the current card's time.
-(void)anotherSecondOnCard:(NSTimer *) timer
{
    if(self.indexOfCurrentCard < self.numberCards)
    {
        int secondsPerThisCard = [(NSNumber*)self.cardStatisticsArray[self.indexOfCurrentCard] intValue];
        secondsPerThisCard++;
        self.cardStatisticsArray[self.indexOfCurrentCard] = [NSNumber numberWithInt:secondsPerThisCard];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[self setupButtons];
	[self setupView];
	[self setupGameAndStart];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[super viewWillAppear:animated];
}

#pragma mark - Getters and Setters

-(NSArray *) technologyDeck
{
	if (!_technologyDeck)
		_technologyDeck = [[NSArray alloc] init];
	
	return _technologyDeck;
}

-(NSMutableArray *)cardCorrectArray
{
    if (!_cardCorrectArray) {
        _cardCorrectArray = [[NSMutableArray alloc] init];
    }
    return _cardCorrectArray;
}

#pragma mark - Setup Methods

-(void) setupGameAndStart
{
	self.indexOfCurrentCard = 0;
	
	self.currentFlashCardView.imageFaceUp = YES;
	self.currentFlashCardView.hidden = NO;
	//turn the flashcard on and put it correctly up
	
	self.nextButton.hidden = YES;
	//turn the next button off for now
	
	self.currentFlashCardView.currentFlashcard = self.technologyDeck[self.indexOfCurrentCard];
	//set the correct card to the model
	
	self.currentFlashCardView.center = CGPointMake(self.cardOnScreenFrame.size.width + self.view.bounds.size.width, self.currentFlashCardView.center.y);
	[UIView animateWithDuration:0.5
									 animations:^(void){
										 self.currentFlashCardView.frame = self.cardOnScreenFrame;
									 }];
	
}

-(void) setupView
{
	//background color?
	if (!BACKGROUND_USE_UNDERPAGE_COLOR)
		[self.view setBackgroundColor:[UIColor colorWithRed:BACKGROUND_RED green:BACKGROUND_GREEN blue:BACKGROUND_BLUE alpha:1]];
	else
		[self.view setBackgroundColor:[UIColor underPageBackgroundColor]];
	
	self.cardOnScreenFrame = CGRectMake(self.currentFlashCardView.frame.origin.x, self.currentFlashCardView.frame.origin.y, self.currentFlashCardView.frame.size.width, self.currentFlashCardView.frame.size.height);
}

- (void) setupButtons
{
	
	[self.yesTechnologyButton setBackgroundColor:[UIColor colorWithRed:0 green:200.0f/255.0f blue:0 alpha:1]];
	[self.noTechnologyButton setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:173.0f/255.0f blue:0 alpha:1]];
	[self.nextButton setBackgroundColor:[UIColor colorWithRed:150.0f/255.0f green:0/255.0f blue:255.0f / 255.0f alpha:1]];
}

#pragma mark - Button Actions
- (IBAction)noTechnologyButtonPress
{
	if ([(Flashcard *)(self.technologyDeck[self.indexOfCurrentCard]) isTechnology])
	{
		self.descriptionLabel.text = [(Flashcard *)(self.technologyDeck[self.indexOfCurrentCard]) flashcardDescription];
		[self showAnswerIncorrect];
	}
	else
	{
		self.descriptionLabel.text = [(Flashcard *)(self.technologyDeck[self.indexOfCurrentCard]) flashcardDescription];
		[self showAnswerCorrect];
	}
	
	self.yesTechnologyButton.hidden = YES;
	self.noTechnologyButton.hidden = YES;
	self.nextButton.hidden = NO;
	self.isThisTechnologyLabel.hidden = YES;
}//Not Technology has been pressed

- (IBAction)yesTechnologyButtonPressed
{
	if ([(Flashcard *)(self.technologyDeck[self.indexOfCurrentCard]) isTechnology])
	{
		self.descriptionLabel.text = [(Flashcard *)(self.technologyDeck[self.indexOfCurrentCard]) flashcardDescription];
		[self showAnswerCorrect];
	}
	else
	{
		self.descriptionLabel.text = [(Flashcard *)(self.technologyDeck[self.indexOfCurrentCard]) flashcardDescription];
		[self showAnswerIncorrect];
	}
	//THIS IS A TEST

	self.yesTechnologyButton.hidden = YES;
	self.noTechnologyButton.hidden = YES;
	self.nextButton.hidden = NO;
	self.isThisTechnologyLabel.hidden = YES;
	//turn the answer buttons off. turn the next button on. The kid has answered the question.
}//Yes techonology button has been pressed


- (IBAction)nextButtonPressed
{
	
	if (self.indexOfCurrentCard == [self.technologyDeck count] - 1)
	{
		[self performSegueWithIdentifier:@"endGameSegue" sender:self];
		return;
	}
	self.currentFlashCardView.currentFlashcard = self.technologyDeck[++self.indexOfCurrentCard];
	//increment and update the image on the card
	
    // Tarry Cutler added these lines to change animation card display - start
    self.currentFlashCardView.imageFaceUp = YES;
    self.correctImageView.hidden = YES;
    self.correctLabel.hidden = YES;
    
    self.yesTechnologyButton.hidden = NO;
    self.noTechnologyButton.hidden = NO;
    // Tarry Cutler added these lines end
    
	self.nextButton.hidden = YES;
	self.descriptionLabel.hidden = YES;
	self.isThisTechnologyLabel.hidden = NO;
	self.cardNumberLabel.text = [NSString stringWithFormat:@"%ld / %ld", self.indexOfCurrentCard + 1, (long)self.numberCards];
	// turn the answer buttons back on for the next question. turnt the next button off
	
	
	[UIView animateWithDuration:SPEED_OF_FLASHCARD_CHANGE
									 animations:^(void){
										 self.currentFlashCardView.center = CGPointMake(-self.currentFlashCardView.center.x, self.currentFlashCardView.center.y);
									 }
			
									 completion:^(BOOL finished) {
										 // Tarry Cutler commented this out to keep image from migrating up
										 //_currentFlashCardView.center = CGPointMake(self.cardOnScreenFrame.size.width + self.view.bounds.size.width, self.currentFlashCardView.center.y);
										 //move the flashcard offscreen right
										 
										 self.currentFlashCardView.imageFaceUp = YES;
										 self.correctImageView.hidden = YES;
										 self.correctLabel.hidden = YES;
										 //setup the flashcard for face up view
										 
										 self.yesTechnologyButton.hidden = NO;
										 self.noTechnologyButton.hidden = NO;
										 
										 [UIView animateWithDuration:SPEED_OF_FLASHCARD_CHANGE
																			animations:^(void){
																				// Tarry Cutler commented this out to keep image from migrating up
                                                                                // self.currentFlashCardView.frame = self.cardOnScreenFrame;
																			}];
										 //animate it back on
										 
									 }];
	
	
}

#pragma mark - Change The View

-(void) showAnswerCorrect
{
	self.currentFlashCardView.isCorrect = YES;
	self.numberCorrect++;
	self.correctLabel.text = @"CORRECT!";
	self.correctImageView.image = self.currentFlashCardView.correctImage;
    [self.cardCorrectArray addObject:[NSNumber numberWithBool:YES]];
	[self flipCard];
}

-(void) showAnswerIncorrect
{
	self.currentFlashCardView.isCorrect = NO;
	self.correctLabel.text = @"INCORRECT";
	self.correctImageView.image = self.currentFlashCardView.inCorrectImage;
    [self.cardCorrectArray addObject:[NSNumber numberWithBool:NO]];
	[self flipCard];
}

-(void) flipCard
{
	[self.gameProgressView setProgress:((double)(self.indexOfCurrentCard + 1) / self.numberCards) animated:YES];
	[UIView transitionWithView:self.currentFlashCardView
										duration:SPEED_OF_FLASHCARD_FLIP
										 options:UIViewAnimationOptionTransitionFlipFromRight
									animations:^{
										[self.currentFlashCardView setNeedsDisplay];
										self.currentFlashCardView.imageFaceUp = NO;
										self.correctImageView.hidden = NO;
										self.correctLabel.hidden = NO;
										self.descriptionLabel.hidden = NO;
									}
									completion:NULL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	
	if ([[segue identifier] isEqualToString:@"endGameSegue"])
	{
		// Get reference to the destination view controller
		TFPostGameViewController * postGameViewController = [segue destinationViewController];
		
		[self saveCardStatistics];
		
		// Pass any objects to the view controller here, like...
		postGameViewController.numberCards = self.numberCards;
		postGameViewController.numberCorrect = self.numberCorrect;
		postGameViewController.difficultyLevel = self.difficultyLevel;
		postGameViewController.averageTimePerCard = [self getAverageTimePerCard];
	}

	[super prepareForSegue:segue sender:sender];
}

-(int)getAverageTimePerCard
{
    int numberCardsToPutInAverage = 0;
    int totalTimeInCards = 0;
    for (NSNumber* number in self.cardStatisticsArray)
    {
        int timeInThisCard = [number intValue];
        if (timeInThisCard < 60)
        {
            numberCardsToPutInAverage++;
            totalTimeInCards += timeInThisCard;
        }
    }
    return ceil((numberCardsToPutInAverage != 0)? (double)totalTimeInCards / numberCardsToPutInAverage : 0);
}

-(void)saveCardStatistics
{
//    NSError * error; //create the error
//    
//    //find the documents directory
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    //make a file name to write the data to using the documents directory:
//    NSString *fileName = [NSString stringWithFormat:@"%@/cardStatistics.csv", documentsDirectory];
//    
//    //get the current content because we will be adding to it
//    NSMutableString* contentT = [[NSString stringWithContentsOfFile:fileName
//                                                       usedEncoding:NSUTF8StringEncoding
//                                                              error:&error] mutableCopy];
//    
//    NSString * stringToAdd = [NSString stringWithFormat:@"average time(seconds): %d", [self getAverageTimePerCard]];
//    
//    [contentT appendFormat: @"%@", stringToAdd];
//    
//    //save content to the documents directory
//    BOOL success = [contentT writeToFile:fileName
//                              atomically:NO
//                                encoding:NSStringEncodingConversionAllowLossy
//                                   error:&error];
//    
//    if(success == NO)
//    {
//        NSLog( @"couldn't write out file to %@, error is %@", fileName, [error localizedDescription]);
//    }
	
	//also save the statistics online:
	
	NSMutableArray * cardNameArray = [[NSMutableArray alloc] init];
	int index = 0;
	for (Flashcard * card in self.technologyDeck)
	{
    [cardNameArray addObject:@{@"CardName": [(Flashcard *)(self.technologyDeck[index]) flashcardImageName],
                               @"Time":self.cardStatisticsArray[index],
                               @"Correct":self.cardCorrectArray[index]}];
		index++;
	}
	
	PFObject *gameSession = [PFObject objectWithClassName:@"GamePlay"];
	[gameSession setObject:cardNameArray forKey:@"cardDeck"];
	[gameSession saveInBackground];
	
}


@end


