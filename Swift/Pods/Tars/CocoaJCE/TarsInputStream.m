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
//  TarsInputStream.m
//
//  Created by 壬俊 易 on 12-1-13.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import "TarsInputStream.h"
#import "TarsObject.h"

static u32 unpack_8(u8* val8, u8* src)
{
	*val8 =*src;
	return 1;
}

static u32 unpack_16(u16* val16, u8* src)
{
#if __LITTLE_ENDIAN
	*val16 = (((u16)src[1]) << 8) | ((u16)src[0]);
#else	
	*val16 = (((u16)src[0]) << 8) | ((u16)src[1]);
#endif
	return 2;
}

static u32 unpack_32(u32* val32, u8* src)
{
#if __LITTLE_ENDIAN
	*val32 = (((unsigned long)src[3]) << 24) | 
    (((unsigned long)src[2]) << 16) |
    (((unsigned long)src[1]) << 8) |
    ((unsigned long)src[0]);
#else
	*val32 = (((unsigned long)src[0]) << 24) |
    (((unsigned long)src[1]) << 16) |
    (((unsigned long)src[2]) << 8) |
    ((unsigned long)src[3]);
#endif
	return 4;
}

static u32 unpack_64(u64* val64, u8* src)
{
#if __LITTLE_ENDIAN
    *val64 = (((unsigned long long)src[7]) << 56) |
    (((unsigned long long)src[6]) << 48) |
    (((unsigned long long)src[5]) << 40) |
    (((unsigned long long)src[4]) << 32) |
    (((unsigned long long)src[3]) << 24) |
    (((unsigned long long)src[2]) << 16) |
    (((unsigned long long)src[1]) << 8) |
    ((unsigned long long)src[0]);
#else
    *val64 = (((unsigned long long)src[0]) << 56) |
    (((unsigned long long)src[1]) << 48) |
    (((unsigned long long)src[2]) << 40) |
    (((unsigned long long)src[3]) << 32) |
    (((unsigned long long)src[4]) << 24) |
    (((unsigned long long)src[5]) << 16) |
    (((unsigned long long)src[6]) << 8) |
    ((unsigned long long)src[7]);
#endif
	return 8;
}

static u32 unpack_n(u8* val, u32 size, u8* src)
{
	register u32 i;
	for (i = 0; i < size; ++i)
	{
		*val++ =*src++;
	}
	return size;
}

@interface TarsInputStream ()

@property (nonatomic, retain) NSData *dataHolders;

@end

@implementation TarsInputStream

@synthesize headType = _headType;
@synthesize headTag = _headTag;

+ (TarsInputStream *)streamWithData:(NSData *)data
{
    if (data == nil)
        return nil;
	TarsInputStream * stream = [[TarsInputStream alloc] init];
    stream.dataHolders = data;
	stream.streamBuffer = (unsigned char *)[data bytes];
	stream.streamSize = (int)[data length];
	return stream;
}

- (id)init
{
	if (self = [super init])
	{
		_headType = TARS_TYPE_UNUSED;
		_headTag = 0;
	}
	return self;
}

- (NSData *)data
{
    return [NSData dataWithBytes:_streamBuffer length:_streamSize];
}

- (BOOL)peakHead
{
	if (_cursor >= _streamSize)
		return NO;
	_headType = (int)(_streamBuffer[_cursor] & 0x0F);
	_headTag = (int)(_streamBuffer[_cursor] >> 4);
	if (_headTag >= 15)
	{
		_headTag = (int)(_streamBuffer[_cursor + 1]);
	}
	return YES;
}

- (BOOL)readHead
{
	if (_cursor >= _streamSize)
		return NO;
    
	_headType = (int)(_streamBuffer[_cursor] & 0x0F);
	_headTag = (int)(_streamBuffer[_cursor] >> 4);
	
	if (_headTag >= 15)
	{
		_headTag = (int)(_streamBuffer[_cursor + 1]);
		_cursor += 2;
	}
	else
	{
		_cursor += 1;
	}
	
	return YES;
}

- (char)readInt1
{
	u8 val;
	_cursor += unpack_8( &val, &_streamBuffer[_cursor] );
	return (char)val;
}

- (short)readInt2
{
	u16 val;
	_cursor += unpack_16( &val, &_streamBuffer[_cursor] );
	return (short)val;
}

- (int)readInt4
{
	u32 val;
	_cursor += unpack_32( &val, &_streamBuffer[_cursor] );
	return (int)val;
}

- (long long)readInt8
{
	u64 val;
	_cursor += unpack_64(&val, &_streamBuffer[_cursor]);
	return (long long)val;
}

- (long long)readInt:(int)tag
{
	[self readHead];
    ASSERT_TRHOW_WS_EXCEPTION(_headTag == tag);
    switch (_headType) {
        case TARS_TYPE_ZERO:
            return 0;
        case TARS_TYPE_INT1:
            return [self readInt1];
        case TARS_TYPE_INT2:
            return [self readInt2];
        case TARS_TYPE_INT4:
            return [self readInt4];
        case TARS_TYPE_INT8:
            return [self readInt8];
        default:
            ASSERT_TRHOW_WS_EXCEPTION(0);
            break;
    }
}

- (float)readFloat:(int)tag
{
    [self readHead];
    ASSERT_TRHOW_WS_EXCEPTION(_headTag == tag);
	ASSERT_TRHOW_WS_EXCEPTION(_headType == TARS_TYPE_FLOAT);
    float val;
	_cursor += unpack_32((u32 *)&val, &_streamBuffer[_cursor]);
	return val;
}

- (double)readDouble:(int)tag
{
    [self readHead];
    ASSERT_TRHOW_WS_EXCEPTION(_headTag == tag);
	ASSERT_TRHOW_WS_EXCEPTION(_headType == TARS_TYPE_DOUBLE);
    double val;
	_cursor += unpack_64((u64 *)&val, &_streamBuffer[_cursor]);
	return val;
}

- (float)readFloat
{
    float val;
	_cursor += unpack_32((u32 *)&val, &_streamBuffer[_cursor]);
	return val;
}

- (double)readDouble
{
    double val;
	_cursor += unpack_64((u64 *)&val, &_streamBuffer[_cursor]);
	return val;
}

- (unsigned char *)readBytes:(unsigned int)length
{
    ASSERT_TRHOW_WS_EXCEPTION(_cursor + length <= _streamSize);
    unsigned char *bytes = (unsigned char *)malloc(length);
    memcpy(bytes, &_streamBuffer[_cursor], length);
    _cursor += length;
    return bytes;
}

- (void)skip:(unsigned int)lenght
{
    _cursor += lenght;
    if (_cursor > _streamSize)
        _cursor = _streamSize;
}

- (NSData *)readDataWithSize:(int)size
{
    unsigned char *bytes = [self readBytes:size];
    return [NSData dataWithBytesNoCopy:bytes length:size];
}

- (NSNumber *)readNumber:(int)tag required:(BOOL)required
{
    [self peakHead];
    if (_headTag != tag) 
    {
        ASSERT_TRHOW_WS_EXCEPTION(required == NO);
        return nil;
    }
    else
    {
        [self readHead];
        switch (_headType) 
        {
            case TARS_TYPE_ZERO:
                return @((char)0);
            case TARS_TYPE_INT1:
                return @((char)[self readInt1]);
            case TARS_TYPE_INT2:
                return @((short)[self readInt2]);
            case TARS_TYPE_INT4:
                return @([self readInt4]);
            case TARS_TYPE_INT8:
                return @([self readInt8]);
            case TARS_TYPE_FLOAT:
                return @([self readFloat]);
            case TARS_TYPE_DOUBLE:
                return @([self readDouble]);
            default:
                ASSERT_TRHOW_WS_EXCEPTION(0);
                break;
        }
    }
}

- (NSString *)readString:(int)tag required:(BOOL)required
{
    [self peakHead];
    if (_headTag != tag) 
    {
        ASSERT_TRHOW_WS_EXCEPTION(required == NO);
        return nil;
    }
    else
    {
        [self readHead];
        if (_headType == TARS_TYPE_STRING1) 
        {
            u8 val;
            _cursor += unpack_8(&val, &_streamBuffer[_cursor]);
            NSString * str = [[NSString alloc] initWithBytes:&_streamBuffer[_cursor] 
                                                      length:val 
                                                    encoding:NSUTF8StringEncoding];
            _cursor += val;
            return str ?: @"";
        }
        else if (_headType == TARS_TYPE_STRING4) 
        {
            u32 val;
            _cursor += unpack_32(&val, &_streamBuffer[_cursor]);
            NSString * str = [[NSString alloc] initWithBytes:&_streamBuffer[_cursor] 
                                                      length:val 
                                                    encoding:NSUTF8StringEncoding];
            _cursor += val;
            return str ?: @"";
        }
        else 
        {
            ASSERT_TRHOW_WS_EXCEPTION(0);
        }
    }
}

- (NSData *)readData:(int)tag required:(BOOL)required
{
    [self peakHead];
    if (_headTag != tag) 
    {
        ASSERT_TRHOW_WS_EXCEPTION(required == NO);
        return nil;
    }
    else
    {
        [self readHead];
        ASSERT_TRHOW_WS_EXCEPTION(_headType == TARS_TYPE_SIMPLE_LIST);
        [self readHead];
        ASSERT_TRHOW_WS_EXCEPTION(_headType == TARS_TYPE_INT1 && _headTag == 0);
        int size = [self readInt:0];
        void *data = (void *)&_streamBuffer[_cursor];
        _cursor += size;
        return [NSMutableData dataWithBytes:data length:size];
    }
}

- (id)readObject:(int)tag required:(BOOL)required description:(Class)theClass
{
    [self peakHead];
    if (_headTag != tag) 
    {
        ASSERT_TRHOW_WS_EXCEPTION(required == NO);
        return nil;
    }
    else
    {
        [self readHead];
        ASSERT_TRHOW_WS_EXCEPTION(_headType == TARS_TYPE_STRUCT_S);
        id obj = [[theClass alloc] init];
        [self peakHead];
        if (_headTag == 0 && _headType == 11) {
            [self readHead];
            return obj;
        }
        
        ASSERT_TRHOW_WS_EXCEPTION([obj respondsToSelector:@selector(__unpack:)]);
        [obj __unpack:self];
        for (int level = 1; level >= 1; )
        {
            [self readHead];
            switch (_headType) 
            {
                case TARS_TYPE_INT1:
                    _cursor += 1;
                    break;
                case TARS_TYPE_INT2:
                    _cursor += 2;
                    break;
                case TARS_TYPE_INT4:
                case TARS_TYPE_FLOAT:
                    _cursor += 4;
                    break;
                case TARS_TYPE_INT8:
                case TARS_TYPE_DOUBLE:
                    _cursor += 8;
                    break;
                case TARS_TYPE_STRING1:
                {
                    u8 val8;
                    _cursor += unpack_8(&val8, &_streamBuffer[_cursor]);
                    _cursor += val8;
                    break;
                }
                case TARS_TYPE_STRING4:
                {
                    u32 val32;
                    _cursor += unpack_32(&val32, &_streamBuffer[_cursor]);
                    _cursor += val32;
                    break;    
                }
                case TARS_TYPE_MAP:
                case TARS_TYPE_LIST:
                    [self readInt:0];
                    break;
                case TARS_TYPE_STRUCT_S:
                    level++;
                    break;
                case TARS_TYPE_STRUCT_E:
                    level--;
                    break;
                case TARS_TYPE_ZERO:
                    break;
                case TARS_TYPE_SIMPLE_LIST:
                    [self readHead];
                    ASSERT_TRHOW_WS_EXCEPTION(_headType == TARS_TYPE_INT1 && _headTag == 0);
                    _cursor += [self readInt:0];
                    break;
                default:
                    ASSERT_TRHOW_WS_EXCEPTION(0);
                    break;
            }
        }
        ASSERT_TRHOW_WS_EXCEPTION(_headType == TARS_TYPE_STRUCT_E);
        return obj;
    }
}

- (NSArray *)readArray:(int)tag required:(BOOL)required description:(id)description
{
    [self peakHead];
    if (_headTag != tag) {
        ASSERT_TRHOW_WS_EXCEPTION(required == NO);
        return nil;
    }
    else {
        [self readHead];
        ASSERT_TRHOW_WS_EXCEPTION(_headType == TARS_TYPE_LIST);
        int count = (int)[self readInt:0];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
        for (; count > 0; count--) {
            [array addObject:[self readAnything:0 required:YES description:description]];
        }
        return array;
    }
}

- (NSDictionary *)readDictionary:(int)tag required:(BOOL)required description:(TarsPair *)description
{
    [self peakHead];
    if (_headTag != tag) 
    {
        ASSERT_TRHOW_WS_EXCEPTION(required == NO);
        return nil;
    }
    else
    {
        [self readHead];
        ASSERT_TRHOW_WS_EXCEPTION(_headType == TARS_TYPE_MAP);
        int count = (int)[self readInt:0];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:count];
        for (; count > 0; count--) 
        {
            id key = [self readAnything:0 required:YES description:description.key];
            id obj = [self readAnything:1 required:YES description:description.value];
            dictionary[key] = obj;
        };
        return dictionary;
    }
}

- (id)readAnything:(int)tag required:(BOOL)required description:(id)description
{
    if ([description isKindOfClass:[TarsPair class]]) 
    {
        TarsPair *pair = (TarsPair *)description;
        if (pair.key == nil) 
        {
            return [self readArray:tag required:required description:pair.value];
        }
        else
        {
            return [self readDictionary:tag required:required description:pair];
        }
    }
    else
    {
        if ([description isSubclassOfClass:[NSNumber class]]) 
        {
            return [self readNumber:tag required:required];
        }
        else if ([description isSubclassOfClass:[NSString class]]) 
        {
            return [self readString:tag required:required];
        }
        else if ([description isSubclassOfClass:[TarsObject class]]) 
        {
            return [self readObject:tag required:required description:description];
        }
        else if ([description isSubclassOfClass:[NSData class]]) 
        {
            return [self readData:tag required:required];
        }
        else
        {
            ASSERT_TRHOW_WS_EXCEPTION(0);
        }
    }
}

@end
