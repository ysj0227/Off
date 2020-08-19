//
// SAVisualizedUtils.h
// SensorsAnalyticsSDK
//
// Created by 储强盛 on 2020/3/3.
// Copyright © 2020 Sensors Data Co., Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAVisualizedUtils : NSObject

/// 判断一个 view 是否被覆盖
+ (BOOL) isCoveredForView:(UIView *)view;

/// 解析构造 web 元素
+ (NSArray *)analysisWebElementWithWebView:(WKWebView *)webView;

///  获取 RN 当前页面信息
+ (NSDictionary <NSString *, NSString *>*)currentRNScreenVisualizeProperties;
@end

NS_ASSUME_NONNULL_END
