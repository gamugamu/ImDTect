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
@synthesize isSelected     = _isSelected,
            delegate       = _delegate;

#pragma mark -------------------------- public ---------------------------------
#pragma mark -------------------------------------------------------------------

#pragma mark - public

- (void)setIsSelected:(BOOL)isSelected{
    self.view.backgroundColor = isSelected? [UIColor blueColor] : [UIColor yellowColor];
    _isSelected = isSelected;
}

#pragma mark getter / setter

#pragma mark - lifeCycle

- (void)viewDidLoad{
    [self addTouchGesture];
    [super viewDidLoad];
}

#pragma mark - alloc / Dealloc

- (void)dealloc {
    [_image release];
    [super dealloc];
}

#pragma mark -------------------------- private --------------------------------
#pragma mark -------------------------------------------------------------------

- (void)toggleSelected{
    if(!_isSelected){
        self.isSelected = !_isSelected;

        if([_delegate respondsToSelector: @selector(imageDisplayerChanged:)])
            [_delegate imageDisplayerChanged: self];
    }
}

#pragma mark - touch logic

- (void)addTouchGesture{
    UIGestureRecognizer* touch = [[UITapGestureRecognizer alloc]
                                  initWithTarget: self
                                  action: @selector(toggleSelected)];
    
    [self.view addGestureRecognizer: touch];
        [touch release];
}

@end
