//
//  Mediator.m
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import "Mediator.h"
#import "ImageDisplayer.h"
#import "ImageListVC.h"
#import "ImageList.h"
#import "CompareImages.h"
#import "FLANNDetector.h"
#import "UIImage+OpenCV.h"

@interface Mediator()<ImageListVCDelegate>
@property(nonatomic, retain)ImageDisplayer*     displayer_0;
@property(nonatomic, retain)ImageDisplayer*     displayer_1;
@property(nonatomic, retain)ImageListVC*        imageList;
@property(nonatomic, retain)CompareImages*      compareImages;
@property(nonatomic, assign)ImageList*          allImage;
@end

@implementation Mediator
@synthesize displayer_0     = _displayer_0,
            displayer_1     = _displayer_1,
            imageList       = _imageList,
            allImage        = _allImage,
            compareImages   = _compareImages;

#define insertController_(co, size)\
    [controller addChildViewController: co];\
    co.view.center = size;\
    [controller.view addSubview: co.view];

#pragma mark -------------------------- public ---------------------------------
#pragma mark -------------------------------------------------------------------

#pragma mark - public

- (void)manageControllerIntoMain:(UIViewController*)controller{
    insertController_(_displayer_0, ((CGPoint){200, 200}));
    insertController_(_displayer_1, ((CGPoint){600, 200}));
    insertController_(_imageList, ((CGPoint){900, 200}));
    insertController_(_compareImages, ((CGPoint){350, 540}));
}

#pragma mark - ImageListDelegate

- (void)imageSelected:(NSUInteger)idx{
    static ImageDisplayer* lastDisplayer = nil;
    static int switcher         = 0;
    
    ImageDisplayer* displayer   = (++switcher % 2)? _displayer_0 : _displayer_1;
    lastDisplayer.isSelected    = NO;
    displayer.isSelected        = YES;
    displayer.image.image       = [_allImage imageAtIndex: idx];
    lastDisplayer               = displayer;
 
    // si les deux controllers possèdent chacun une image, alors on lance
    // l'analyse
    [self detectImagesMatch: _displayer_0.image.image
               withImageTwo: _displayer_1.image.image];
}

#pragma mark alloc / dealloc

- (id)init{
    if(self = [super init]){
        [self setUp];
    }
    return self;
}

- (void)dealloc{
    [_displayer_0   release];
    [_displayer_1   release];
    [_imageList     release];
    [_compareImages  release];
    [super dealloc];
}

#pragma mark -------------------------- private --------------------------------
#pragma mark -------------------------------------------------------------------

#pragma mark - setUp

- (void)setUp{
    _displayer_0    = [[ImageDisplayer alloc] initWithNibName: @"ImageDisplayer" bundle: nil];
    _displayer_1    = [[ImageDisplayer alloc] initWithNibName: @"ImageDisplayer" bundle: nil];
    _imageList      = [[ImageListVC alloc] initWithNibName: @"ImageListVC" bundle: nil];
    _compareImages  = [[CompareImages alloc] initWithNibName: @"CompareImages" bundle: nil];
    _allImage       = [ImageList sharedImageList];
    
    [_imageList makeSmallImage: [[ImageList sharedImageList] imageList]];
    _imageList.delegate = self;
}

#pragma mark - display

// compare 2 images grace au FLANN et renvoie le résultat en image. Le résultat
// sera affiché dans le controller "_compareImage"
- (void)detectImagesMatch:(UIImage*)imageOne withImageTwo:(UIImage*)imageTwo{
    if(imageOne && imageTwo){
        timeFLANNlapsed timeStat;
        cv::Mat imageDetected           = detectWithFlann([imageOne CVMat], [imageTwo CVMat], &timeStat);
        _compareImages.imageView.image  = [UIImage imageWithCVMat: imageDetected];
        
        [self displayTimeStat: &timeStat];
    }
}

- (void)displayTimeStat:(timeFLANNlapsed*)stat{

}

@end
