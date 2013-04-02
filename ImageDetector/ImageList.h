 //
//  ImageList.h
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageList : NSObject
+ (ImageList*)sharedImageList;
- (UIImage*)imageAtIndex:(NSUInteger)idx;
@property(nonatomic, retain, readonly)NSMutableArray* imageList;
@end
