//
//  RFPropertyInfo.h
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


#import <Foundation/Foundation.h>


/**
 Property encoding types
 */
typedef NS_ENUM(NSUInteger, RFEncodingType)
{
    RFEncodingTypeUnknown    = 0, ///< unknown
    RFEncodingTypeVoid       = 1, ///< void
    RFEncodingTypeBool       = 2, ///< bool
    RFEncodingTypeInt8       = 3, ///< char / BOOL
    RFEncodingTypeUInt8      = 4, ///< unsigned char
    RFEncodingTypeInt16      = 5, ///< short
    RFEncodingTypeUInt16     = 6, ///< unsigned short
    RFEncodingTypeInt32      = 7, ///< int
    RFEncodingTypeUInt32     = 8, ///< unsigned int
    RFEncodingTypeInt64      = 9, ///< long long
    RFEncodingTypeUInt64     = 10, ///< unsigned long long
    RFEncodingTypeFloat      = 11, ///< float
    RFEncodingTypeDouble     = 12, ///< double
    RFEncodingTypeLongDouble = 13, ///< long double
    RFEncodingTypeObject     = 14, ///< id
    RFEncodingTypeClass      = 15, ///< Class
    RFEncodingTypeSEL        = 16, ///< SEL
    RFEncodingTypeBlock      = 17, ///< block
    RFEncodingTypePointer    = 18, ///< void*
    RFEncodingTypeStruct     = 19, ///< struct
    RFEncodingTypeUnion      = 20, ///< union
    RFEncodingTypeCString    = 21, ///< char*
    RFEncodingTypeCArray     = 22, ///< char[10] (for example)
};

/**
 Property encoding specifier
 */
typedef NS_OPTIONS(NSUInteger, RFEncodingSpecifier)
{
    RFEncodingSpecifierReadonly     = 1 << 0, ///< readonly
    RFEncodingSpecifierCopy         = 1 << 1, ///< copy
    RFEncodingSpecifierRetain       = 1 << 2, ///< retain
    RFEncodingSpecifierNonatomic    = 1 << 3, ///< nonatomic
    RFEncodingSpecifierWeak         = 1 << 4, ///< weak
    RFEncodingSpecifierCustomGetter = 1 << 5, ///< getter=
    RFEncodingSpecifierCustomSetter = 1 << 6, ///< setter=
    RFEncodingSpecifierDynamic      = 1 << 7, ///< @dynamic
};

/**
 * Contains information about a declared property.
 */
@interface RFPropertyInfo : NSObject

/**
 * The property's name.
 */
@property (readonly, nonatomic) NSString *propertyName;

/**
 * The name of the host class.
 */
@property (readonly, nonatomic) NSString *className;

/**
 * The type of the host class.
 */
@property (readonly, nonatomic) Class hostClass;

/**
 * The type name.
 * For primitive types this is Nil.
 */
@property (readonly, nonatomic) NSString *typeName;

/**
 * The declared class of the property if applicable.
 * For primitive types this is Nil.
 */
@property (readonly, nonatomic) Class typeClass;

/**
 * Return the property type encoding.
 */
@property (readonly, nonatomic) NSString *typeEncoding;

/**
 * The name of the setter method.
 */
@property (readonly, nonatomic) SEL setter;

/**
 * The name of the getter method.
 */
@property (readonly, nonatomic) SEL getter;

/**
 * Return ivarName.
 */
@property (readonly, nonatomic) NSString *ivarName;

/**
 * Return encoding type.
 */
@property (readonly, nonatomic) RFEncodingType encodingType;

/**
 * Return encoding specifier.
 */
@property (readonly, nonatomic) RFEncodingSpecifier encodingSpecifier;

/**
 * An array of attributes declared for property.
 */
@property (readonly, nonatomic) NSArray *attributes;

/**
 * Custom Tag
 */
@property(nonatomic,assign) NSInteger tag;

/**
 * Returns an array of info objects for the given class.
 * @param aClass The class to fetch the property infos for.
 * @result The array of filtered results.
 */
+ (NSArray *)propertiesForClass:(Class)aClass;

/**
 * Returns an array of info objects for the given class plus properties from superclasses limited with specified depth.
 * @param aClass The class to fetch the property infos for.
 * @param depth The depth of superclasses where properties should be gathered.
 * 1 - only current class, 0 - always returns no properties. Invoked on an instance of a class.
 * @result The array of filtered results.
 */
+ (NSArray *)propertiesForClass:(Class)aClass depth:(NSUInteger)depth;

/**
 * Returns an array of info objects for the given class filtered with the predicate.
 * @param aClass The class to fetch the infos for.
 * @param aPredicate The predicate to apply before returning the results.
 * @result The array of filtered results.
 */
+ (NSArray *)propertiesForClass:(Class)aClass withPredicate:(NSPredicate *)aPredicate;

/**
 * Fetches the specific info object corresponding to the property named for the given class.
 * @param name The name of the property field.
 * @param aClass The class to fetch the result for.
 * @result The info object.
 */
+ (RFPropertyInfo *)RF_propertyNamed:(NSString *)name forClass:(Class)aClass;

/**
 * The method performs search for attribute of required class in array of attributes declared for property.
 * @param requiredClassOfAttribute Class of required attribute.
 * @return An object of attribute. Or nil if attribute was not found.
 */
- (id)attributeWithType:(Class)requiredClassOfAttribute;

/**
 * The method performs search for attribute of required protocol in array of attributes declared for property.
 * @param requiredProtocolOfAttribute Protocol of required attribute.
 * @return An object of attribute. Or nil if attribute was not found.
 */
- (id)attributeWithProtocol:(Protocol *)requiredProtocolOfAttribute;

@end
