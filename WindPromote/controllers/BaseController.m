//
//  BaseController.m
//  WindPromote
//
//  Created by Zombie on 8/7/14.
//  Copyright (c) 2014 Xcqwan. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@property RZSquaresLoading *squareLoading;

@end

@implementation BaseController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)makeRequestManager
{
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:UD_TOKEN];
    if (token != nil) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"token %@", token] forHTTPHeaderField:@"Authorization"];
    }
    
    return manager;
}

- (void)showAlertView:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告!" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showLoadingView:(BOOL)isShow
{
    _squareLoading.hidden = !isShow;
}

- (void)navigationBack
{
    [[self navigationController] popViewControllerAnimated:true];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _squareLoading = [[RZSquaresLoading alloc] initWithFrame:CGRectMake(140, 264, 40, 40)];
    _squareLoading.hidden = true;
    _squareLoading.color = [UIColor redColor];
    [[self view] addSubview:_squareLoading];
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
