//
//  UZQiniuUploadHelper.h
//  UZ-iOS
//
//  Created by 小飞鸟 on 16/4/21.
//  Copyright © 2016年 uzteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UZQiniuUploadHelper : NSObject


@property(copy,nonatomic)void(^singleSuccessBlock)(NSString*);

@property(copy,nonatomic)void(^singleFailureBlock)();

+ (instancetype)sharedUploadHelper;


@end
