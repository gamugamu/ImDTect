//
//  ViewController.m
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize buttonDelegate = _buttonDelegate;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

- (IBAction)buttonTaped:(UIButton *)sender{
    if([_buttonDelegate respondsToSelector: @selector(buttonTaped)])
        [_buttonDelegate performSelector: @selector(buttonTaped)];
}
@end
