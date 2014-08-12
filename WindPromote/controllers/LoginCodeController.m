//
//  LoginCodeController.m
//  WindPromote
//
//  Created by Zombie on 8/7/14.
//  Copyright (c) 2014 Xcqwan. All rights reserved.
//

#import "LoginCodeController.h"

@interface LoginCodeController ()

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@end

@implementation LoginCodeController

- (IBAction)checkCode:(id)sender {
    [[self codeTextField] resignFirstResponder];
    NSString * code = [self codeTextField].text;
    if (code.length != 6) {
        [super showAlertView:@"请输入6位验证码"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [super makeRequestManager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:_tel forKey:@"tel"];
    [params setObject:code forKey:@"login_code"];
    
    [super showLoadingView:true];
    [manager POST:[NSString stringWithFormat:@"%@%@", URL_BASE, URL_LOGIN] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [super showLoadingView:false];
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 201) {
            NSString *token = [responseObject objectForKey:@"token"];
            NSString *userID = [responseObject objectForKey:@"id"];
            [self getUserProfile:token userID:userID];
        } else {
            [super showAlertView:[NSString stringWithFormat:@"验证失败, 错误码: %d", statusCode]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [super showLoadingView:false];
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 422) {
            [super showAlertView:@"验证码错误, 请重新输入"];
        } else {
            [super showAlertView:[NSString stringWithFormat:@"网络错误, 错误码: %d", statusCode]];
        }
    }];
}

- (IBAction)resendCode:(id)sender {
    [[self codeTextField] resignFirstResponder];
    
    AFHTTPRequestOperationManager *manager = [super makeRequestManager];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:_tel forKey:@"tel"];
    
    [super showLoadingView:true];
    [manager POST:[NSString stringWithFormat:@"%@%@", URL_BASE, URL_SENDCODE] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [super showLoadingView:false];
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 204) {
            [super showAlertView:@"验证码发送成功"];
            [self countDownResendButton];
        } else {
            [super showAlertView:@"验证码发送失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [super showLoadingView:false];
        [super showAlertView:@"网络错误"];
    }];
}

- (IBAction)back:(id)sender{
    [self navigationBack];
}

- (void)getUserProfile: (NSString *)token userID:(NSString *)userID
{
    AFHTTPRequestOperationManager *manager = [super makeRequestManager];
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@", URL_BASE, URL_USER_PROFILE, userID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *name = [responseObject objectForKey:@"name"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:token forKey:UD_TOKEN];
        [userDefaults setObject:userID forKey:UD_ID];
        [userDefaults setObject:_tel forKey:UD_TEL];
        if ([name isEqualToString:[NSString stringWithFormat:@"user%@", userID]]) {
            UIViewController * supplement = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"supplement"];
            [[self navigationController] pushViewController:supplement animated:true];
        } else {
            [userDefaults setObject:name forKey:UD_NAME];
            UIViewController * promoteList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"promote_list"];
            [[self navigationController] pushViewController:promoteList animated:true];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [super showAlertView:@"网络错误"];
    }];
}

- (void)countDownResendButton
{
    __block NSInteger timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 1) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self resendButton] setTitle:@"重新发送" forState:UIControlStateNormal];
                [self resendButton].backgroundColor = [UIColor blueColor];
                [self resendButton].userInteractionEnabled = true;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self resendButton] setTitle:[NSString stringWithFormat:@"重新发送 (%d秒)", timeout] forState:UIControlStateNormal];
                [self resendButton].backgroundColor = [UIColor grayColor];
                [self resendButton].userInteractionEnabled = false;
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
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
    [self warningLabel].text = [NSString stringWithFormat:@"验证码已发送至您的手机 %@", _tel];
    [self countDownResendButton];
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
