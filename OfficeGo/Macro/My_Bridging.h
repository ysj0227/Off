//
//  My_Bridging.h
//  OfficeGo
//
//  Created by DENGFei on 2020/5/8.
//  Copyright © 2020 Senwei. All rights reserved.
//

#ifndef My_Bridging_h
#define My_Bridging_h

#import <UMCommon/UMCommon.h> // 导入这个是重点 不然没法注册
// U-Share核心SDK
#import <UMShare/UMShare.h>

// U-Share分享面板SDK，未添加分享面板SDK可将此行去掉
#import <UShareUI/UShareUI.h>

#import "SegmentPageHead.h"
#import "MLMSegmentScroll.h"
#import "MLMSegmentManager.h"

//历史记录cell的layout
#import "UICollectionViewLeftAlignedLayout.h"

//日历
#import "FSCalendar.h"

//融云
#import <RongIMKit/RongIMKit.h>

#endif /* My_Bridging_h */
