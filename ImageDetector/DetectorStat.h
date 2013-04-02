//
//  TimeImageDetectorStat.h
//  ImageDetector
//
//  Created by Abadie, Loïc on 02/04/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetectorStat : UIViewController
- (void)clearOutput;
@property (retain, nonatomic) IBOutlet UILabel *ext_0;
@property (retain, nonatomic) IBOutlet UILabel *ext_1;
@property (retain, nonatomic) IBOutlet UILabel *flann_Det;
@property (retain, nonatomic) IBOutlet UILabel *display_GM;
@property (retain, nonatomic) IBOutlet UILabel *corner_det;
@end
