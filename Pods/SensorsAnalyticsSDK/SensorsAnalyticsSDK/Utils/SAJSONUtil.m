//
//  SAJSONUtil.m
//  SensorsAnalyticsSDK
//
//  Created by 曹犟 on 15/7/7.
//  Copyright © 2015-2020 Sensors Data Co., Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif


#import "SAJSONUtil.h"
#import "SALog.h"
#import "SADateFormatter.h"

@implementation SAJSONUtil

/**
 *  @abstract
 *  把一个Object转成Json字符串
 *
 *  @param obj 要转化的对象Object
 *
 *  @return 转化后得到的字符串
 */
- (NSData *)JSONSerializeObject:(id)obj {
    id coercedObj = [self JSONSerializableObjectForObject:obj];
    NSError *error = nil;
    NSData *data = nil;
    if (![NSJSONSerialization isValidJSONObject:coercedObj]) {
        return data;
    }
    @try {
        data = [NSJSONSerialization dataWithJSONObject:coercedObj options:0 error:&error];
    }
    @catch (NSException *exception) {
        SALogError(@"%@ exception encoding api data: %@", self, exception);
    }
    if (error) {
        SALogError(@"%@ error encoding api data: %@", self, error);
    }
    return data;
}

/**
 *  @abstract
 *  在Json序列化的过程中，对一些不同的类型做一些相应的转换
 *
 *  @param obj 要处理的对象Object
 *
 *  @return 处理后的对象Object
 */
- (id)JSONSerializableObjectForObject:(id)obj {
    id newObj = [obj copy];
    // valid json types
    if ([newObj isKindOfClass:[NSString class]]) {
        return newObj;
    }
    //防止 float 精度丢失
    if ([newObj isKindOfClass:[NSNumber class]]) {
        @try {
            if ([newObj stringValue] && [[obj stringValue] rangeOfString:@"."].location != NSNotFound) {
                return [NSDecimalNumber decimalNumberWithDecimal:((NSNumber *)obj).decimalValue];
            } else {
                return newObj;
            }
        } @catch (NSException *exception) {
            return newObj;
        }
    }
    
    // recurse on containers
    if ([newObj isKindOfClass:[NSArray class]]) {
        NSMutableArray *a = [NSMutableArray array];
        for (id i in newObj) {
            [a addObject:[self JSONSerializableObjectForObject:i]];
        }
        return [NSArray arrayWithArray:a];
    }
    if ([newObj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        for (id key in newObj) {
            NSString *stringKey;
            if (![key isKindOfClass:[NSString class]]) {
                stringKey = [key description];
                SALogWarn(@"%@ warning: property keys should be strings. got: %@. coercing to: %@", self, [key class], stringKey);
            } else {
                stringKey = [NSString stringWithString:key];
            }
            id v = [self JSONSerializableObjectForObject:obj[key]];
            d[stringKey] = v;
        }
        return [NSDictionary dictionaryWithDictionary:d];
    }
    if ([newObj isKindOfClass:[NSSet class]]) {
        NSMutableArray *a = [NSMutableArray array];
        for (id i in newObj) {
            [a addObject:[self JSONSerializableObjectForObject:i]];
        }
        return [NSArray arrayWithArray:a];
    }
    // some common cases
    if ([newObj isKindOfClass:[NSDate class]]) {
        NSDateFormatter *dateFormatter = [SADateFormatter dateFormatterFromString:@"yyyy-MM-dd HH:mm:ss.SSS"];
        return [dateFormatter stringFromDate:newObj];
    }
    // default to sending the object's description
    NSString *s = [newObj description];
    SALogWarn(@"%@ warning: property values should be valid json types. got: %@. coercing to: %@", self, [newObj class], s);
    return s;
}

@end
