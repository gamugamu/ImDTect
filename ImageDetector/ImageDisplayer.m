//
//  ImageDisplayer.m
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import "ImageDisplayer.h"

@interface ImageDisplayer ()

@end

@implementation ImageDisplayer
@synthesize isSelected = _isSelected;

#pragma mark -------------------------- public ---------------------------------
#pragma mark -------------------------------------------------------------------

#pragma mark - public

-(void)setIsSelected:(BOOL)isSelected{
    self.view.backgroundColor = isSelected? [UIColor blueColor] : [UIColor whiteColor];
}

#pragma mark - lifeCycle

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
}

- (void)viewDidLoad{
    NSLog(@"viewDidLoad");

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_image release];
    [super dealloc];
}

#pragma mark -------------------------- private --------------------------------
#pragma mark -------------------------------------------------------------------
@end
