//
//  RFPropertyInfo.m
//  libObjCAttr
//
//  Copyright (c) 2014 EPAM Systems, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  See the NOTICE file and the LICENSE file distributed with this work
//  for additional information regarding copyright ownership and licensing


#import "RFPropertyInfo.h"
#import <objc/runtime.h>
#import "ROADAttribute.h"

@interface RFPropertyInfo ()
{
    Class _typeClass;
    NSString *_typeName;
    objc_property_t _property;
    NSString * _propertyName;
    Class _hostClass;
    NSString *_typeEncoding;
    SEL _getter;
    SEL _setter;
    NSString *_ivarName;
    
    RFEncodingType _encodingType;
    RFEncodingSpecifier _encodingSpecifier;
    
    NSArray *_protocols;
}

@property (copy, nonatomic) NSString *propertyName;
@property (assign, nonatomic) Class hostClass;
@property (copy, nonatomic) NSString *className;
@property (strong, nonatomic) NSArray *attributes;
@end


@implementation RFPropertyInfo

#pragma mark - Initialization

+ (NSArray *)propertiesForClass:(Class)aClass {
    return [self propertiesForClass:aClass depth:1];
}

+ (NSArray *)propertiesForClass:(Class)aClass depth:(NSUInteger)depth {
    if (depth <= 0) {
        return @[];
    }

    NSMutableArray *result = [[NSMutableArray alloc] init];
    unsigned int numberOfProperties = 0;
    objc_property_t *propertiesArray = class_copyPropertyList(aClass, &numberOfProperties);
    
    for (unsigned int idx = 0; idx < numberOfProperties; idx++) {
        [result addObject:[self property:propertiesArray[idx] forClass:aClass]];
    }
    
    free(propertiesArray);

    [result addObjectsFromArray:[self propertiesForClass:class_getSuperclass(aClass) depth:--depth]];

    return result;
}

+ (RFPropertyInfo *)RF_propertyNamed:(NSString *)name forClass:(Class)aClass {
    objc_property_t prop = class_getProperty(aClass, [name cStringUsingEncoding:NSUTF8StringEncoding]);
    RFPropertyInfo *result = nil;
    
    if (prop != NULL) {
        result = [self property:prop forClass:aClass];
    }
    
    return result;
}

+ (NSArray *)propertiesForClass:(Class)class withPredicate:(NSPredicate *)aPredicate {
    NSArray *result = [self propertiesForClass:class];
    return [result filteredArrayUsingPredicate:aPredicate];
}

+ (RFPropertyInfo *)property:(objc_property_t)property forClass:(Class)class {
    RFPropertyInfo * const info = [[RFPropertyInfo alloc] initWithProperty:property hostClass:class];
    return info;
}

- (id)initWithProperty:(objc_property_t)property hostClass:(Class)hostClass{
    self = [super init];
    if (self)
    {
        _property     = property;
        _hostClass    = hostClass;
        
        self.className = NSStringFromClass(hostClass);
        
        [self fillProperty];
        [self fillAttributes];
    }
    return self;
}

- (id)attributeWithType:(Class)requiredClassOfAttribute {
    
    id result = nil;
    
    for (id attribute in _attributes)
    {
        if ([attribute isKindOfClass:requiredClassOfAttribute])
        {
            result = attribute;
            break;
        }
    }
    
    return result;
}

- (id)attributeWithProtocol:(Protocol *)requiredProtocolOfAttribute
{
    id result = nil;
    
    for (id attribute in _attributes)
    {
        if ([attribute conformsToProtocol:requiredProtocolOfAttribute])
        {
            result = attribute;
            break;
        }
    }
    
    return result;
}

#pragma mark - Utility methods

- (void)fillTypesWithTypeEncoding:(const char *)typeEncoding
{
    size_t len = strlen(typeEncoding);
    if (len > 0)
    {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];

        switch (*typeEncoding)
        {
            case 'v': _encodingType = RFEncodingTypeVoid; break;
            case 'B': _encodingType = RFEncodingTypeBool; break;
            case 'c': _encodingType = RFEncodingTypeInt8; break;
            case 'C': _encodingType = RFEncodingTypeUInt8; break;
            case 's': _encodingType = RFEncodingTypeInt16; break;
            case 'S': _encodingType = RFEncodingTypeUInt16; break;
            case 'i': _encodingType = RFEncodingTypeInt32; break;
            case 'I': _encodingType = RFEncodingTypeUInt32; break;
            case 'l': _encodingType = RFEncodingTypeInt32; break;
            case 'L': _encodingType = RFEncodingTypeUInt32; break;
            case 'q': _encodingType = RFEncodingTypeInt64; break;
            case 'Q': _encodingType = RFEncodingTypeUInt64; break;
            case 'f': _encodingType = RFEncodingTypeFloat; break;
            case 'd': _encodingType = RFEncodingTypeDouble; break;
            case 'D': _encodingType = RFEncodingTypeLongDouble; break;
            case '#': _encodingType = RFEncodingTypeClass; break;
            case ':': _encodingType = RFEncodingTypeSEL; break;
            case '*': _encodingType = RFEncodingTypeCString; break;
            case '^': _encodingType = RFEncodingTypePointer; break;
            case '[': _encodingType = RFEncodingTypeCArray; break;
            case '(': _encodingType = RFEncodingTypeUnion; break;
            case '{': _encodingType = RFEncodingTypeStruct; break;
            case '@':
            {
                if (len == 2 && *(typeEncoding + 1) == '?')
                {
                    _encodingType = RFEncodingTypeBlock;
                } else {
                    _encodingType = RFEncodingTypeObject;
                }
            }
                break;
            default: _encodingType = RFEncodingTypeUnknown; break;
        }
        
        if (_encodingType == RFEncodingTypeObject)
        {
            char *pTypeEncoding = (char *)typeEncoding;
            pTypeEncoding = strstr(pTypeEncoding, "@\"");
            if (pTypeEncoding)
            {
                pTypeEncoding += 2;
                char *find = strstr(pTypeEncoding, "<");
                if (!find)
                {
                    find = strstr(pTypeEncoding, "\"");
                }
                
                if (find)
                {
                    size_t size = strlen(typeEncoding) + 1;
                    char *buffer = malloc(size);
                    memset(buffer, 0, size);
                    
                    size = (size_t)(find - pTypeEncoding);
                    strncpy(buffer, pTypeEncoding,size);
                    buffer[size] = 0;
                    
                    _typeName  = @(buffer);
                    _typeClass = objc_getClass(buffer);
                    
                    NSMutableArray *protocols = [NSMutableArray array];
                    
                    pTypeEncoding = find;
                    while (pTypeEncoding && (find = strstr(pTypeEncoding, ">")))
                    {
                        pTypeEncoding++;
                        
                        size = (size_t)(find - pTypeEncoding);
                        strncpy(buffer, pTypeEncoding,size);
                        buffer[size] = 0;
                        
                        if (strlen(buffer) > 0)
                        {
                            [protocols addObject:@(buffer)];
                        }
                        
                        pTypeEncoding = strstr(pTypeEncoding + 1, "<");
                    }
                    
                    if (protocols.count > 0)
                    {
                        _protocols = protocols;
                    }
                    
                    free(buffer);
                }
            }
        }
    }
}

- (void)fillProperty
{
    _typeClass         = nil;
    _typeName          = nil;
    _protocols         = nil;
    _ivarName          = nil;
    _typeEncoding      = nil;
    _propertyName      = nil;
    _encodingType      = RFEncodingTypeUnknown;
    _encodingSpecifier = 0;

    const char *propertyName = property_getName(_property);
    if (propertyName)
    {
        _propertyName = [NSString stringWithUTF8String:propertyName];
    }
    
    unsigned int count = 0;
    objc_property_attribute_t *attributes = property_copyAttributeList(_property, &count);
    for (unsigned int index = 0; index < count; index++)
    {
        const char *typeName     = attributes[index].name;
        const char *typeEncoding = attributes[index].value;
        switch (typeName[0])
        {
            case 'T':
            {
                if (typeEncoding)
                {
                    [self fillTypesWithTypeEncoding:typeEncoding];
                }
            }
                break;
            case 'V':
            {
                if (typeEncoding)
                {
                    _ivarName = [NSString stringWithUTF8String:typeEncoding];
                }
            }
                break;
            case 'R':
            {
                _encodingSpecifier |= RFEncodingSpecifierReadonly;
            }
                break;
            case 'C':
            {
                _encodingSpecifier |= RFEncodingSpecifierCopy;
            }
                break;
            case '&':
            {
                _encodingSpecifier |= RFEncodingSpecifierRetain;
            }
                break;
            case 'N':
            {
                _encodingSpecifier |= RFEncodingSpecifierNonatomic;
            }
                break;
            case 'D':
            {
                _encodingSpecifier |= RFEncodingSpecifierDynamic;
            }
                break;
            case 'W':
            {
                _encodingSpecifier |= RFEncodingSpecifierWeak;
            }
                break;
            case 'G':
            {
                _encodingSpecifier |= RFEncodingSpecifierCustomGetter;
                if (typeEncoding)
                {
                    _getter = NSSelectorFromString([NSString stringWithUTF8String:typeEncoding]);
                }
            }
                break;
            case 'S':
            {
                _encodingSpecifier |= RFEncodingSpecifierCustomSetter;
                if (typeEncoding)
                {
                    _setter = NSSelectorFromString([NSString stringWithUTF8String:typeEncoding]);
                }
            }
                break;
            default: break;
        }
    }
    
    if (attributes)
    {
        free(attributes);
    }
    
    if (_propertyName.length > 0)
    {
        if (!_getter)
        {
            _getter = NSSelectorFromString(_propertyName);
        }
        
        if (!_setter)
        {
            _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [_propertyName substringToIndex:1].uppercaseString, [_propertyName substringFromIndex:1]]);
        }
    }
}

- (void)fillAttributes
{
    NSString *selectName = [NSString stringWithFormat:@"RF_attributes_%@_property_%@", self.className, self.propertyName];
    
    SEL select = NSSelectorFromString(selectName);
    if ([self.hostClass respondsToSelector:select])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        self.attributes = [self.hostClass performSelector:select];
#pragma clang diagnostic pop
    }
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"%@: hostClass = %@, property name = %@", NSStringFromClass([self class]), NSStringFromClass([self.hostClass class]), self.propertyName];
}

@end
