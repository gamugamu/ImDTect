//
//  ImageLoistViewController.h
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageListVCDelegate <NSObject>
- (void)imageSelected:(NSUInteger)idx;
@end

@interface ImageListVC : UITableViewController
@property(nonatomic, assign)id<ImageListVCDelegate> delegate;
- (void)makeSmallImage:(NSArray* /*UIImages*/)list;
@end
