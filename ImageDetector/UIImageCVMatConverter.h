//
//  UIImageCVMathConverter.h
//  OpenCVClient
//
//  Created by Abadie, Loïc on 21/01/13.
//  Copyright (c) 2013 Aptogo Limited. All rights reserved.
//

//
//  UIImageCVMatConverter.h
//

#import <Foundation/Foundation.h>

@interface UIImageCVMatConverter : NSObject {
	
}

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat withUIImage:(UIImage*)image;
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+ (UIImage *)scaleAndRotateImageFrontCamera:(UIImage *)image;
+ (UIImage *)scaleAndRotateImageBackCamera:(UIImage *)image;

@end
