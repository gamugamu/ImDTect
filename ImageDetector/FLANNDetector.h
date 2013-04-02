//
//  FLANNDetector.h
//  ImageDetector
//
//  Created by Abadie, Loïc on 02/04/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#ifndef __ImageDetector__FLANNDetector__
#define __ImageDetector__FLANNDetector__

#include <iostream>

struct timeFLANNlapsed{
    float time_extracted_image_0;
    float time_extracted_image_1;
    float time_FlannMatcher;
    float time_DrawGoodMatch;
    float time_DetectCorner;
    BOOL didFindMatch;
};

cv::Mat detectWithFlann(cv::Mat image, cv::Mat image2, timeFLANNlapsed* timeStat);

#endif /* defined(__ImageDetector__FLANNDetector__) */
