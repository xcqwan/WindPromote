//
//  PromoteListController.h
//  WindPromote
//
//  Created by Zombie on 8/7/14.
//  Copyright (c) 2014 Xcqwan. All rights reserved.
//

#import "BaseController.h"
#import "PromoteCell.h"

@interface PromoteListController : BaseController<UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *dataArray;

@end
