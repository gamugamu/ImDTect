//
//  ImageLoistViewController.m
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import "ImageListVC.h"
#import "ImageResize.h"

@interface ImageListVC ()
@property(nonatomic, retain)NSMutableArray* miniImageList;
@end

@implementation ImageListVC
@synthesize miniImageList   = _miniImageList,
            delegate        = _delegate;

#pragma mark -------------------------- public ---------------------------------
#pragma mark -------------------------------------------------------------------

#pragma mark - public

- (void)makeSmallImage:(NSArray* /*UIImages*/)list{
    self.miniImageList = [NSMutableArray array];

    for(UIImage* image in list){
        UIImage* mini = [ImageResize reduceImage: image size: CGSizeMake(70, 70)];
        [_miniImageList addObject: mini];
    }
    
    [(UITableView*)self.view reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _miniImageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text     = @"errr";
    cell.imageView.image    = _miniImageList[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_delegate respondsToSelector: @selector(imageSelected:)]){
        [_delegate imageSelected: indexPath.row];
    }
}

#pragma mark - alloc / dealloc

- (void)dealloc{
    [_miniImageList release];
    [super dealloc];
}

#pragma mark -------------------------- private --------------------------------
#pragma mark -------------------------------------------------------------------

@end
