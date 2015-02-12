//
//  Constants.h
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 3/14/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#ifndef Technology_Flashcard_Game_Constants_h
#define Technology_Flashcard_Game_Constants_h



//
//MACROS HERE!!!
//
//change these and they will affect the views, layout, and functionality of the app
//

#define NUMBER_EASY_CARDS_IN_EASY_DECK (10)
#define NUMBER_MEDIUM_CARDS_IN_EASY_DECK (10)
#define NUMBER_HARD_CARDS_IN_EASY_DECK (0)
//this is the easy deck

#define NUMBER_EASY_CARDS_IN_MEDIUM_DECK (5)
#define NUMBER_MEDIUM_CARDS_IN_MEDIUM_DECK (10)
#define NUMBER_HARD_CARDS_IN_MEDIUM_DECK (5)
//this is the medium deck

#define NUMBER_EASY_CARDS_IN_HARD_DECK (0)
#define NUMBER_MEDIUM_CARDS_IN_HARD_DECK (10)
#define NUMBER_HARD_CARDS_IN_HARD_DECK (10)
//this is hard deck

#define BACKGROUND_RED (50.0f / 255.0f)
#define BACKGROUND_GREEN (207.0f / 255.0f)
#define BACKGROUND_BLUE (255.0f / 255.0f)
//colors need to be between 0.0 and 1.0. color components can have any of 255 values. This is overridden if you use Apple's underpage background (next...)

#define BACKGROUND_USE_UNDERPAGE_COLOR (YES)
//YES or NO whether or not you want the background to have apple's  underpage background

//#define SHADOW_OFFSET_X () NOT IN USE
//#define SHADOW_OFFSET_Y () NOT IN USE
#define BUTTON_SHADOW_RADIUS (1)
//X and Y must be positive. They are in the unit "points" (because apple devices have different screen resolutions)

#define BUTTON_HAS_SHADOW (YES)
//YES if the button has a shadow, NO if it does not have a shadow

//#define BUTTON_SHADOW_DARKNESS (0.0f) NOT IN USE
//darkness is in units of alpha(transparency) and can be any value between 0.0 (no shadow) and 1.0(very dark shadow)

#define BUTTON_CORNER_RADIUS (10.0f)
//corner radius must be a positive number. It is in the unit "points" (because apple devices have different screen resolutions)

#define BUTTON_GRADIENT_AMOUNT (0.5f)
#define BUTTON_PRESSED_GRADIENT_AMOUNT (0.4f)
//gradient is in units of alpha(transparency) and can be any value between 0.0 and 1.0

#define BUTTON_BORDER_DARKNESS (0.5f)
//darkness can be any value between 0.0 and 1.0

//#define BUTTON_UNPRESSED_DARKNESS (1.3) NOT IN USE
//#define BUTTON_PRESSED_DARKNESS (0.3) NOT IN USE
//values below 1 are dark, values above 1 are light when compared to the background color of the button

#define BUTTON_BORDER_THICKNESS (3.0f)
//border thickness must be a positive number. It is in the unit "points" (because apple devices have different screen resolutions)

#define CARDS_USE_DUMMY_CARDS (NO)
//use dummy cards with YES, use real cards with NO

#define SPEED_OF_FLASHCARD_FLIP (0.5)
#define SPEED_OF_FLASHCARD_CHANGE (0.2)
//measured in seconds

#define SHOULD_HAVE_SOUND (YES)
//specify YES or NO whether or not the app should have sound




//
//MACROS HERE!!!
//
//DON'T CHANGE THESE! THEY ARE NECESSARY FOR THE GAME'S INNER DEFAULTS
//


#define TF_FIVE_HIGH_SCORES_EASY (@"5 high scores easy")
#define TF_FIVE_HIGH_SCORE_NAMES_EASY (@"5 high score names easy")
#define TF_FIVE_HIGH_SCORES_MEDIUM (@"5 high scores medium")
#define TF_FIVE_HIGH_SCORE_NAMES_MEDIUM (@"5 high score names medium")
#define TF_FIVE_HIGH_SCORES_HARD (@"5 high scores hard")
#define TF_FIVE_HIGH_SCORE_NAMES_HARD (@"5 high score names hard")

#endif
