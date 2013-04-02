//
//  ImageFinder.m
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import "ImageFinder.h"

@implementation ImageFinder

+ (NSArray*)imageFromUserDocument{
    NSArray* allPAth            = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSFileManager* fileManager  = [NSFileManager defaultManager];
    NSString* basePath          = allPAth[0];
    NSMutableArray* fullPath    = [NSMutableArray arrayWithCapacity: 10];

    for(NSString* fileName in [fileManager contentsOfDirectoryAtPath: basePath error: nil]){
        if(![fileName rangeOfString:@".DSStore"].length)
            [fullPath addObject: [basePath stringByAppendingPathComponent: fileName]];
    }
    NSLog(@"Document Path %@", allPAth[0]);

    return fullPath;
}
@end
