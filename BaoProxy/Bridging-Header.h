//
//  Bridging-Header.h
//  bao-2017-phoenix-ios
//
//  Created by Roy Hu on 12/10/2017.
//  Copyright © 2017 bao. All rights reserved.
//

#ifndef Bridging_Header_h
#define Bridging_Header_h

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#endif /* Bridging_Header_h */
