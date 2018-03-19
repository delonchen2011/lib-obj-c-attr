#import "PADObjectAttribute.h"
#import "PADTableAttribute.h"
#import "PADTestData.h"
 
@interface PADTestData(RFAttribute)
 
@end
 
@implementation PADTestData(RFAttribute)
 
#pragma mark - Fill Attributes generated code (Properties section)

+ (NSArray *)RF_attributes_PADTestData_property_key {
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    PADObjectAttribute *attr1 = [[PADObjectAttribute alloc] init];
    attr1.key=YES;
    [attributesArray addObject:attr1];

    return attributesArray;

}

+ (NSArray *)RF_attributes_PADTestData_property_key0 {
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    PADObjectAttribute *attr1 = [[PADObjectAttribute alloc] init];
    attr1.index=YES;
    [attributesArray addObject:attr1];

    return attributesArray;

}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

+ (NSArray *)RF_attributesForClass {
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    PADTableAttribute *attr1 = [[PADTableAttribute alloc] init];
    attr1.version = 4;
    attr1.policy = PADMigrationPolicy_swap;
    [attributesArray addObject:attr1];

    return attributesArray;

}

#pragma mark - 

@end
