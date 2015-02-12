//
//  Flashcard.h
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 2/20/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flashcard : NSObject

@property (nonatomic, strong) NSString * flashcardImageName;
//this is the technology/not technology image on the flashcard

@property (nonatomic, strong) NSString * flashcardDescription;
//a description of the item on the technology flashcard

@property (nonatomic) BOOL isTechnology;
//YES = image is technology. NO = image is not technology

@end
