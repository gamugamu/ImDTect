//
//  AlgoSwitcher.h
//  ImageDetector
//
//  Created by Abadie, Loïc on 03/04/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLANNDetector.h"

@class AlgoSwitcher;
@protocol AlgoSwitcherDelegate <NSObject>
- (void)buttonTapped:(AlgoSwitcher*)algoSwitcher;
@end

@interface AlgoSwitcher : UIViewController
@property(nonatomic, assign)id<AlgoSwitcherDelegate> delegate;
@property(nonatomic, assign)ImageReconizer* imageReconizer;
@property (retain, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)DoneTaped:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UILabel *currentFDetector;
@end
