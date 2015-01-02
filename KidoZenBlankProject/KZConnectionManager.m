//
//  KidoZenConnectionManager.m
//  KidoZenBlankProject
//
//  Created by KidoZen Inc on 6/30/14.
//  Copyright (c) 2014 KidoZen. All rights reserved.
//

#import "KZConnectionManager.h"
#import "KZResponse.h"
#import "KZApplication.h"

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

    self.kzApp = [[KZApplication alloc] initWithTenantMarketPlace:KidoZenAppCenterUrl
                                                   applicationName:KidoZenAppName
                                                    applicationKey:KidoZenAppSDKKey
                                                         strictSSL:NO
                                                       andCallback:^(KZResponse * response) {
                                                           if (response.response!=nil) {
                                                               //Enable Crash Reports:
                                                               [self.kzApp enableCrashReporter];
                                                               [self conectionSuccessfulWithResponse:response];
                                                           }else {
                                                               NSLog(@"**** ERROR MESSAGE: Unable to reach the kidozen server. Make sure your KidoZenAppCenterUrl and KidoZenAppName are correct");
                                                           }
                                                       }];

    
}

- (void)conectionSuccessfulWithResponse:(KZResponse*)response{
    
    _kzResponse = response;
    
    if ([delegate respondsToSelector:@selector(conectionSuccessfulWithResponse:)])
    {
        [delegate conectionSuccessfulWithResponse:response];
    }
}

@end
