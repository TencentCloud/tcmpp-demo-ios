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
//  TarsObject.m
//
//  Created by godwin.guo on 11-9-29. Modified by renjunyi on 11-12-1.
//  Copyright (c) 2011年 Tencent. All rights reserved.
//

#import "TarsObject.h"
#import "objc/runtime.h"
#import "TarsInputStream.h"
#import "TarsOutputStream.h"

@implementation TarsObject

+ (NSDictionary *)tarsPropertiesWithEncodedTypes
{
	NSMutableDictionary *theProps = [NSMutableDictionary dictionary];
	objc_property_t *propList = class_copyPropertyList([self class], nil);
	for (int i = 0; propList[i] != nil; i++) {
		objc_property_t oneProp = propList[i];
		NSString *propName = @(property_getName(oneProp));
		NSString *attrs = @(property_getAttributes(oneProp));
		if ([attrs rangeOfString:@",R,"].location == NSNotFound) {
			NSArray *attrParts = [attrs componentsSeparatedByString:@","];
			if (attrParts != nil && [attrParts count] > 0) {
                NSString *propType = [attrParts[0] substringFromIndex:1];
                theProps[propName] = propType;
			}
		}
	}
	free(propList);
	return theProps;
}

+ (id)object
{
    return [[self alloc] init];
}

+ (id)fromData:(NSData *)data
{
    if ([data length] != 0) 
        return [[[self alloc] init] fromData:data];
    return nil;
}

- (id)fromData:(NSData *)data
{
    if ([data length] != 0)
    {
        @try {
            TarsInputStream *stream = [TarsInputStream streamWithData:data];
            [self __unpack:stream];
            return self;
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    return nil;
}

- (NSData *)toData
{
    NSData* data = nil;
    TarsOutputStream *stream = [[TarsOutputStream alloc] init];
    @try {
        [self __pack:stream];
        data = [stream data];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        stream = nil;
    }
    return data;
}

+ (NSString *)tarsType
{
    return nil;
}

- (NSString *)tarsType
{
    return [[self class] tarsType];
}

- (void)__pack:(TarsOutputStream *)stream
{
    ASSERT_TRHOW_WS_EXCEPTION(NO);
}

- (void)__unpack:(TarsInputStream *)stream
{
    ASSERT_TRHOW_WS_EXCEPTION(NO);
}


static NSString *genTab(int indentNum)
{
    NSMutableString* indentM =  [[NSMutableString alloc] init];
    for(int i=0;i<indentNum;i++)
    {
        [indentM appendString:@"    "];
    }
    return indentM;
}


- (NSString *)description
{
    static int desc_indent=0;
    
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendString:@"\r"];
    [description appendString:genTab(desc_indent)];
    [description appendString:@"{\r"];
    
    desc_indent++;
    
    NSDictionary *props = [[self class] tarsPropertiesWithEncodedTypes];
    for (NSString *propName in props)
    {
        [description appendString:genTab(desc_indent)];
        NSString *propType = props[propName];
        if ([propType isEqualToString:@"i"] ||  // int
            [propType isEqualToString:@"I"] ||  // unsigned int
            [propType isEqualToString:@"l"] ||  // long
            [propType isEqualToString:@"L"] ||  // usigned long
            [propType isEqualToString:@"q"] ||  // long long
            [propType isEqualToString:@"Q"] ||  // unsigned long long
            [propType isEqualToString:@"s"] ||  // short
            [propType isEqualToString:@"S"] ||  // unsigned short
            [propType isEqualToString:@"B"] ||  // bool or _Bool
            [propType isEqualToString:@"f"] ||  // float
            [propType isEqualToString:@"d"] ||  // double
            [propType isEqualToString:@"c"] ||  // char
            [propType isEqualToString:@"C"] )   // unsigned char
            [description appendFormat:@"%@: %@\r", propName, [[self valueForKey:propName] stringValue]];
        else if ([propType hasPrefix:@"@"])     // Object
            [description appendFormat:@"%@: %@\r", propName, [self valueForKey:propName]];
        else                                    // error
            [description appendFormat:@"%@: ???\r", propName];
    }
    
    desc_indent--;
    [description appendString:genTab(desc_indent)];
    [description appendString:@"}\r"];
    return description;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{    
    [aCoder encodeDataObject:[self toData]];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        [self fromData:[aDecoder decodeDataObject]];
    }
    return self;
}

@end
