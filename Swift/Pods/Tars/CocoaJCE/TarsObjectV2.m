/**
 * Tencent is pleased to support the open source community by making Tars available.
 *
 * Copyright (C) 2016THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use this file except 
 * in compliance with the License. You may obtain a copy of the License at
 *
 * https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software distributed 
 * under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the 
 * specific language governing permissions and limitations under the License.
 */

//
//  TarsObjectV2.m
//
//  Created by 壬俊 易 on 12-3-13.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import "TarsObjectV2.h"
#import "TarsInputStream.h"
#import "TarsOutputStream.h"
#import <objc/runtime.h>

#pragma mark - TarsPair (V2)

@interface TarsPair (V2)

+ (id)analyzeExtStr:(NSString *)str;
+ (TarsPair *)pairFromExtStr:(NSString *)str;

@end

@implementation TarsPair (V2)

+ (id)analyzeExtStr:(NSString *)str
{
    unichar flag = [str characterAtIndex:0];
    switch (flag) {
        case 'V': {
            id value = nil;
            value = [TarsPair analyzeExtStr:[str substringFromIndex:1]];
            return [TarsPair pairWithValue:value forKey:nil];
        }
        case 'M': {
            id key = nil, value = nil;
            unichar l = 0;
            l = [str substringWithRange:NSMakeRange(1, 2)].intValue;
            key = [TarsPair analyzeExtStr:[str substringWithRange:NSMakeRange(3, l)]];
            value = [TarsPair analyzeExtStr:[str substringFromIndex:(3 + l)]];
            return [TarsPair pairWithValue:value forKey:key];
        }
        case 'O':
            return NSClassFromString([str substringFromIndex:1]);
        default:
            ASSERT_TRHOW_WS_EXCEPTION(0);
            return nil;
    }
}

+ (TarsPair *)pairFromExtStr:(NSString *)str
{
    ASSERT_TRHOW_WS_EXCEPTION([str length] < 128);
    id pair = [self analyzeExtStr:str];
    ASSERT_TRHOW_WS_EXCEPTION([pair isKindOfClass:[TarsPair class]]);
    return pair;
}

@end

#pragma mark - TarsPropertyInfo

@interface TarsPropertyInfo : NSObject

@property (nonatomic, assign) NSInteger tag;    // index
@property (nonatomic, assign) BOOL flag;        // required
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) TarsPair *ext;     // for vector & map

+ (id)propertyInfo;
- (NSComparisonResult)compareWithTag:(TarsPropertyInfo *)obj;

@end

@implementation TarsPropertyInfo

@synthesize tag;
@synthesize flag;
@synthesize name;
@synthesize type;
@synthesize ext;

+ (id)propertyInfo
{
    return [[self alloc] init];
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}


- (NSComparisonResult)compareWithTag:(TarsPropertyInfo *)obj
{
    if (self.tag < obj.tag)
        return NSOrderedAscending;
    else if (self.tag == obj.tag)
        return NSOrderedSame;
    return NSOrderedDescending;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"{\n"
            @"    tag      : %d\n"
            @"    required : %d\n"
            @"    name     : %@\n"
            @"    type     : %@\n"
            @"    ext      : %@\n"
            @"}\n", self.tag, self.flag, self.name, self.type, self.ext];
}

@end

#pragma mark - TarsObjectV2

static NSMutableDictionary *tarsv2_class_props_descriptions;

@interface TarsObjectV2 ()

- (TarsObjectV2 *)tarsRefObject;
- (NSDictionary *)tarsPropsDescription;

@end

@implementation TarsObjectV2

+ (NSString *)tarsType
{
    return nil;
}

- (NSString *)tarsType
{
    return [[self class] tarsType];
}

- (TarsObjectV2 *)tarsRefObject
{
#define KAssociatedObjectKeyTarsRefObject @"AssociatedObjectKeyTarsRefObject"
    // INFO:renjunyi 建议改用dispatch_once语法，而不用synchronized，只支持4.0以上的系统
    @synchronized (KAssociatedObjectKeyTarsRefObject) {
        if (objc_getAssociatedObject([self class], KAssociatedObjectKeyTarsRefObject) == nil) {
            TarsObjectV2 *refObject = [[[self class] alloc] init];
            objc_setAssociatedObject([self class], KAssociatedObjectKeyTarsRefObject, refObject, OBJC_ASSOCIATION_RETAIN);
        }
    }
    return objc_getAssociatedObject([self class], KAssociatedObjectKeyTarsRefObject);
}

- (NSDictionary *)tarsPropsDescription
{
    NSMutableDictionary *propsDescription = nil;
    @synchronized(@"WirelessUnifiedProtocolSerializableTarsObjectV2") {
        if (tarsv2_class_props_descriptions == nil)
            tarsv2_class_props_descriptions = [[NSMutableDictionary alloc] init];
        ASSERT_TRHOW_WS_EXCEPTION(tarsv2_class_props_descriptions != nil);
        
        NSString* className = NSStringFromClass([self class]);
        if ((propsDescription = tarsv2_class_props_descriptions[className]) == nil) 
        {
            NSDictionary *props = [[self class] tarsPropertiesWithEncodedTypes];
            propsDescription = [NSMutableDictionary dictionaryWithCapacity:[props count]];
            tarsv2_class_props_descriptions[className] = propsDescription;
            for (__strong NSString *propName in props) 
            {
                if ([propName hasPrefix:JV2_PROP_LFX_STR]) {
                    TarsPropertyInfo *propInfo = [TarsPropertyInfo propertyInfo];
                    propInfo.type = props[propName];
                    
                    NSRange spRange = [propName rangeOfString:TARSV2_PROPERTY_NAME_SP];
                    if (spRange.location != NSNotFound) {
                        propInfo.ext = [TarsPair pairFromExtStr:[propName substringFromIndex:(spRange.location + spRange.length)]];
                        propName = [propName substringToIndex:spRange.location];
                    }
                    
                    NSArray *strs = [propName componentsSeparatedByString:@"_"];
                    ASSERT_TRHOW_WS_EXCEPTION([strs count] >= 5);
                    propInfo.tag = [strs[2] integerValue];
                    propInfo.flag = [strs[3] isEqualToString:@"r"];
                    propInfo.name = [NSString stringWithFormat:@"%@%@", JV2_PROP_NFX_STR, strs[4]];
                    for (int i = 5; i < strs.count; i++)
                        propInfo.name = [propInfo.name stringByAppendingString:[NSString stringWithFormat:@"%@%@", @"_", strs[i]]];
                    propsDescription[@(propInfo.tag)] = propInfo;
                }
            }
        }
        return propsDescription;
    }
}

- (void)__pack:(TarsOutputStream *)stream
{
	@autoreleasepool {
        NSDictionary *description = [self tarsPropsDescription];
        ASSERT_TRHOW_WS_EXCEPTION(description != nil);
        
        NSArray *keys = [description keysSortedByValueUsingSelector:@selector(compareWithTag:)];
        for (NSNumber* key in keys) 
        {
            TarsPropertyInfo *propInfo = description[key];
            
            // 关于类型编码，请参看《Object-C Runtime Programming Guide》的“Type Encodings”部分
            id theProperty = [self valueForKey:propInfo.name];
            id refProperty = [self tarsRefObject];
            if (propInfo.flag == YES || (theProperty != nil && [theProperty isEqual:refProperty] == NO))
            {
                switch ([propInfo.type characterAtIndex:0])
                {
                    case 'B':   // bool
                    case 'c':   // char
                    case 'C':   // unsigned char
                    case 's':   // short
                    case 'S':   // unsigned short
                    case 'i':   // int
                    case 'I':   // unsigned int
                    case 'l':   // long
                    case 'L':   // unsigned long
                    case 'q':   // long long
                        [stream writeInt:[theProperty longLongValue] tag:propInfo.tag];
                        break;
                    case 'f':   // float
                        [stream writeFloat:[theProperty floatValue] tag:propInfo.tag];
                        break;
                    case 'd':   // double
                        [stream writeDouble:[theProperty doubleValue] tag:propInfo.tag];
                        break;
                    case '@':   // objects
                        [stream writeAnything:theProperty tag:propInfo.tag required:propInfo.flag];
                        break;
                    default:
                        ASSERT_TRHOW_WS_EXCEPTION(0);
                        break;
                }
            }
        }
	}
}

- (void)__unpack:(TarsInputStream *)stream
{
	@autoreleasepool {
        NSDictionary *description = [self tarsPropsDescription];
        ASSERT_TRHOW_WS_EXCEPTION(description != nil);
        
        NSArray *keys = [description keysSortedByValueUsingSelector:@selector(compareWithTag:)];
        for (NSNumber* key in keys) 
        {
            TarsPropertyInfo *propInfo = description[key];
            
            // 关于类型编码，请参看《Object-C Runtime Programming Guide》的“Type Encodings”部分
            switch ([propInfo.type characterAtIndex:0]) 
            {
                case 'B':   // bool
                case 'c':   // char
                case 'C':   // unsigned char
                case 's':   // short
                case 'S':   // unsigned short
                case 'i':   // int
                case 'I':   // unsigned int
                case 'l':   // long
                case 'L':   // unsigned long
                case 'q':   // long long
                case 'f':   // float
                case 'd':   // double
                {
                    NSNumber *value = [stream readNumber:propInfo.tag required:propInfo.flag];
                    if (value != nil)
                        [self setValue:value forKey:propInfo.name];
                    break;
                }
                case '@':   // objects
                {
                    Class cls = NSClassFromString([propInfo.type substringWithRange:NSMakeRange(2, [propInfo.type length] - 3)]);
                    id value = [stream readAnything:propInfo.tag required:propInfo.flag description:(propInfo.ext != nil ? propInfo.ext : cls)];
                    if (value != nil) {
                        ASSERT_TRHOW_WS_EXCEPTION([[value class] isSubclassOfClass:cls]);
                        [self setValue:value forKey:propInfo.name];
                    }
                    break;
                }
                default:
                    ASSERT_TRHOW_WS_EXCEPTION(0);
                    break;
            }
        }
	}
}


@end
