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
@property (nonatomic,strong) UITextField *mailTextField;
@property (nonatomic,strong) UITextField *passTextField;
@property (nonatomic,strong) KZResponse *kzResponse;
@property (nonatomic,strong) UIView *loginComponent;

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
    
    UIImage *backGround = [UIImage imageNamed:@"appBG"];
    
    NSParameterAssert(backGround);
    UIImageView * bg = [[UIImageView alloc]initWithImage:backGround];
    [self.view addSubview:bg];

}

- (void)conectionSuccessfulWithResponse:(KZResponse *)response{
    
    self.kzResponse = response;
    if(!_loginComponent){
        [self setUpView];
    }
    
}

- (void) setUpView{
    
    self.loginComponent = [[UIView alloc]initWithFrame: CGRectMake(0, 80, self.view.bounds.size.width, 280)];
    [self.view addSubview:_loginComponent];
    
    UIImage *mailIcon = [UIImage imageNamed:@"emailIcon"];
    UIImageView * mI = [[UIImageView alloc]initWithImage:mailIcon];
    [mI setFrame:CGRectMake(12, 95, 40, 40)];
    [_loginComponent addSubview:mI];

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 53)];
    
    
    self.mailTextField = [[UITextField alloc]initWithFrame:CGRectMake(62, 88, 244, 53)];
    [_mailTextField setBackgroundColor:[UIColor colorWithWhite:1 alpha:.25]];
    _mailTextField.leftView = paddingView;
    _mailTextField.leftViewMode = UITextFieldViewModeAlways;
    [_mailTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]];
//    _mailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"user@email.com" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:.9 alpha:.9]}];
//    _mailTextField.delegate = self;
    _mailTextField.tag =01;
    _mailTextField.returnKeyType = UIReturnKeyNext;
    _mailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _mailTextField.text = @"public@kidozen.com";

    _mailTextField.textColor = [UIColor whiteColor];
    [_loginComponent addSubview:_mailTextField];
    
    UILabel * loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 49, self.view.bounds.size.width-20, 40)];
    [loginLabel setText:@"Login:"];
    [loginLabel setBackgroundColor:[UIColor clearColor]];
    [loginLabel setTextColor:[UIColor colorWithWhite:1 alpha:.7]];
    [loginLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:16]];
    [_loginComponent addSubview:loginLabel];

    
    UIImage *passIcon = [UIImage imageNamed:@"passIcon"];
    UIImageView * pI = [[UIImageView alloc]initWithImage:passIcon];
    [pI setFrame:CGRectMake(12, 175, 40, 40)];
    [_loginComponent addSubview:pI];

    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 53)];

    self.passTextField = [[UITextField alloc]initWithFrame:CGRectMake(62, 170, 244, 53)];
    [_passTextField setBackgroundColor:[UIColor colorWithWhite:1 alpha:.25]];
    _passTextField.leftView = paddingView2;
    _passTextField.leftViewMode = UITextFieldViewModeAlways;
    [_passTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
//    _passTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:.9 alpha:.8]}];
    _passTextField.delegate = self;
    _passTextField.returnKeyType = UIReturnKeyGo;
    _passTextField.tag =02;
    _passTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passTextField.secureTextEntry = YES;
    _passTextField.textColor = [UIColor whiteColor];
    _passTextField.text = @"pass#1";
    [_loginComponent addSubview:_passTextField];
    
    UILabel * verLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 524, 123, 40)];
    [verLabel setText:@"Ver. 1.0.1.0"];
    [verLabel setBackgroundColor:[UIColor clearColor]];
    [verLabel setTextColor:[UIColor colorWithWhite:1 alpha:.7]];
    [verLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:10]];
    [self.view addSubview:verLabel];
    
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


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag == 01){

        [_mailTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
        [UIView animateWithDuration:.2 animations:^{
            _loginComponent.transform = CGAffineTransformMakeTranslation(0, -20);
        }];
    }else if(textField.tag == 02){
        [_passTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
        [UIView animateWithDuration:.2 animations:^{
            _loginComponent.transform = CGAffineTransformMakeTranslation(0, -50);
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 0) {
        if(textField.tag == 01){
            if ([string isEqualToString:@"\n"]) {
                [textField resignFirstResponder];
                [_passTextField becomeFirstResponder];
            }

        }else if(textField.tag == 02){
            if ([string isEqualToString:@"\n"]) {
                [self authenticateUser];
            }
        }
    }
    return YES;
}

- (void) authenticateUser{
    
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
//                                               NSLog(@"The User IS authenticated");

                                               //Enable Analytics:
                                               [_kzResponse.application enableAnalytics];
                                               KZVendorViewController * vendorVC = [[KZVendorViewController alloc]init];
                                            
                                               UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vendorVC];

                                              [vendorVC setNavController:navVC];
                                               self.view.window.rootViewController = navVC;

                                               
                                           }
                                           else
                                           {
                                           
                                           }
                                           
                                           [waitingGear stopAnimating];
                                           [waitingGear removeFromSuperview];
                                       }
                                   }];
}


@end
