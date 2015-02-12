//
//  Flashcard.m
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 2/20/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import "Flashcard.h"

@implementation Flashcard

- (id)initWithImage:(NSString *)flashcardImageName andIsItTechnology:(BOOL)isTechnology
{
	self = [super init];
	if (self)
	{
		self.flashcardImageName = flashcardImageName;
		self.isTechnology = isTechnology;
	}
	return self;
}

@end
