//
//  FlashcardView.m
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 3/11/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import "FlashcardView.h"

@interface FlashcardView()


@end

@implementation FlashcardView

-(BOOL) prefersStatusBarHidden
{
	return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
			self.correctImage = [UIImage imageNamed:@"correct.png"];
			self.inCorrectImage = [UIImage imageNamed:@"incorrect.png"];
    }
    return self;
}

-(id)init
{
	self = [super init];
	if (self) {
		self.correctImage = [UIImage imageNamed:@"correct.png"];
		self.inCorrectImage = [UIImage imageNamed:@"incorrect.png"];
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.correctImage = [UIImage imageNamed:@"correct.png"];
		self.inCorrectImage = [UIImage imageNamed:@"incorrect.png"];
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	
	UIBezierPath * roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:15.0f];
	[roundedRect addClip];
	if (self.isCorrect)
		[[UIColor colorWithRed:40.0f / 255.0f
										 green:255.0f / 255.0f
											blue:80.0f / 255.0f
										 alpha:1.0 ] setFill];
	if (!self.isCorrect)
		[[UIColor colorWithRed:255.0f / 255.0f
										 green:150.0f / 255.0f
											blue:150.0f / 255.0f
										 alpha:1.0 ] setFill];
		
	[roundedRect stroke];
	
	UIRectFill(self.bounds);
	
	if (self.imageFaceUp == YES)
		[self drawImageSide];

}

-(void) setImageFaceUp:(BOOL) imageFaceUp
{
	_imageFaceUp = imageFaceUp;
	[self setNeedsDisplay];
}
//the getter to the imageFaceUp property is overridden


-(void)drawImageSide
{
	[[UIImage imageNamed:self.currentFlashcard.flashcardImageName] drawInRect:self.bounds];
}

-(void)setIsCorrect:(BOOL)isCorrect
{
	_isCorrect = isCorrect;
	

	[self setNeedsDisplay];
}

@end
