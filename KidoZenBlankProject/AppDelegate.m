//
//  AppDelegate.m
//  KidoZenBlankProject
//
//  Created by KidoZen Inc on 6/30/14.
//  Copyright (c) 2014 KidoZen. All rights reserved.
//

#import "AppDelegate.h"
#import "KZLoginViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Launching Login View Controller.
    KZLoginViewController *login = [[KZLoginViewController alloc]initWithNibName:@"KZLoginViewController" bundle:nil];
    self.window.rootViewController = login;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
