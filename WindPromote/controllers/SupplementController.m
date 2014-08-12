//
//  SupplementController.m
//  WindPromote
//
//  Created by Zombie on 8/7/14.
//  Copyright (c) 2014 Xcqwan. All rights reserved.
//

#import "SupplementController.h"

@interface SupplementController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation SupplementController

- (IBAction)updateName:(id)sender {
    [[self nameTextField] resignFirstResponder];
    NSString * name = [self nameTextField].text;
    if (name.length == 0 ) {
        [super showAlertView:@"请填写姓名!"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [super makeRequestManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:name forKey:@"name"];
    
    [super showLoadingView:true];
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:UD_ID];
    [manager PATCH:[NSString stringWithFormat:@"%@%@%@", URL_BASE, URL_USER_PROFILE, userID] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [super showLoadingView:false];
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 202) {
            [[NSUserDefaults standardUserDefaults] setValue:name forKey:UD_NAME];
            UIViewController * promoteList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"promote_list"];
            [[self navigationController] pushViewController:promoteList animated:true];
        } else {
            [super showAlertView:[NSString stringWithFormat:@"修改用户名失败, 失败码: %d", statusCode]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [super showLoadingView:false];
        NSInteger statusCode = operation.response.statusCode;
        [super showAlertView:[NSString stringWithFormat:@"网络错误, 错误码: %d", statusCode]];
    }];
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
