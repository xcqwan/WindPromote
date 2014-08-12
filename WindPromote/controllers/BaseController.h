//
//  BaseController.h
//  WindPromote
//
//  Created by Zombie on 8/7/14.
//  Copyright (c) 2014 Xcqwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <RZSquaresLoading.h>
#import "Constant.h"

@interface BaseController : UIViewController

- (id)makeRequestManager;
- (void)showAlertView:(NSString *)message;
- (void)navigationBack;
- (void)showLoadingView:(BOOL)isShow;
@end
