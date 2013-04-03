//
//  AlgoSwitcher.m
//  ImageDetector
//
//  Created by Abadie, Loïc on 03/04/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import "AlgoSwitcher.h"

@interface AlgoSwitcher ()
@end

@implementation AlgoSwitcher
@synthesize delegate        = _delegate,
            imageReconizer  = imageReconizer_;

#pragma mark -------------------------- public ---------------------------------
#pragma mark -------------------------------------------------------------------

- (IBAction)DoneTaped:(UIButton *)sender{
    [_delegate buttonTapped: self];
}

#pragma mark - UIPickerDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return TpTotal;
}

#pragma mark - UIPickerdelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithUTF8String: typeFeatName[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _currentFDetector.text = [NSString stringWithUTF8String: typeFeatName[row]];
}

#pragma mark - lifeCycle

- (void)viewWillAppear:(BOOL)animated{
    [_picker selectRow: imageReconizer_->getFeatureDetector() inComponent: 0 animated: YES];
    [self pickerView: _picker didSelectRow: imageReconizer_->getFeatureDetector() inComponent: 0];
    [super viewWillAppear: animated];
}

- (void)viewDidUnload {
    [self setPicker:nil];
    [self setCurrentFDetector:nil];
    [super viewDidUnload];
}

#pragma mark alloc / dealloc

- (void)dealloc{
    [_picker            release];
    [_currentFDetector  release];
    [super dealloc];
}

#pragma mark -------------------------- private --------------------------------
#pragma mark -------------------------------------------------------------------

@end
