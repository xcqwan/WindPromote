//
//  PromoteFormController.m
//  WindPromote
//
//  Created by Zombie on 8/7/14.
//  Copyright (c) 2014 Xcqwan. All rights reserved.
//

#import "PromoteFormController.h"

@interface PromoteFormController ()

@property NSString *state;
@property NSString *city;
@property NSString *district;
@property NSString *street;
@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *reLocationButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hasOrderSegmented;
@property (weak, nonatomic) IBOutlet UIView *amountView;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIImageView *intenseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *unintenseImageView;

@end

@implementation PromoteFormController
@synthesize locationManager;

- (IBAction)submit:(id)sender {
    [self touchesBegan:nil withEvent:nil];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *address = [self locationLabel].text;
    if (address.length == 0) {
        [super showAlertView:@"请打开手机的定位功能, 否则无法提交信息。"];
        return;
    }
    NSString *name = [self nameTextField].text;
    if (name.length == 0) {
        [super showAlertView:@"请填写店铺名称"];
        return;
    }
    [params setObject:name forKey:@"name"];
    NSString *phone = [self phoneTextField].text;
    if (phone.length == 0) {
        [super showAlertView:@"请填写联系电话"];
        return;
    }
    [params setObject:phone forKey:@"phone"];
    NSInteger selectedIndex = [self hasOrderSegmented].selectedSegmentIndex;
    if (selectedIndex == -1) {
        [super showAlertView:@"请选择是否有外卖"];
        return;
    } else if (selectedIndex == 0) {
        NSString *amount = [self amountTextField].text;
        if (amount.length == 0) {
            [super showAlertView:@"请填写日均单量"];
            return;
        }
        NSNumber *boolNumber = [NSNumber numberWithBool:true];
        [params setObject:boolNumber forKey:@"is_taken_out"];
        [params setObject:amount forKey:@"daily_order_num"];
    } else {
        NSNumber *boolNumber = [NSNumber numberWithBool:false];
        [params setObject:boolNumber forKey:@"is_taken_out"];
    }
    
    NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
    [location setObject:[self state] forKey:@"state"];
    [location setObject:[self city] forKey:@"city"];
    [location setObject:[self district] forKey:@"district"];
    [location setObject:[self street] forKey:@"street"];
    
    NSNumber *nsLatitude = [[NSNumber alloc] initWithDouble:self.latitude];
    [location setObject:nsLatitude forKey:@"latitude"];
    NSNumber *nsLongitude = [[NSNumber alloc] initWithDouble:self.longitude];
    [location setObject:nsLongitude forKey:@"longitude"];
    [params setObject:location forKey:@"location"];
    
    NSNumber *nsIntense = [[NSNumber alloc] initWithBool:[self unintenseImageView].hidden];
    [params setObject:nsIntense forKey:@"interested"];
    
    NSLog(@"%@", params);
    [super showLoadingView:true];
    AFHTTPRequestOperationManager *manager = [super makeRequestManager];
    [manager POST:[NSString stringWithFormat:@"%@%@", URL_BASE, URL_SHOP] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [super showLoadingView:false];
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 201) {
            UIViewController * promoteList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"promote_list"];
            [[self navigationController] pushViewController:promoteList animated:true];
        } else {
            [super showAlertView:[NSString stringWithFormat:@"提交信息失败, 失败码: %d", statusCode]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [super showLoadingView:false];
        NSInteger statusCode = operation.response.statusCode;
        [super showAlertView:[NSString stringWithFormat:@"网络错误, 错误码: %d", statusCode]];
    }];
}

- (IBAction)back:(id)sender {
    [super navigationBack];
}

- (IBAction)reLocation:(id)sender {
    [self touchesBegan:nil withEvent:nil];
    
    [self reLocationButton].hidden = true;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
}

- (IBAction)hasOrderSelectorChange:(id)sender {
    [self touchesBegan:nil withEvent:nil];
    
    NSInteger selectedIndex = [self hasOrderSegmented].selectedSegmentIndex;
    if (selectedIndex == 0) {
        [self amountView].hidden = false;
    } else {
        [self amountView].hidden = true;
    }
}

- (IBAction)intenseClick:(id)sender {
    [self touchesBegan:nil withEvent:nil];
    
    if ([self intenseImageView].hidden ) {
        [self intenseImageView].hidden = false;
        [self unintenseImageView].hidden = true;
    } else {
        [self intenseImageView].hidden = true;
        [self unintenseImageView].hidden = false;
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locationManager.location;
    [locationManager stopUpdatingLocation];
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%f,%f", self.latitude, self.longitude] forKey:@"location"];
    [params setObject:@"json" forKey:@"output"];
    [params setObject:@"ZZDHdkFETQh1M6gA1XSVa4m4" forKey:@"ak"];
    
    AFHTTPRequestOperationManager * requestManager = [[AFHTTPRequestOperationManager alloc]init];
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/javascript"];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestManager GET:URL_BAIDU_GEO parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self reLocationButton].hidden = true;
        NSString *status = [responseObject objectForKey:@"status"];
        if (status.integerValue == 0) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            NSString *address = [result objectForKey:@"formatted_address"];
            [self locationLabel].text = address;
            
            NSDictionary *addressComponent = [result objectForKey:@"addressComponent"];
            self.state = [addressComponent objectForKey:@"province"];
            self.city = [addressComponent objectForKey:@"city"];
            self.district = [addressComponent objectForKey:@"district"];
            self.street = [NSString stringWithFormat:@"%@%@", [addressComponent objectForKey:@"street"], [addressComponent objectForKey:@"street_number"]];
        } else {
            [self reLocationButton].hidden = false;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self reLocationButton].hidden = false;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self nameTextField] resignFirstResponder];
    [[self phoneTextField] resignFirstResponder];
    [[self amountTextField] resignFirstResponder];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    [self reLocationButton].hidden = false;
    [locationManager stopUpdatingLocation];
}

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
    // Do any additional setup after loading the view.
    [self amountView].hidden = true;
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self reLocation:nil];
    } else {
        [self reLocationButton].hidden = false;
    }
    [self intenseImageView].hidden = true;
    [self unintenseImageView].hidden = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
