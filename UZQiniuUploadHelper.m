//
//  UZQiniuUploadHelper.m
//  UZ-iOS
//
//  Created by 小飞鸟 on 16/4/21.
//  Copyright © 2016年 uzteam. All rights reserved.
//

#import "UZQiniuUploadHelper.h"

@implementation UZQiniuUploadHelper


static id _instance =nil;


+(id)allocWithZone:(struct _NSZone *)zone{

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance= [super allocWithZone:zone];
        
    });
    
    return _instance;
    
}

+ (instancetype)sharedUploadHelper {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance= [[self alloc]init];
        
    });
    
    return _instance;
    
}

- (id)copyWithZone:(NSZone*)zone {
    
    return _instance;
    
}


@end
