//
//  ImageLoader.m
//  ImageDetector
//
//  Created by Abadie, Loïc on 03/04/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import "ImageLoader.h"
#import "JSONKit.h"

@implementation ImageLoader

#define genUrl(fileName)\
    [NSURL URLWithString: [basePath stringByAppendingPathComponent: fileName]]

- (void)loadQueue:(NSString*)fileToSave{
    NSString* basePath = @"http://www.adobie.fr/imageReco/";
    // 1 on charge l'url
    NSData* jsonList    = [NSData dataWithContentsOfURL: genUrl(@"list.json")];
    NSArray* list       = [jsonList objectFromJSONData];
    
    // 2 depuis la liste on effecue les téléchargement vers le fichier indiqué
    for(NSString* fileName in list){
        NSData* image       = [NSData dataWithContentsOfURL: genUrl(fileName)];
        NSString* filePath  = [fileToSave stringByAppendingPathComponent: fileName];
        [image writeToFile: filePath atomically: YES];
    }
}

@end
