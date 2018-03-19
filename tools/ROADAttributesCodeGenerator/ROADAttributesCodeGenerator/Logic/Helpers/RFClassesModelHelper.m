//
//  RFClassesModelHelper.m
//  ROADAttributesCodeGenerator
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


#import "RFClassesModelHelper.h"
#import "NSString+RFExtendedAPI.h"

#import "RFClassModel.h"
#import "RFPropertyModel.h"


@implementation RFClassesModelHelper

+ (void)mergeClassesModel:(NSMutableArray *)classesModel1 withClassesModel:(NSMutableArray *)classesModel2 {
    if (classesModel1 == nil || classesModel2 == nil) {
        return;
    }
    
    for (RFClassModel *currentClassModel2 in classesModel2) {
        [self mergeClassesModel:classesModel1 withClassModel:currentClassModel2];
    }
}

+ (void)mergeClassesModel:(NSMutableArray *)classesModel1 withClassModel:(RFClassModel *)classModelToMerge {
    if (classesModel1 == nil || classModelToMerge == nil) {
        return;
    }
    
    RFClassModel *currentClassModel1 = [self findClassByName:classModelToMerge.name inModel:classesModel1];
    
    if (currentClassModel1 == nil) {
        [classesModel1 addObject:classModelToMerge];
        return;
    }
    
    [currentClassModel1.attributeModels addAttributeModelsFromContainer:classModelToMerge.attributeModels];
    [currentClassModel1.filesToImport unionSet:classModelToMerge.filesToImport];
    
    [self mergePropertiesToClassModel:currentClassModel1 fromClassModel:classModelToMerge];
}

+ (RFClassModel *)findClassByName:(NSString *)name inModel:(NSMutableArray *)classesModel {
    for (RFClassModel *currentClassModel in classesModel) {
        if ([currentClassModel.name isEqualToString:name]) {
            return currentClassModel;
        }
    }
    
    return nil;
}

+ (void)mergePropertiesToClassModel:(RFClassModel *)toModel fromClassModel:(RFClassModel *)fromModel {

    for (RFPropertyModel *currentPropertyModel2 in fromModel.propertiesList) {
        
        RFPropertyModel *currentPropertyModel1 = [self findPropertyByName:currentPropertyModel2.name inModel:toModel.propertiesList];
        
        if (currentPropertyModel1 == nil) {
            
            currentPropertyModel2.holder = toModel;
            [toModel.propertiesList addObject:currentPropertyModel2];
            
            continue;
        }
        
        [currentPropertyModel1.attributeModels addAttributeModelsFromContainer:currentPropertyModel2.attributeModels];
    }
}

+ (RFPropertyModel *)findPropertyByName:(NSString *)name inModel:(NSMutableArray *)propertiesModel {
    for (RFPropertyModel *currentPropertyModel in propertiesModel) {
        if ([currentPropertyModel.name isEqualToString:name]) {
            return currentPropertyModel;
        }
    }
    
    return nil;
}

@end
