//
//  ImageList.m
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import "ImageList.h"
#import "SynthesizeSingleton.h"
#import "ImageFinder.h"

@interface ImageList()
@property(nonatomic, copy)void(^imageRequest)(NSArray* list);
@property(nonatomic, assign)BOOL isRequestingList;
@property(nonatomic, retain)NSMutableArray* imageList;
@end

@implementation ImageList
@synthesize imageList           = _imageList,
            imageRequest        = _imageRequest,
            isRequestingList    = _isRequestingList;

#pragma mark -------------------------- public ---------------------------------
#pragma mark -------------------------------------------------------------------

#pragma mark - public

- (UIImage*)imageAtIndex:(NSUInteger)idx{
    return [_imageList objectAtIndex: idx];
}

- (void)getImageList:(void(^)(NSArray* list))list{
    if(_isRequestingList){
        self.imageRequest = list;
    }else if(list){
        list(_imageList);
    }
}

#pragma mark - alloc / dealloc

- (id)init{
    if(self = [super init]){
        _isRequestingList = YES;

        [ImageFinder imageFromUserDocument:^(NSArray *data) {
            [self getAllList: data];
        }];
    }
    return self;
}

- (void)dealloc{
    [_imageList release];
    [super dealloc];
}

#pragma  mark - singleton

SYNTHESIZE_SINGLETON_FOR_CLASS(ImageList);

#pragma mark -------------------------- private --------------------------------
#pragma mark -------------------------------------------------------------------

- (void)getAllList:(NSArray*)list{
    self.imageList = [NSMutableArray array];
        
    for (NSString* path in list) {
        UIImage* image = [UIImage imageWithContentsOfFile: path];

        if(image)
            [_imageList addObject: image];
    }
    
    _isRequestingList = NO;
    
    if(_imageRequest){
        _imageRequest(_imageList);
    }
}

@end
