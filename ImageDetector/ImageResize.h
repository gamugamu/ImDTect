//
//  CropImage.h
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageResize : NSObject
+ (UIImage*)reduceImage:(UIImage*)image size:(CGSize)size;
@end
