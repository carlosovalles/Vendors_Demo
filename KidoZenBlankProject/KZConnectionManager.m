//
//  KidoZenConnectionManager.m
//  KidoZenBlankProject
//
//  Created by KidoZen Inc on 6/30/14.
//  Copyright (c) 2014 KidoZen. All rights reserved.
//
//  This class instantiates and keeps a singleton object that mantains the application object as a public var in the project.


#import "KZConnectionManager.h"
#import "KZResponse.h"
#import "KZApplication.h"

//  Replace with your Kidozen Instance Info:
#define KidoZenAppCenterUrl @"https://public.kidocloud.com"
#define KidoZenAppName @"msdynamics"
#define KidoZenAppSDKKey @"DvDx2zbxzRgdlbK0A9CqKEfcI5c5LKNyCJ6VGHVJIVE="



@interface KZConnectionManager ()
@property (nonatomic,strong) KZApplication *kzApp;
@end


@implementation KZConnectionManager
@synthesize delegate;

+ (id)sharedKZConnectionManager {
    static KZConnectionManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        
    [self connectToKidoZenServices];
        
    }
    
    return self;
}

- (void)connectToKidoZenServices
{

    /*********************************************************************************
     STEP 1: Create Application object and initial handshake with KidoZen Platform
     self.kzApp will be the 
     
     *********************************************************************************/
    self.kzApp = [[KZApplication alloc] initWithTenantMarketPlace:KidoZenAppCenterUrl
                                                  applicationName:KidoZenAppName
                                                   applicationKey:KidoZenAppSDKKey
                                                        strictSSL:NO
                                                      andCallback:^(KZResponse * response) {

                                                          if (response.response!=nil) {
                                                              /***************************************
                                                               STEP 1a: Enable crash reports
                                                               ***************************************/
                                                              [self.kzApp enableCrashReporter];
                                                              
                                                              /***************************************
                                                               STEP 1b: Enable analytics
                                                               ***************************************/
                                                              [self.kzApp enableAnalytics];
                                                              
                                                              // Delegating back the application object as a response.
                                                              [self conectionSuccessfulWithResponse:response];
                                                              
                                                          }else {
                                                              NSLog(@"**** ERROR MESSAGE: Unable to reach the kidozen server. Make sure your KidoZenAppCenterUrl and KidoZenAppName are correct.");
                                                          }
                                                      }];
    

    
}

- (void)conectionSuccessfulWithResponse:(KZResponse*)response{
    
    // _kzResponse
    _kzResponse = response;
    
    if ([delegate respondsToSelector:@selector(conectionSuccessfulWithResponse:)])
    {
        [delegate conectionSuccessfulWithResponse:response];
    }
}

@end
