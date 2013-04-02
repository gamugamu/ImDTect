//
//  FTSimpleAnimation.m
//  Nocibe
//
//  Created by Abadie, Loïc on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FTSimpleAnimation.h"

@implementation FTSimpleAnimation

+ (void)makeBlackScreenAppearing:(UIView*)shadingScreen{
	shadingScreen.alpha		= 0;
	shadingScreen.hidden	= NO;

	[UIView animateWithDuration: .5f
					 animations:^{
						 shadingScreen.alpha = .5f; 
					 }];
}

+ (void)makeBlackScreenDisappearing:(UIView*)shadingScreen{
	shadingScreen.alpha		= .5f;
	shadingScreen.hidden	= NO;
	
	[UIView animateWithDuration: .5f
					 animations:^{
						 shadingScreen.alpha = 0;
					 } completion:^(BOOL finished) {
						 shadingScreen.hidden	= YES;
					 }];
}
@end
