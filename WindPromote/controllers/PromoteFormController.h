//
//  PromoteFormController.h
//  WindPromote
//
//  Created by Zombie on 8/7/14.
//  Copyright (c) 2014 Xcqwan. All rights reserved.
//

#import "BaseController.h"
#import <CoreLocation/CoreLocation.h>

@interface PromoteFormController : BaseController<CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

@end
