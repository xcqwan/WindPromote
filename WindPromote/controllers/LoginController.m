//
//  LoginController.m
//  WindPromote
//
//  Created by Zombie on 8/7/14.
//  Copyright (c) 2014 Xcqwan. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@property (weak, nonatomic) IBOutlet UITextField *telTextField;

@end

@implementation LoginController

- (IBAction)sendCode:(id)sender {
    [[self telTextField] resignFirstResponder];
    NSString *tel = [self telTextField].text;
    if (tel.length != 11) {
        [super showAlertView:@"请填写正确的手机号码"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [super makeRequestManager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:tel forKey:@"tel"];
    
    [super showLoadingView:true];
    [manager POST:[NSString stringWithFormat:@"%@%@", URL_BASE, URL_SENDCODE] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [super showLoadingView:false];
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 204) {
            LoginCodeController * logincode = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login_code"];
            logincode.tel = tel;
            [[self navigationController] pushViewController:logincode animated:true];
        } else {
            [super showAlertView:[NSString stringWithFormat:@"验证码发送失败, 失败码: %d", statusCode]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [super showLoadingView:false];
        NSInteger statusCode = operation.response.statusCode;
        [super showAlertView:[NSString stringWithFormat:@"网络错误, 错误码: %d", statusCode]];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:UD_TOKEN];
    NSString *name = [userDefaults stringForKey:UD_NAME];
    
    if (token != nil) {
        //已登录
        if (name != nil) {
            //已填写姓名
            UIViewController * promoteList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"promote_list"];
            [[self navigationController] pushViewController:promoteList animated:true];
        } else {
            //未填写姓名
            UIViewController * supplement = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"supplement"];
            [[self navigationController] pushViewController:supplement animated:true];
        }
    } else {
        //未登录
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
