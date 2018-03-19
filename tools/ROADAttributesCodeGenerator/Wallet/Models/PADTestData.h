//
//  PADTestData.h
//  PAQZZ
//
//  Created by chendailong2014@126.com on 2017/2/17.
//  Copyright © 2017年 平安付. All rights reserved.
//

#import "PADObjectAttribute.h"
#import "PADTableAttribute.h"

//@@dao_table(version = 4,policy = PADMigrationPolicy_swap)
RF_ATTRIBUTE(PADTableAttribute,version = 4,policy = PADMigrationPolicy_swap)
@interface PADTestData : NSObject
//@@dao_field(key=YES)
RF_ATTRIBUTE(PADObjectAttribute,key=YES)
@property(nonatomic,copy) NSString *key;
RF_ATTRIBUTE(PADObjectAttribute,index=YES)
//@@dao_field(key=YES,dbType=1)
@property(nonatomic,copy) NSString *key0;
@property(nonatomic,assign) int key1;
@end
