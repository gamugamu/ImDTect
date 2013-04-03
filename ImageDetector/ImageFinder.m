//
//  ImageFinder.m
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import "ImageFinder.h"
#import "ImageLoader.h"

@implementation ImageFinder

+ (void)imageFromUserDocument:(void(^)(NSArray* data))completion{
    NSArray* allPAth            = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSFileManager* fileManager  = [NSFileManager defaultManager];
    NSString* basePath          = allPAth[0];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableArray* fullPath    = [NSMutableArray arrayWithCapacity: 10];
        ImageLoader* imageLoader    = [ImageLoader new];
        [imageLoader loadQueue: basePath];
        
        for(NSString* fileName in [fileManager contentsOfDirectoryAtPath: basePath error: nil]){
            if(![fileName rangeOfString:@".DSStore"].length)
                [fullPath addObject: [basePath stringByAppendingPathComponent: fileName]];
        }
        
        if (completion)
            completion(fullPath);
    });
}
@end
