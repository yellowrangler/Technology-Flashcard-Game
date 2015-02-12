//
//  FlashcardView.h
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 3/11/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flashcard.h"

@interface FlashcardView : UIView

@property (nonatomic) BOOL imageFaceUp;
//tells whether or not the card image is face-up

@property (nonatomic) BOOL isCorrect;
//tells whether or not the image is face-up

@property (nonatomic, strong) Flashcard * currentFlashcard;
//contains the information for the curent flashcard

@property (nonatomic, strong) UIImage * correctImage;
//this is the image for the correct answer

@property (nonatomic, strong) UIImage * inCorrectImage;
//this is the image for the incorrect answer

@end
