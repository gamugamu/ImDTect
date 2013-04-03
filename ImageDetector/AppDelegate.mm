//
//  AppDelegate.m
//  ImageDetector
//
//  Created by Abadie, Loïc on 29/03/13.
//  Copyright (c) 2013 Abadie, Loïc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Mediator.h"

@interface AppDelegate()
@property(nonatomic, retain)Mediator* mediator;
@end

@implementation AppDelegate
@synthesize mediator = _mediator;

#pragma mark -------------------------- public ---------------------------------
#pragma mark -------------------------------------------------------------------

#pragma mark - UIApplication delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    _mediator           = [Mediator new];
    self.window         = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    
    _mediator.maincontroller = _viewController;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationLandscapeLeft;
}

#pragma mark - alloc / dealloc

- (void)dealloc{
    [_mediator          release];
    [_window            release];
    [_viewController    release];
    [super dealloc];
}

#pragma mark -------------------------- private --------------------------------
#pragma mark -------------------------------------------------------------------

@end
