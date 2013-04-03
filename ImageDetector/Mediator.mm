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
#import "DetectorStat.h"
#import "UIImage+OpenCV.h"
#import "AlgoSwitcher.h"
#import "FTSimpleAnimation.h"

@interface Mediator()<ImageListVCDelegate, ImageDisplayerDelegate, AlgoSwitcherDelegate>{
    ImageDisplayer* currentSelectedDisplayer;
    ImageReconizer* imageReconizer_;
}
@property(nonatomic, retain)ImageDisplayer*         displayer_0;
@property(nonatomic, retain)ImageDisplayer*         displayer_1;
@property(nonatomic, retain)ImageListVC*            imageList;
@property(nonatomic, retain)CompareImages*          compareImages;
@property(nonatomic, retain)DetectorStat*           timeStat;
@property(nonatomic, retain)AlgoSwitcher*           algoSwitcher;
@property(nonatomic, assign)ImageList*              allImage;
@end

@implementation Mediator
@synthesize displayer_0     = _displayer_0,
            displayer_1     = _displayer_1,
            imageList       = _imageList,
            allImage        = _allImage,
            compareImages   = _compareImages,
            timeStat        = _timeStat,
            maincontroller  = _maincontroller,
            algoSwitcher    = _algoSwitcher;

#define insertController_(co, size)\
    [_maincontroller addChildViewController: co];\
    co.view.center = size;\
    [_maincontroller.view insertSubview: co.view atIndex: 0];

#define floatToNSString(floatInput)\
    [NSString stringWithFormat:@"%f", floatInput];

#pragma mark -------------------------- public ---------------------------------
#pragma mark -------------------------------------------------------------------

#pragma mark - ImageListDelegate

- (void)imageSelected:(NSUInteger)idx{
    currentSelectedDisplayer.image.image = [_allImage imageAtIndex: idx];
 
    // si les deux controllers possèdent chacun une image, alors on lance
    // l'analyse
    [self detectImagesMatch: _displayer_0.image.image
               withImageTwo: _displayer_1.image.image];
}

#pragma mark - ImageDisplayerDelegate

- (void)imageDisplayerChanged:(ImageDisplayer*)displayer{
    ImageDisplayer* displayOff = (displayer == _displayer_0)? _displayer_1 : _displayer_0;
    
    if(displayer.isSelected){
        currentSelectedDisplayer = displayer;
        displayOff.isSelected = NO;
    }else
        currentSelectedDisplayer = displayOff;
}

#pragma mark - AlgoSwitcherDelegate

#define addBlackScreen()\
    UIView* blackScreen = [[_maincontroller view] viewWithTag: 30];\
    [FTSimpleAnimation makeBlackScreenAppearing: blackScreen];

#define removeBlackScreen()\
    UIView* blackScreen = [[_maincontroller view] viewWithTag: 30];\
    [FTSimpleAnimation makeBlackScreenDisappearing: blackScreen];

- (void)buttonTapped:(AlgoSwitcher *)algoSwitcher{
    [_algoSwitcher.view removeFromSuperview];
    [_algoSwitcher removeFromParentViewController];
    removeBlackScreen();
}

#pragma mark - implicitDelegate

- (void)buttonTaped{
    addBlackScreen();
    _algoSwitcher.view.center = (CGPoint){500, 400};
    [_maincontroller.view addSubview: _algoSwitcher.view];
    [_maincontroller addChildViewController: _algoSwitcher];
}

#pragma mark - getter / setter

- (void)setMaincontroller:(UIViewController *)maincontroller{
    if(_maincontroller != maincontroller){
        [_maincontroller autorelease];
         _maincontroller = [maincontroller autorelease];
        
        addBlackScreen();
        if([maincontroller respondsToSelector: @selector(setButtonDelegate:)])
            [maincontroller performSelector: @selector(setButtonDelegate:) withObject: self];
    }
}

#pragma mark alloc / dealloc

- (id)init{
    if(self = [super init]){
        [self setUp];
    }
    return self;
}

- (void)dealloc{
    [_displayer_0       release];
    [_displayer_1       release];
    [_imageList         release];
    [_compareImages     release];
    [_maincontroller    release];
    [_algoSwitcher      release];
    delete imageReconizer_;
    [super dealloc];
}

#pragma mark -------------------------- private --------------------------------
#pragma mark -------------------------------------------------------------------

#pragma mark - setUp

- (void)setUp{
    [self setUpImageReconizer];
    [[ImageList sharedImageList] getImageList:^(NSArray *list) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            removeBlackScreen();
            [self setController: list];
        });
    }];
}

- (void)setController:(NSArray*)listImage{
    _displayer_0    = [[ImageDisplayer alloc] initWithNibName: @"ImageDisplayer" bundle: nil];
    _displayer_1    = [[ImageDisplayer alloc] initWithNibName: @"ImageDisplayer" bundle: nil];
    _imageList      = [[ImageListVC alloc] initWithNibName: @"ImageListVC" bundle: nil];
    _compareImages  = [[CompareImages alloc] initWithNibName: @"CompareImages" bundle: nil];
    _timeStat       = [[DetectorStat alloc] initWithNibName: @"DetectorStat" bundle: nil];
    _allImage       = [ImageList sharedImageList];
    _algoSwitcher   = [[AlgoSwitcher alloc] initWithNibName: @"AlgoSwitcher" bundle: nil];
    _imageList.delegate     = self;
    _displayer_0.delegate   = self;
    _displayer_1.delegate   = self;
    _algoSwitcher.delegate  = self;
    _algoSwitcher.imageReconizer = imageReconizer_;
    
    [_imageList makeSmallImage: listImage];
    [self manageControllerIntoMain];
}

- (void)setUpImageReconizer{
    imageReconizer_ = new ImageReconizer;
}

#pragma mark - display

- (void)manageControllerIntoMain{
    insertController_(_displayer_0, ((CGPoint){200, 200}));
    insertController_(_displayer_1, ((CGPoint){600, 200}));
    insertController_(_imageList, ((CGPoint){900, 250}));
    insertController_(_compareImages, ((CGPoint){350, 540}));
    insertController_(_timeStat, ((CGPoint){850, 600}));
}

// compare 2 images grace au FLANN et renvoie le résultat en image. Le résultat
// sera affiché dans le controller "_compareImage"
- (void)detectImagesMatch:(UIImage*)imageOne withImageTwo:(UIImage*)imageTwo{
    if(imageOne && imageTwo){
        // comme le calcul est long, on affiche une attente.
        [_timeStat clearOutput];
        addBlackScreen();
        
        // le calcul est fait en tâche de fond. 
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L),^{
            __block timeFLANNlapsed timeStat;
            __block cv::Mat imageDetected = imageReconizer_->detectWithFlann([imageOne CVMat], [imageTwo CVMat], &timeStat);
            
            // puis l'affichage se fait depuis la main thread.
            dispatch_async(dispatch_get_main_queue(),^{
                _compareImages.imageView.image  = [UIImage imageWithCVMat: imageDetected];
                [self displayTimeStat: &timeStat];
                removeBlackScreen();
            });
        });
    }
}

- (void)displayTimeStat:(timeFLANNlapsed*)stat{
    _timeStat.ext_0.text        = floatToNSString(stat->time_extracted_image_0);
    _timeStat.ext_1.text        = floatToNSString(stat->time_extracted_image_1);
    _timeStat.flann_Det.text    = floatToNSString(stat->time_FlannMatcher);
    _timeStat.display_GM.text   = floatToNSString(stat->time_DrawGoodMatch);
    _timeStat.corner_det.text   = floatToNSString(stat->time_DetectCorner);
    [_timeStat didImageMatche: stat->didFindMatch];
}

@end
