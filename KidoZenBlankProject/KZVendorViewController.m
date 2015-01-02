//
//  AZVendorViewController.m
//  KidoZenBlankProject
//
//  Created by Carlos Ovalles on 9/3/14.
//  Copyright (c) 2014 KidoZen. All rights reserved.
//

#import "KZVendorViewController.h"
#import "KZConnectionManager.h"
#import "KZDataSource.h"
#import "KZResponse.h"
#import "Colors.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

static NSString * const cellReuseId = @"cellReuseId";

@interface KZVendorViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MKMapViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIImageView * azIcon;
@property (nonatomic,strong) NSMutableArray * vendorsDataSource;
@property (nonatomic,strong) UIButton * createNewContact;
@property (nonatomic,retain) UITextField *contactName;
@property (nonatomic,retain) UITextField *contactLastName;
@property (nonatomic,retain) UIButton *close ;
@property (nonatomic,retain) UIToolbar *tb;
@property (nonatomic,retain) UIView *addContactView;
@property (nonatomic,retain) UIView *moreInfoView;
@property (nonatomic,retain) NSDictionary *weatherResponse;
@property (nonatomic,retain) UILabel * weatherLbl;
@property (nonatomic,retain) UILabel * weatherCityLbl;
@end

@implementation KZVendorViewController

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
    self.view.backgroundColor= [UIColor blackColor];
    self.title = @"Dynamics's List";
    [self.navController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navController.navigationBar setBarTintColor:[UIColor colorWithWhite:1 alpha:1]];


//    Weather Label
    
    _weatherCityLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 60, 30)];

    _weatherCityLbl.font =[UIFont fontWithName:@"HelveticaNeue-Medium" size:11];
    _weatherCityLbl.text = @"City, --";
    _weatherCityLbl.backgroundColor = [UIColor clearColor];
    _weatherCityLbl.textColor = [UIColor blackColor];
    

    _weatherLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 60, 30)];
    //    weatherLbl.text = [NSString stringWithFormat:@"telephone: %@", [[[r.response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"phoneNumber"]];
    _weatherLbl.font =[UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    _weatherLbl.text = @"--℉";
    _weatherLbl.backgroundColor = [UIColor clearColor];
    _weatherLbl.textColor = [UIColor blackColor];
    
    
    UIImage * vcBGImage = [UIImage imageNamed:@"inAppBG"];
    NSParameterAssert(vcBGImage);
    UIImageView * vcBG = [[UIImageView alloc]initWithImage:vcBGImage];
    [vcBG setFrame:CGRectMake(0, 51, self.view.bounds.size.width, self.view.bounds.size.height-51)];
    [self.view addSubview:vcBG];
    
    _createNewContact = [UIButton buttonWithType:UIButtonTypeCustom];
    [_createNewContact addTarget:self action:@selector(addNewContact) forControlEvents:UIControlEventTouchUpInside];
    [_createNewContact setImage:[UIImage imageNamed:@"addContacts"] forState:UIControlStateNormal];
    [_createNewContact setFrame:CGRectMake(272, 19, 40, 40)];

    
    
    
    
    KZDatasource *ds = [[[KZConnectionManager sharedKZConnectionManager] kzResponse].application DataSourceWithName:@"dynamicsGetContacts2"];
    
    [ds Query:^(KZResponse *r) {
        NSLog(@"Response: %@",r.response);
        if ([[r.response objectForKey:@"data"] count] > 0){
        
            _vendorsDataSource = (NSMutableArray*)[[[r.response objectForKey:@"data"] reverseObjectEnumerator] allObjects];

            [self setUpVendorTableView];
        }
        
    }];

    
    KZDatasource *weatherDS = [[[KZConnectionManager sharedKZConnectionManager] kzResponse].application DataSourceWithName:@"getCityWeatherByZIP"];
    NSString *jsonString = @"{\"ZipCode\":\"10001\"}";
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    [weatherDS QueryWithData: myDictionary completion:^(KZResponse *r) {
        NSLog(@"Response: %@",r.response);
        _weatherResponse = [r.response objectForKey:@"data"];
        _weatherLbl.text = [NSString stringWithFormat:@"%@℉",[_weatherResponse objectForKey:@"Temperature"]];
        _weatherCityLbl.text = [NSString stringWithFormat:@"%@, %@",[_weatherResponse objectForKey:@"City"],[_weatherResponse objectForKey:@"State"]];
    }];
    
}

- (void) showDataViz{
    
    [[[KZConnectionManager sharedKZConnectionManager] kzResponse].application  tagClick:@"Show DataViz"];
    
    [[[KZConnectionManager sharedKZConnectionManager] kzResponse].application showDataVisualizationWithName:@"myProductsViz" success:^{
            // Success code.
        } error:^(NSError *error) {
            // Handle error as you like.
        }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navController.view addSubview:_azIcon];
    [self.navController.view addSubview:_weatherLbl];
        [self.navController.view addSubview:_weatherCityLbl];
    [self.navController.view addSubview:_createNewContact];
}

- (void) setUpVendorTableView{
    if (!_tableView)
    {  
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, self.view.bounds.size.width, self.view.bounds.size.height-66) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;;
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        _tableView.clipsToBounds=YES;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseId];
        [_tableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.allowsMultipleSelectionDuringEditing = NO;
        [self.view addSubview:_tableView];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        
        KZDatasource *ds = [[[KZConnectionManager sharedKZConnectionManager] kzResponse].application DataSourceWithName:@"dynamicsDeleteContact"];
        NSString *jsonString = [NSString stringWithFormat:@"{\"idNumber\":\"%@\"}", [[[[_vendorsDataSource objectAtIndex:indexPath.row] objectForKey:@"attributes"]objectAtIndex:1] objectForKey:@"_"]];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        [ds InvokeWithData: myDictionary completion:^(KZResponse *r) {
            NSLog(@"Response: %@",r.response);
            [_vendorsDataSource removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }];

      
    
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _vendorsDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIView *bgView;

    UILabel *nameLabel;
    UILabel *supplierID;
    UIButton *showDataViz;
    
    if (cell == nil)
    {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 71)];
        [bgView setBackgroundColor:[Colors mainInterfaceColor]];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.contentView addSubview:bgView];
        
        showDataViz = [UIButton buttonWithType:UIButtonTypeCustom];
        [showDataViz setFrame:CGRectMake(8, 15, 40, 40)];
        [showDataViz setBackgroundColor:[UIColor clearColor]];
        [showDataViz setImage:[UIImage imageNamed:@"stats"] forState:UIControlStateNormal];
        [showDataViz addTarget:self action:@selector(showDataViz) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:showDataViz];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(58, 10, 240, 30)];
        [nameLabel setTextColor:[UIColor colorWithWhite:1 alpha:.8]];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text= @"Vendor's Name";
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16]];
        [nameLabel setTag:1002];
        [cell.contentView addSubview:nameLabel];
        
        supplierID = [[UILabel alloc]initWithFrame:CGRectMake (60, 40, 300, 20)];
        supplierID.textColor = [UIColor colorWithWhite:1 alpha:.6];
        supplierID.backgroundColor = [UIColor clearColor];
        supplierID.text= @"Id:  ????????";
        [supplierID setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:12]];
        [supplierID setTag:1005];
        [cell.contentView addSubview:supplierID];
        
    } else
    {
        nameLabel = (UILabel *)[cell.contentView viewWithTag:1002];
        supplierID = (UILabel *)[cell.contentView viewWithTag:1005];
    }
  
    nameLabel.text = [[[[_vendorsDataSource objectAtIndex:indexPath.row] objectForKey:@"attributes"] objectAtIndex:0] objectForKey:@"_"];
    supplierID.text= [[[[_vendorsDataSource objectAtIndex:indexPath.row] objectForKey:@"attributes"] objectAtIndex:1] objectForKey:@"_"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_tableView setUserInteractionEnabled:NO];
    
    
    NSLog(@"%@", [tableView cellForRowAtIndexPath:indexPath]);
    UILabel *idLabel = (UILabel *)[[[tableView cellForRowAtIndexPath:indexPath] contentView] viewWithTag:1005];
    UILabel *nameLabel = (UILabel *)[[[tableView cellForRowAtIndexPath:indexPath] contentView] viewWithTag:1002];
    
    [[[KZConnectionManager sharedKZConnectionManager] kzResponse].application  tagClick:[NSString stringWithFormat:@"NEW ANALYTICS SAMPLE: %@ & id  %@",nameLabel.text,idLabel.text]];
    
    
    KZDatasource *ds = [[[KZConnectionManager sharedKZConnectionManager] kzResponse].application DataSourceWithName:@"getDynamicsExtraInfo"];
    NSString *jsonString = [NSString stringWithFormat:@"{\"id\":\"%@\"}",idLabel.text];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    [ds QueryWithData: myDictionary completion:^(KZResponse *r) {
        
        NSLog(@"Response %@",r.response);
        _moreInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, self.view.bounds.size.height-66)];
        [_moreInfoView setBackgroundColor:[UIColor colorWithWhite:0 alpha:.3]];
        [self.view addSubview:_moreInfoView];
        
        UILabel * nameLbl=[[UILabel alloc] initWithFrame:CGRectMake(12, 7, 300, 30)];
        nameLbl.text = nameLabel.text;
        nameLbl.font =[UIFont fontWithName:@"HelveticaNeue-Thin" size:16];
        nameLbl.backgroundColor = [UIColor clearColor];
        nameLbl.textColor = [UIColor whiteColor];
        [_moreInfoView addSubview:nameLbl];
        
        
        MKMapView * map = [[MKMapView alloc] initWithFrame: CGRectMake(10, 50, 300, 200)];
        map.delegate = self;
        float tmpLat = [[[[r.response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"latitude"] floatValue];
        float tmpLon = [[[[r.response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"longitude"] floatValue];

        CLLocationCoordinate2D coord = {.latitude = tmpLat , .longitude =  tmpLon};
        MKCoordinateSpan span = {.latitudeDelta =  0.06, .longitudeDelta =  0.06};
        MKCoordinateRegion region = {coord, span};
        [map setRegion:region];
        [_moreInfoView addSubview:map];
        
        UILabel * phoneLbl=[[UILabel alloc] initWithFrame:CGRectMake(12, 270, 300, 30)];
        phoneLbl.text = [NSString stringWithFormat:@"telephone: %@", [[[r.response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"phoneNumber"]];
        phoneLbl.font =[UIFont fontWithName:@"HelveticaNeue-Thin" size:16];
        phoneLbl.backgroundColor = [UIColor clearColor];
        phoneLbl.textColor = [UIColor whiteColor];
        [_moreInfoView addSubview:phoneLbl];
        
        UILabel * emailLbl=[[UILabel alloc] initWithFrame:CGRectMake(12, 290, 300, 30)];
        emailLbl.text = [NSString stringWithFormat:@"email: %@", [[[r.response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"email"]];
        emailLbl.font =[UIFont fontWithName:@"HelveticaNeue-Thin" size:15];
        emailLbl.backgroundColor = [UIColor clearColor];
        emailLbl.textColor = [UIColor whiteColor];
        [_moreInfoView addSubview:emailLbl];
        
        UITextView * moreInfo = [[UITextView alloc]initWithFrame: CGRectMake(0, 340, 320, 170)];
        moreInfo.text = [NSString stringWithFormat:@"MORE NOTES: %@", [[[r.response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"moreInfo"]];
        moreInfo.font =[UIFont fontWithName:@"HelveticaNeue-Thin" size:14.5];
        [_moreInfoView addSubview:moreInfo];
        
        UISwipeGestureRecognizer * swipeDownToClose = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeInfo)];
        [swipeDownToClose setDirection:UISwipeGestureRecognizerDirectionDown];
        [swipeDownToClose setNumberOfTouchesRequired:1];
        [_moreInfoView addGestureRecognizer:swipeDownToClose];
        
        [UIView animateWithDuration:.3 animations:^{
            _tableView.alpha=.041;
            [_createNewContact setEnabled:NO];
            [_moreInfoView setFrame:CGRectMake(0, 66, 320, self.view.bounds.size.height-66)];
        }];
        
    }];
    
}

- (void) closeInfo{
    [UIView animateWithDuration:.3 animations:^{
        self.title = @"Dynamics's List";
        [_moreInfoView setFrame:CGRectMake(0, self.view.bounds.size.height, 320, self.view.bounds.size.height-66)];
         _tableView.alpha=1;
        [_tableView setUserInteractionEnabled:YES];
            [_createNewContact setEnabled:YES];
    }completion:^(BOOL finished) {
        _moreInfoView = nil;
    }];
}


- (void) addNewContact{
    
    if (!_addContactView) {
        _addContactView = [[UIView alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height, 300, self.view.bounds.size.height-300)];
        _addContactView.backgroundColor = [Colors mainInterfaceColor];
        [self.view addSubview:_addContactView];
        UISwipeGestureRecognizer * swipeDownToClose = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeContact)];
        [swipeDownToClose setDirection:UISwipeGestureRecognizerDirectionDown];
        [swipeDownToClose setNumberOfTouchesRequired:1];
        [_addContactView addGestureRecognizer:swipeDownToClose];
    }
    
    self.contactName = [[UITextField alloc]initWithFrame:CGRectMake(20, 40, 244, 53)];
    [_contactName setBackgroundColor:[UIColor colorWithWhite:1 alpha:.25]];
    _contactName.leftViewMode = UITextFieldViewModeAlways;
    [_contactName setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]];
    _contactName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  Name" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:.9 alpha:.8]}];
    _contactName.returnKeyType = UIReturnKeyNext;
    _contactName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _contactName.textColor = [UIColor blackColor];
    [_addContactView addSubview:_contactName];

    self.contactLastName = [[UITextField alloc]initWithFrame:CGRectMake(20, 90, 244, 53)];
    [_contactLastName setBackgroundColor:[UIColor colorWithWhite:1 alpha:.25]];
    _contactLastName.leftViewMode = UITextFieldViewModeAlways;
    [_contactLastName setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18]];
    _contactLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  Last Name" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:.9 alpha:.8]}];
    _contactLastName.delegate = self;
    _contactLastName.returnKeyType = UIReturnKeyNext;
    _contactLastName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _contactLastName.textColor = [UIColor blackColor];
    [_addContactView addSubview:_contactLastName];

    
    [UIView animateWithDuration:.3 animations:^{
        [_tableView setFrame:CGRectMake(0, -self.view.bounds.size.height-80, 320, self.view.bounds.size.height)];
        self.title = @"Add Contact";
        [_createNewContact setEnabled:NO];
        _addContactView.frame = CGRectMake(10, 80, 300, self.view.bounds.size.height-360);
    }completion:^(BOOL finished) {
     [_contactName becomeFirstResponder];
    }];
    
}

- (void) closeContact{
    [UIView animateWithDuration:.3 animations:^{
        self.title = @"Dynamics's List";
        _addContactView.frame = CGRectMake(10, self.view.bounds.size.height, 300, self.view.bounds.size.height-360);
        [_tableView setFrame:CGRectMake(0, 66, 320, self.view.bounds.size.height - 66)];
    }completion:^(BOOL finished) {
        [_contactName resignFirstResponder];
        [_createNewContact setEnabled:YES];
        _contactName = nil;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [_contactName resignFirstResponder];
        [self postNewContact];
    }
    return YES;
}

- (void) postNewContact{
    
    KZDatasource *dynamicsCreateContact = [[[KZConnectionManager sharedKZConnectionManager] kzResponse].application DataSourceWithName:@"dynamicsCreateContact"];
    
    NSString *jsonString =[NSString stringWithFormat:@"{\"lastname\":\"%@\",\"name\":\"%@\"}", _contactLastName.text,_contactName.text];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    [dynamicsCreateContact InvokeWithData: myDictionary completion:^(KZResponse *r) {
        
        [self closeContact];
        _addContactView = nil;
        [_contactName resignFirstResponder];
        
        KZDatasource *dynamicsGetContacts = [[[KZConnectionManager sharedKZConnectionManager] kzResponse].application DataSourceWithName:@"dynamicsGetContacts2"];
        [dynamicsGetContacts Query:^(KZResponse *r) {
            _vendorsDataSource = (NSMutableArray*)[[[r.response objectForKey:@"data"] reverseObjectEnumerator] allObjects];
            [_tableView reloadData];
        }];
        
        KZDatasource *postMySQL = [[[KZConnectionManager sharedKZConnectionManager] kzResponse].application DataSourceWithName:@"insertDynamicsExtraInfo"];
        NSString *jsonString =
        [NSString stringWithFormat:@"{\"id\":\"%@\",\"lat\":\"25.7617\",\"long\":\"-80.1881\",\"phone\":\"+1 (305) 555 - 5555\",\"email\":\"%@.%@@email.com\",\"moreInfo\":\"Whatever Text you want to pass here\"}",[[[r.response objectForKey:@"data"]objectForKey:@"CreateResponse"] objectForKey:@"CreateResult"],[_contactName.text lowercaseString],[_contactLastName.text lowercaseString]];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        [postMySQL InvokeWithData: myDictionary completion:^(KZResponse *r) {
            NSLog(@"Response: %@",r.response);
        }];


    }];
    
    
    
    
}


@end
