//
//  UZUpLoadImagTool.h
//  UZ-iOS
//
//  Created by 小飞鸟 on 16/4/21.
//  Copyright © 2016年 uzteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"

#import <UIKit/UIKit.h>

@interface UZUpLoadImagTool : NSObject


//+ (void)getQiniuUploadToken:(void(^)(NSString*token))success failure:(void(^)())failure;

/**
 
 *上传图片
 
 *
 
 *@param image需要上传的image
 
 *@param progress上传进度block
 
 *@param success成功block返回url地址
 
 *@param failure失败block
 
 */
+ (void)uploadImage:(UIImage*)image progress:(QNUpProgressHandler)progress FileName:(NSString*)fileName Token:(NSString *)token success:(void(^)(NSString*url))success failure:(void(^)())failure;

//上传多张图片,按队列依次上传
+(void)uploadImages:(NSArray *)imageArray FileNames:(NSArray*)fileNameArr progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure;

+(NSString*)getPhotoName;

//获取token的值
+ (void)qiNiuUploadWithFileName:(NSString*)fileName Token:(void (^)(NSString *))success failure:(void (^)())failure;

@end
