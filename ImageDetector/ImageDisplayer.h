//
//  ImageDisplayer.h
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDisplayer : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *image;
@property(nonatomic, assign)BOOL isSelected;
@end
