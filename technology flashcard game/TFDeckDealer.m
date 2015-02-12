//
//  TFDeckDealer.m
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 3/15/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import "TFDeckDealer.h"
#import "Flashcard.h"
#import "Constants.h"

@interface TFDeckDealer()

@property (nonatomic, strong) NSArray * easyDeck;
@property (nonatomic, strong) NSArray * mediumDeck;
@property (nonatomic, strong) NSArray * hardDeck;

@end

@implementation TFDeckDealer

-(TFDeckDealer *)init
{
	self = [super init];
	if (self)
	{
		[self updateFlashcardArrays];
	}
	return self;
}

-(void)updateFlashcardArrays
{
	__block NSMutableArray * easyArrayOfCards = [[NSMutableArray alloc] init];
	__block NSMutableArray * mediumArrayOfCards = [[NSMutableArray alloc] init];
	__block NSMutableArray * hardArrayOfCards = [[NSMutableArray alloc] init];
//	__block Flashcard * currentCard;
//
//	NSString* path = [[NSBundle mainBundle] pathForResource:((CARDS_USE_DUMMY_CARDS) ? @"IsThePictureTechnologyDummy" : @"IsThePictureTechnology")
//																									 ofType:@"txt"];
//	NSString* content = [NSString stringWithContentsOfFile:path
//																								encoding:NSUTF8StringEncoding
//																									 error:NULL];
//	[content enumerateSubstringsInRange:NSMakeRange(0, [content length])
//															options:NSStringEnumerationByWords
//													 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//														 if ([substring isEqualToString:@"YES"])
//														 {
//															 currentCard.isTechnology = YES;
//														 }
//														 else if ([substring isEqualToString:@"NO"])
//														 {
//															 currentCard.isTechnology = NO;
//														 }
//														 else if ([substring isEqualToString:@"EASY"])
//														 {
//															 [easyArrayOfCards addObject:currentCard];
//														 }
//														 else if ([substring isEqualToString:@"MEDIUM"])
//														 {
//															 [mediumArrayOfCards addObject:currentCard];
//														 }
//														 else if ([substring isEqualToString:@"HARD"])
//														 {
//															 [hardArrayOfCards addObject:currentCard];
//														 }
//														 else
//														 {
//															 currentCard = [[Flashcard alloc] init];
//															 currentCard.flashcardImageName = substring;
//														 }
//													 }];
	
	
	
	
	NSString* pathT = [[NSBundle mainBundle] pathForResource:@"T Items"
																									 ofType:@"csv"];
	NSString* contentT = [NSString stringWithContentsOfFile:pathT
																								encoding:NSUTF8StringEncoding
																									 error:NULL];
	NSArray *linesT = [contentT componentsSeparatedByString:@"\r"];
	
	for (NSString * aLine in linesT)
	{
		
//		NSLog(@"%@", aLine);

		
		NSArray *tokens = [aLine componentsSeparatedByString:@","];
		
		
		NSMutableArray* currentDeck;
		
		NSString* difficulty = (NSString *)tokens[0];
//		NSLog(@"%@", difficulty);
		NSString* description = (NSString *)tokens[2];
		NSString* imageName = (NSString *)tokens[3];
		
		Flashcard *currentCard = [[Flashcard alloc] init];
		if ([difficulty isEqualToString:@"Easy"])
		{ //this is an easy card
			currentDeck = easyArrayOfCards;
		} else if ([difficulty isEqualToString:@"Medium"])
		{ //this is a medium card
			currentDeck = mediumArrayOfCards;
		} else if ([difficulty isEqualToString:@"Hard"])
		{ //this is a hard card
			currentDeck = hardArrayOfCards;
		}
		
		description = tokens[2];
		
		imageName = tokens[3];
		
		currentCard.flashcardDescription = description;
		currentCard.flashcardImageName = imageName;
		currentCard.isTechnology = YES;
		
		[currentDeck addObject:currentCard];
		
	}
	

	
	
	
	NSString* pathNT = [[NSBundle mainBundle] pathForResource:@"NT Items"
																									 ofType:@"csv"];
	NSString* contentNT = [NSString stringWithContentsOfFile:pathNT
																								encoding:NSUTF8StringEncoding
																									 error:NULL];
	NSArray *linesNT = [contentNT componentsSeparatedByString:@"\r"];
	
	for (NSString * aLine in linesNT)
	{
		
//		NSLog(@"%@", aLine);
		
		NSArray *tokens = [aLine componentsSeparatedByString:@","];
		
		
		NSMutableArray* currentDeck;
		
		NSString* difficulty = (NSString *)tokens[0];
		NSString* description = (NSString *)tokens[2];
		NSString* imageName = (NSString *)tokens[3];
		
		Flashcard *currentCard = [[Flashcard alloc] init];
		if ([difficulty isEqualToString:@"Easy"])
		{ //this is an easy card
			currentDeck = easyArrayOfCards;
		} else if ([difficulty isEqualToString:@"Medium"])
		{ //this is a medium card
			currentDeck = mediumArrayOfCards;
		} else if ([difficulty isEqualToString:@"Hard"])
		{ //this is a hard card
			currentDeck = hardArrayOfCards;
		}
		
		description = tokens[2];
		
		imageName = tokens[3];
		
		currentCard.flashcardDescription = description;
		currentCard.flashcardImageName = imageName;
		currentCard.isTechnology = NO;
		
		[currentDeck addObject:currentCard];
		
	}
	
	self.easyDeck = [easyArrayOfCards copy];
	self.mediumDeck = [mediumArrayOfCards copy];
	self.hardDeck = [hardArrayOfCards copy];
		
}


-(NSArray *)dealADeckWithDifficultyLevel:(int) difficultyLevel
{
	NSMutableArray * resultArray = [[NSMutableArray alloc] init];
	switch (difficultyLevel)
	{
		case 1:
			for (id card in [self getEasyCards:NUMBER_EASY_CARDS_IN_EASY_DECK])
				[resultArray addObject:card];
			for (id card in [self getMediumCards:NUMBER_MEDIUM_CARDS_IN_EASY_DECK])
				[resultArray addObject:card];
			for (id card in [self getHardCards:NUMBER_HARD_CARDS_IN_EASY_DECK])
				[resultArray addObject:card];
			break;
            //DEBUG CHECKING THAT EVERY CARD HAS AN IMAGE
            /*
             CARDS WITHOUT IMAGES:
             book - 4
             */
//        case 1:
//			for (id card in [self getEasyCards:[self.easyDeck count]])
//				[resultArray addObject:card];
//			for (id card in [self getMediumCards:[self.mediumDeck count]])
//				[resultArray addObject:card];
//			for (id card in [self getHardCards:[self.hardDeck count]])
//				[resultArray addObject:card];
//            break;
		case 2:
			for (id card in [self getEasyCards:NUMBER_EASY_CARDS_IN_MEDIUM_DECK])
				[resultArray addObject:card];
			for (id card in [self getMediumCards:NUMBER_MEDIUM_CARDS_IN_MEDIUM_DECK])
				[resultArray addObject:card];
			for (id card in [self getHardCards:NUMBER_HARD_CARDS_IN_MEDIUM_DECK])
				[resultArray addObject:card];
			break;
		case 3:
			for (id card in [self getEasyCards:NUMBER_EASY_CARDS_IN_HARD_DECK])
				[resultArray addObject:card];
			for (id card in [self getMediumCards:NUMBER_MEDIUM_CARDS_IN_HARD_DECK])
				[resultArray addObject:card];
			for (id card in [self getHardCards:NUMBER_HARD_CARDS_IN_HARD_DECK])
				[resultArray addObject:card];
			break;
			
		default:
			break;
	}
	
	[self updateFlashcardArrays];
	return [self shuffle:[resultArray copy]];
}

- (NSArray *)shuffle: (NSArray *) array
{
	NSMutableArray * mutableArray = [array mutableCopy];
	NSUInteger count = [mutableArray count];
	for (NSUInteger i = 0; i < count; ++i) {
		// Select a random element between i and end of array to swap with.
		NSInteger nElements = count - i;
		NSInteger n = (arc4random() % nElements) + i;
		[mutableArray exchangeObjectAtIndex:i withObjectAtIndex:n];
	}
	
	return [mutableArray copy];
}

-(NSArray *) getEasyCards:(int) numberEasyCards
{
	NSMutableArray * returnArray = [[NSMutableArray alloc] init];
	
//	NSInteger numberElements = [self.easyDeck count] - 1;
	for (NSUInteger i = 0; i < numberEasyCards; ++i) {
		// Select a random element between i and end of array to swap with.
		NSInteger n;
        if([self.easyDeck count] > 1) n = (arc4random() % ([self.easyDeck count] - 1));
        else n = 0;
		[returnArray addObject:self.easyDeck[n]];
		
		NSMutableArray * temp = [self.easyDeck mutableCopy];
		[temp  removeObjectAtIndex:n];
		self.easyDeck = [temp copy];
		//remove the card so that we can't take it again
	}
	return [returnArray copy];
}

-(NSArray *) getMediumCards:(int) numberMediumCards
{
	NSMutableArray * returnArray = [[NSMutableArray alloc] init];
	
//	NSInteger numberElements = [self.mediumDeck count] - 1;
	for (NSUInteger i = 0; i < numberMediumCards; ++i) {
		// Select a random element between i and end of array to swap with.
		NSInteger n;
        if([self.mediumDeck count] > 1) n = (arc4random() % ([self.mediumDeck count] - 1));
        else n = 0;
		[returnArray addObject:self.mediumDeck[n]];
		
		NSMutableArray * temp = [self.mediumDeck mutableCopy];
		[temp  removeObjectAtIndex:n];
		self.mediumDeck = [temp copy];
		//remove the card so that we can't take it again
	}
	return [returnArray copy];
}

-(NSArray *) getHardCards:(int) numberHardCards
{
	NSMutableArray * returnArray = [[NSMutableArray alloc] init];
	
//	NSInteger numberElements = [self.hardDeck count] - 1;
	for (NSUInteger i = 0; i < numberHardCards; ++i) {
		// Select a random element between i and end of array to swap with.
		NSInteger n;
        if([self.hardDeck count] > 1) n = (arc4random() % ([self.hardDeck count] - 1));
        else n = 0;
		[returnArray addObject:self.hardDeck[n]];
		
		NSMutableArray * temp = [self.hardDeck mutableCopy];
		[temp  removeObjectAtIndex:n];
		self.hardDeck = [temp copy];
		//remove the card so that we can't take it again
	}
	return [returnArray copy];
}

@end
