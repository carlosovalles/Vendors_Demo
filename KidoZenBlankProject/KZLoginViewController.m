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


#define KidoZenProvider @"Kidozen"
#define KidoZenUser @"public@kidozen.com"

@interface KZLoginViewController () <UITextFieldDelegate,KZConnectionManagerDelegate>
@property (nonatomic,strong) KZConnectionManager *kidoZenConector;
@property (nonatomic,strong) KZResponse *kzResponse;
@property (nonatomic,strong) IBOutlet UITextField *mailTextField;
@property (nonatomic,strong) IBOutlet UITextField *passTextField;
@property (nonatomic,strong) IBOutlet UIView *loginComponent;

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
    
    
    // Activity indicator to show UI element while waiting for user authentication server-responce.
    UIActivityIndicatorView * waitingGear = [[UIActivityIndicatorView alloc]initWithFrame:self.view.bounds];
    [waitingGear startAnimating];
    [waitingGear setBackgroundColor:[UIColor colorWithWhite:0 alpha:.7]];
    [self.view addSubview:waitingGear];
    [_passTextField resignFirstResponder];
    
    
    [_kzResponse.application authenticateUser:_mailTextField.text
                                 withProvider:@"Kidozen"
                                  andPassword:_passTextField.text
                                   completion:^(id c) {
                                       if (c) {
                                           
                                           NSString *user= [c description];
                                           if(![user hasPrefix:@"Error"])
                                           {
                                             NSLog(@"The User IS authenticated");

                                               [_kzResponse.application enableAnalytics];
                                               KZVendorViewController * vendorVC = [[KZVendorViewController alloc]init];
                                            
                                               UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vendorVC];

                                              [vendorVC setNavController:navVC];
                                               self.view.window.rootViewController = navVC;
    
                                           }
                                           else
                                           {
                                               
                                               NSLog(@"The user authentication Failed!");

                                           }
                                           
                                           [waitingGear stopAnimating];
                                           [waitingGear removeFromSuperview];
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
