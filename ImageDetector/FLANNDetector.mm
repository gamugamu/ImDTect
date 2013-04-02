//
//  FLANNDetector.cpp
//  ImageDetector
//
//  Created by Abadie, Loïc on 02/04/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#include "FLANNDetector.h"

using namespace cv;
using namespace std;

// global

static double t;
static void startTimeMesurement();
static double outputTimeMesurement();
static bool shapeIsSquare(std::vector<Point2f> points /* 4 */);

Mat detectWithFlann(Mat image, Mat image2, timeFLANNlapsed* timeStat){
    timeStat->didFindMatch = false;
    printf("------------------\n");
    
    // convertit les images en niveau de gris.
    Mat img_1; cvtColor(image, img_1, CV_BGR2GRAY);
    Mat img_2; cvtColor(image2, img_2, CV_BGR2GRAY);
    
    //-- Detection des points clès avec le SURF Detector.    
    MserFeatureDetector detector;

    std::vector<KeyPoint> keypoints_1, keypoints_2;
    
    detector.detect( img_1, keypoints_1 );
    detector.detect( img_2, keypoints_2 );
    
    //-- Step 2: Calculate descriptors (feature vectors)
    SurfDescriptorExtractor extractor;
    
    Mat descriptors_1, descriptors_2;
    
    startTimeMesurement();
    extractor.compute( img_1, keypoints_1, descriptors_1 );
    timeStat->time_extracted_image_0 = outputTimeMesurement();
    
    startTimeMesurement();
    extractor.compute( img_2, keypoints_2, descriptors_2 );
    timeStat->time_extracted_image_1 = outputTimeMesurement();

    //-- Step 3: Matching descriptor vectors using FLANN matcher
    startTimeMesurement();
    FlannBasedMatcher matcher;
    std::vector< DMatch > matches;
    matcher.match( descriptors_1, descriptors_2, matches );
    
    double max_dist         = 0;
    double min_dist         = 100;
    double isSameEqualZero  = 0;
    
    //-- Quick calculation of max and min distances between keypoints
    for( int i = 0; i < descriptors_1.rows; i++ ){
        double dist     = matches[i].distance;
        isSameEqualZero += dist;
        
        if( dist < min_dist )
            min_dist = dist;
        
        if( dist > max_dist )
            max_dist = dist;
    }
    
    timeStat->time_FlannMatcher = outputTimeMesurement();
    
    //-- Draw only "good" matches (i.e. whose distance is less than 2*min_dist )
    //-- PS.- radiusMatch can also be used here.
        startTimeMesurement();
        std::vector< DMatch > good_matches;
    
        for( int i = 0; i < descriptors_1.rows; i++ ){
            if( matches[i].distance < 3*min_dist )
                good_matches.push_back( matches[i]);
        }
    
        //-- Draw only "good" matches
        Mat img_matches;
        drawMatches( img_1, keypoints_1, img_2, keypoints_2,
                    good_matches, img_matches, Scalar::all(-1), Scalar::all(-1),
                    vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
    
    if(isSameEqualZero){
        //-- Localize the object
        std::vector<Point2f> obj;
        std::vector<Point2f> scene;
   

        for( int i = 0; i < good_matches.size(); i++ ){
            //-- Get the keypoints from the good matches
            obj.push_back( keypoints_1[good_matches[i].queryIdx ].pt );
            scene.push_back( keypoints_2[ good_matches[i].trainIdx ].pt );
        }
    
        timeStat->time_DrawGoodMatch = outputTimeMesurement();

        startTimeMesurement();
    
        Mat H = findHomography( obj, scene, CV_RANSAC );
    
        //-- Get the corners from the image_1 ( the object to be "detected" )
        std::vector<Point2f> obj_corners(4);
        obj_corners[0] = cvPoint(0,0);
        obj_corners[1] = cvPoint( img_1.cols, 0 );
        obj_corners[2] = cvPoint( img_1.cols, img_1.rows );
        obj_corners[3] = cvPoint( 0, img_1.rows );
        std::vector<Point2f> scene_corners(4);
    
        perspectiveTransform( obj_corners, scene_corners, H);
    
        // Si on peut former une zone de points réciproques alors les deux
        // images correspondent.
        timeStat->didFindMatch = shapeIsSquare(scene_corners);
    
        //-- Draw lines between the corners (the mapped object in the scene - image_2 )
        line( img_matches, scene_corners[0] + Point2f( img_1.cols, 0), scene_corners[1] + Point2f( img_1.cols, 0), Scalar(0, 255, 0), 4 );
        line( img_matches, scene_corners[1] + Point2f( img_1.cols, 0), scene_corners[2] + Point2f( img_1.cols, 0), Scalar( 0, 255, 0), 4 );
        line( img_matches, scene_corners[2] + Point2f( img_1.cols, 0), scene_corners[3] + Point2f( img_1.cols, 0), Scalar( 0, 255, 0), 4 );
        line( img_matches, scene_corners[3] + Point2f( img_1.cols, 0), scene_corners[0] + Point2f( img_1.cols, 0), Scalar( 0, 255, 0), 4 );
    
        timeStat->time_DetectCorner = outputTimeMesurement();
    
  /*  for( int i = 0; i < good_matches.size(); i++ )
        printf( "-- Good Match [%d] Keypoint 1: %d  -- Keypoint 2: %d  \n", i, good_matches[i].queryIdx, good_matches[i].trainIdx );
    */    
    }else
        timeStat->didFindMatch = YES;
        
    return img_matches;
}

static bool shapeIsSquare(std::vector<Point2f> points /* 4 */){
    int tolerance = 10;
    int x1 = points[0].x;
    int x2 = points[1].x;
    int x3 = points[2].x;
    int x4 = points[3].x;

    int y1 = points[0].y;
    int y2 = points[1].y;
    int y3 = points[2].y;
    int y4 = points[3].y;
    
    printf("%i %i %i %i \n", x1, x2, x3, x4);
    printf("%i %i %i %i \n", y1, y2, y3, y4);
    
    printf("eval %i %i\n", x1 - x2, y3 - y4);
    // si les points sont trop rapprochés, ce n'est pas un rectangle.

    if(abs(x1 - x2) < tolerance && abs(y3 - y4) < tolerance)
        return false;
    
    // plus le resultat est proche de zero, plus on a affaire à un rectangle
    

    printf("RESULT x:%i y:%i\n", (x1 - x2) - (x4 - x3), (y1 - y2) - (y4 - y3));
    
    return  abs((x1 - x2) - (x4 - x3)) < tolerance &&
            abs((y1 - y2) - (y4 - y3)) < tolerance;
}

// détection du temps
static void startTimeMesurement(){
    t = (double)getTickCount();
}


static double outputTimeMesurement(){
    t = ((double)getTickCount() - t)/getTickFrequency();
    return t;
}