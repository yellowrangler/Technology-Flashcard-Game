//
//  TFPostGameViewController.h
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 3/14/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFPostGameViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic) NSInteger numberCorrect;
@property (nonatomic) NSInteger numberCards;
@property (nonatomic) NSInteger difficultyLevel;
@property (nonatomic) NSInteger averageTimePerCard;

@end
 