//
//  TechnologyFlashcardGameButton.m
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 3/14/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import "TechnologyFlashcardGameButton.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface TechnologyFlashcardGameButton ()

@property (nonatomic, strong) AVAudioPlayer * player;

@property (nonatomic) BOOL shouldPlayButtonTone;

@end

@implementation TechnologyFlashcardGameButton

-(id) init
{
	self = [super init];
	if (self) {
		[self setupBorder];
		self.imageView.contentMode = UIViewContentModeScaleToFill;
		[self setTitleColor:[super titleColorForState:UIControlStateNormal] forState:UIControlStateHighlighted];
		[self setupView];
		[self setupAudioPlayer];
	}
	return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setupBorder];
		self.imageView.contentMode = UIViewContentModeScaleToFill;
		[self setTitleColor:[super titleColorForState:UIControlStateNormal] forState:UIControlStateHighlighted];
		[self setupView];
		[self setupAudioPlayer];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
			[self setupBorder];
			self.imageView.contentMode = UIViewContentModeScaleToFill;
			[self setTitleColor:[super titleColorForState:UIControlStateNormal] forState:UIControlStateHighlighted];
			[self setupView];
			[self setupAudioPlayer];
   }
    return self;
}

- (void)awakeFromNib
{
	[self setupView];
}

-(void) setupAudioPlayer
{
	self.shouldPlayButtonTone = SHOULD_HAVE_SOUND;
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"blip" ofType:@"mp3"]];	
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
}

-(void) addLightGradient
{
	//this is so the gradient fills the button
	CAGradientLayer *buttonLayer = [CAGradientLayer layer];
	NSArray *colors = [NSArray arrayWithObjects:
										 (id)[UIColor colorWithWhite:255.0f / 255.0f alpha:BUTTON_GRADIENT_AMOUNT].CGColor,
										 (id)[UIColor colorWithWhite:255.0f / 255.0f alpha:0.0f].CGColor,
										 nil];
	[buttonLayer setColors:colors];
	[buttonLayer setFrame:self.bounds];
	buttonLayer.cornerRadius = self.layer.cornerRadius;
	[self.layer.sublayers[0] removeFromSuperlayer];
	[self.layer insertSublayer:buttonLayer atIndex:0];
	return;
}

-(void) addDarkGradient
{
	//this is so the gradient fills the button
	CAGradientLayer *buttonLayer = [CAGradientLayer layer];
	NSArray *colors = [NSArray arrayWithObjects:
										 (id)[UIColor colorWithWhite:0.0f / 255.0f alpha:BUTTON_PRESSED_GRADIENT_AMOUNT].CGColor,
										 (id)[UIColor colorWithWhite:0.0f / 255.0f alpha:0.0f].CGColor,
										 nil];
	[buttonLayer setColors:colors];
	[buttonLayer setFrame:self.bounds];
	buttonLayer.cornerRadius = self.layer.cornerRadius;
	[self.layer.sublayers[0] removeFromSuperlayer];
	[self.layer insertSublayer:buttonLayer atIndex:0];
	return;
}

-(void)setBounds:(CGRect)bounds
{
	[super setBounds:bounds];
	CAGradientLayer *buttonLayer = [CAGradientLayer layer];
	NSArray *colors = [NSArray arrayWithObjects:
										 (id)[UIColor colorWithWhite:255.0f / 255.0f alpha:BUTTON_GRADIENT_AMOUNT].CGColor,
										 (id)[UIColor colorWithWhite:255.0f / 255.0f alpha:0.0f].CGColor,
										 nil];
	[buttonLayer setColors:colors];
	[buttonLayer setFrame:self.bounds];
	buttonLayer.cornerRadius = self.layer.cornerRadius;
	[self.layer insertSublayer:buttonLayer atIndex:0];
}

-(void) setupBorder
{
	
	const CGFloat* components = CGColorGetComponents(self.backgroundColor.CGColor);
	if (components)
		self.layer.borderColor = [[[UIColor alloc] initWithRed:components[0] * BUTTON_BORDER_DARKNESS
																									 green:components[1] * BUTTON_BORDER_DARKNESS
																										blue:components[2] * BUTTON_BORDER_DARKNESS
																									 alpha:CGColorGetAlpha(self.backgroundColor.CGColor)] CGColor];
	self.layer.borderWidth = BUTTON_BORDER_THICKNESS;
	//self.clipsToBounds = YES;
	[self.layer setCornerRadius:BUTTON_CORNER_RADIUS];

}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
	[super setBackgroundColor:backgroundColor];
	[self setupBorder];
}

-(void)setHighlighted:(BOOL)highlighted
{
	
	if (highlighted == YES)
	{
		[self addDarkGradient];
		[self highlightView];
	} else
	{
		[self addLightGradient];
		[self clearHighlightView];
		[self.player setCurrentTime:0.0];
		[self.player play];
	}
	
	[super setHighlighted:highlighted];
}

- (void)setupView
{
	[self setupBorder];
	if (!BUTTON_HAS_SHADOW)
		self.clipsToBounds = YES;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowRadius = BUTTON_SHADOW_RADIUS;
	[self clearHighlightView];
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.layer.bounds;
	gradient.cornerRadius = 10;
	gradient.colors = [NSArray arrayWithObjects:
										 (id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor,
										 (id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor,
										 (id)[UIColor colorWithWhite:0.0f alpha:0.0f].CGColor,
										 (id)[UIColor colorWithWhite:0.0f alpha:0.4f].CGColor,
										 nil];
	float height = gradient.frame.size.height;
	gradient.locations = [NSArray arrayWithObjects:
												[NSNumber numberWithFloat:0.0f],
												[NSNumber numberWithFloat:0.2*30/height],
												[NSNumber numberWithFloat:1.0-0.1*30/height],
												[NSNumber numberWithFloat:1.0f],
												nil];
	[self.layer insertSublayer:gradient atIndex:0];
}
- (void)highlightView
{
	self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
	self.layer.shadowOpacity = 0.25;
}

- (void)clearHighlightView {
	self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
	self.layer.shadowOpacity = 0.5;
}



@end




