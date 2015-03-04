//
//  KZLoginViewController.m
//  KidoZenBlankProject
//
//  Created by Carlos Ovalles on 9/2/14.
//  Copyright (c) 2014 KidoZen. All rights reserved.
//

#import "KZLoginViewController.h"
#import "KZConnectionManager.h"
#import "KZVendorViewController.h"
#import "KZResponse.h"
#import "KZApplication.h"
#import "KZAnalytics.h"

#define KidoZenProvider @"Kidozen"
#define KidoZenUser @"public@kidozen.com"

@interface KZLoginViewController () <UITextFieldDelegate,KZConnectionManagerDelegate>
@property (nonatomic,strong) KZConnectionManager *kidoZenConector;
@property (nonatomic,strong) KZResponse *kzResponse;

@end

@implementation KZLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _kidoZenConector = [KZConnectionManager sharedKZConnectionManager];
    _kidoZenConector.delegate = self;

}

- (void)conectionSuccessfulWithResponse:(KZResponse *)response{
    
    self.kzResponse = response;
}

- (IBAction)authUser:(id)sender{
    
    KZApplication *kzApplication = _kzResponse.application;
    
    __weak KZLoginViewController *safeMe = self;
    
    [kzApplication authenticateWithChallenge:@"challenge"
                                    provider:@"Good"
                                  completion:^(id c) {
                                      
                                      if (c) {
                                          
                                          NSString *user= [c description];
                                          if(![user hasPrefix:@"Error"])
                                          {
                                              NSLog(@"The User IS authenticated");
                                              
                                              [_kzResponse.application enableAnalytics];
                                              [_kzResponse.application.analytics setSessionSecondsTimeOut:2];
                                              [_kzResponse.application.analytics setUploadMaxSecondsThreshold:10];
                                              
                                              KZVendorViewController * vendorVC = [[KZVendorViewController alloc]init];
                                              
                                              UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vendorVC];
                                              
                                              [vendorVC setNavController:navVC];
                                              safeMe.view.window.rootViewController = navVC;
                                              
                                          }
                                          else
                                          {
                                              NSLog(@"The user authentication Failed!");
                                          }
                                      }
                                  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
