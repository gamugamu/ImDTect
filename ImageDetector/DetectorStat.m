//
//  TimeImageDetectorStat.m
//  ImageDetector
//
//  Created by Abadie, Loïc on 02/04/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import "DetectorStat.h"

@interface DetectorStat ()

@end

@implementation DetectorStat

#pragma mark -------------------------- public ---------------------------------
#pragma mark -------------------------------------------------------------------

#pragma mark - public

- (void)didImageMatche:(BOOL)didMatch{
    if(didMatch){
        _didMatch.text              = @"OUI";
        _didMatch.backgroundColor   = [UIColor greenColor];
    }
    else{
        _didMatch.text              = @"NON";
        _didMatch.backgroundColor   = [UIColor orangeColor];
    }
}

- (void)clearOutput{
    _ext_0.text         = @"";
    _ext_1.text         = @"";
    _flann_Det.text     = @"";
    _display_GM.text    = @"";
    _corner_det.text    = @"";
}

#pragma mark - alloc / dealloc

- (void)dealloc {
    [_ext_0         release];
    [_ext_1         release];
    [_flann_Det     release];
    [_display_GM    release];
    [_corner_det    release];
    [_didMatch      release];
    [super dealloc];
}
@end
