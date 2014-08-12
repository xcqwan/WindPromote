//
//  PromoteListController.m
//  WindPromote
//
//  Created by Zombie on 8/7/14.
//  Copyright (c) 2014 Xcqwan. All rights reserved.
//

#import "PromoteListController.h"

@interface PromoteListController ()

@property int page;

@property (weak, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoteCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *promoteListTableView;

@end

@implementation PromoteListController
@synthesize dataArray;

- (IBAction)showPromoteHint:(id)sender {
    UIViewController * promoteHint = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"promote_hint"];
    [[self navigationController] pushViewController:promoteHint animated:true];
}

- (IBAction)logout:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:UD_ID];
    [userDefaults removeObjectForKey:UD_NAME];
    [userDefaults removeObjectForKey:UD_TEL];
    [userDefaults removeObjectForKey:UD_TOKEN];
    
    UIViewController * login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
    [[self navigationController] pushViewController:login animated:true];
}

- (IBAction)addPromote:(id)sender {
    UIViewController * promoteForm = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"promote_form"];
    [[self navigationController] pushViewController:promoteForm animated:true];
}

- (void)headRefresh
{
    self.page = 1;
    [self requestData:[NSString stringWithFormat:@"%d", self.page]];
}

- (void)footerLoad
{
    self.page++;
    [self requestData:[NSString stringWithFormat:@"%d", self.page]];
}

- (void)requestData:(NSString *)page
{
    AFHTTPRequestOperationManager *manager = [super makeRequestManager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:page forKey:@"page"];
    [params setObject:CS_PAGE_COUNT forKey:@"count"];
    
    [manager GET:[NSString stringWithFormat:@"%@%@", URL_BASE, URL_SHOP] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger statusCode = operation.response.statusCode;
        if (statusCode == 200) {
            if ([page intValue] == 1) {
                [dataArray removeAllObjects];
            }
            for (id item in responseObject) {
                [dataArray addObject:item];
            }
            [[self promoteListTableView] reloadData];
        } else {
            [super showAlertView:[NSString stringWithFormat:@"拉取数据失败, 失败码: %d", statusCode]];
        }
        [[self promoteListTableView] headerEndRefreshing];
        [[self promoteListTableView] footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[self promoteListTableView] headerEndRefreshing];
        [[self promoteListTableView] footerEndRefreshing];
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults stringForKey:UD_NAME];
    NSString *tel = [userDefaults stringForKey:UD_TEL];
    
    [self userInfoLabel].text = [NSString stringWithFormat:@"推广人: %@  %@", name, tel];
    
    dataArray = [[NSMutableArray alloc]init];
    [self promoteListTableView].delegate = self;
    [self promoteListTableView].dataSource = self;
    [self promoteListTableView].separatorStyle = UITableViewCellSeparatorStyleNone;
    [[self promoteListTableView] registerNib:[UINib nibWithNibName:@"PromoteCell" bundle:nil] forCellReuseIdentifier:@"promotecell"];
    
    [[self promoteListTableView] addHeaderWithTarget:self action:@selector(headRefresh)];
    [[self promoteListTableView] addFooterWithTarget:self action:@selector(footerLoad)];
    
    [[self promoteListTableView] headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PromoteCell *cell = [[self promoteListTableView] dequeueReusableCellWithIdentifier:@"promotecell" forIndexPath:indexPath];
    NSInteger index = indexPath.row;
    NSDictionary *data = dataArray[index];
    cell.data = data;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
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
