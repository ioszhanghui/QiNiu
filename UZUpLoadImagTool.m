//
//  UZUpLoadImagTool.m
//  UZ-iOS
//
//  Created by 小飞鸟 on 16/4/21.
//  Copyright © 2016年 uzteam. All rights reserved.
//

#import "UZUpLoadImagTool.h"

#import"AFNetworking.h"

#import"AFNetworkActivityIndicatorManager.h"

#import "UZQiniuUploadHelper.h"


@implementation UZUpLoadImagTool


//给图片命名

+ (NSString*)getDateTimeString

{
    
    NSDateFormatter*formatter;
    
    NSString*dateString;
    
    formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
    
}



+ (NSString*)randomStringWithLength:(int)len

{
    
    NSString*letters =@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString*randomString = [NSMutableString stringWithCapacity: len];
    
    for(int i=0; i<8;i++){
        
        
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((int)[letters length])]];
        
        }
    
    
    
        
        return randomString;
        
}


+(NSString*)getPhotoName{



    
    NSString*fileName = [NSString stringWithFormat:@"%@_%@.png", [UZUpLoadImagTool getDateTimeString], [UZUpLoadImagTool randomStringWithLength:8]];
    
    return fileName;
}


//上传单张图片

+ (void)uploadImage:(UIImage*)image progress:(QNUpProgressHandler)progress FileName:(NSString*)fileName  Token:(NSString *)token success:(void(^)(NSString*url))success failure:(void(^)())failure {
    
    
    NSData*data =UIImageJPEGRepresentation(image,0.3);
    
    if(!data) {
        
        if(failure) {
            
            failure();
            
        }
        
        return;
        
    }
    
    
    QNUploadOption*opt = [[QNUploadOption alloc]initWithMime:nil
                          
                                             progressHandler:progress
                          
                                                      params:nil
                          
                                                    checkCrc:NO
                          
                                          cancellationSignal:nil];
    
    QNUploadManager*uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
    
    [uploadManager putData:data
     
                       key:fileName
     
                     token:token
     
                  complete:^(QNResponseInfo*info,NSString*key,NSDictionary*resp) {
                      
                      if(info.statusCode==200&& resp) {
                          
                          NSString*url= [NSString stringWithFormat:@"%@",resp[@"key"]];
                          
                          if(success) {
                              
                              success(url);
                              
                          }
                          
                      }
                      
                      else{
                          
                          if(failure) {
                              
                              failure();
                              
                          }
                          
                      }
                      
                  }option:opt];

    
}

//多张图片上传

+(void)uploadImages:(NSArray *)imageArray FileNames:(NSArray*)fileNameArr progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    __block float totalProgress = 0.0f;
    __block float partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    UZQiniuUploadHelper * uploadHelper = [UZQiniuUploadHelper sharedUploadHelper];
    
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }
        else {
            
            [UZUpLoadImagTool qiNiuUploadWithFileName:[fileNameArr objectAtIndex:currentIndex] Token:^(NSString * token) {
                
                UIImage *image=[imageArray objectAtIndex:currentIndex];
                
                [UZUpLoadImagTool uploadImage:[UIImage scaleToSize:image size:CGSizeMake(image.size.width*0.3, image.size.height*0.3)] progress:nil FileName:[fileNameArr objectAtIndex:currentIndex] Token:token success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
                
            } failure:^(){
                
            }];
            
        }
    };
    
    [UZUpLoadImagTool qiNiuUploadWithFileName:[fileNameArr objectAtIndex:currentIndex] Token:^(NSString * token) {
        
        UIImage *image=[imageArray objectAtIndex:currentIndex];

        [UZUpLoadImagTool uploadImage:[UIImage scaleToSize:image size:CGSizeMake(image.size.width*0.3, image.size.height*0.3)] progress:nil FileName:[fileNameArr objectAtIndex:currentIndex] Token:token success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        
    } failure:^(){
        
    }];

}


//获取七牛的token
+ (void)qiNiuUploadWithFileName:(NSString*)fileName Token:(void (^)(NSString *))success failure:(void (^)())failure{
    

    [UZHttpClient requestWithMethod:RequestMethodTypePost url:UD_URL_UPLOADIMAGE params:@{@"key":fileName} success:^(id response) {
        NSDictionary * dict=response;
        
        NSString * token=[dict objectForKey:@"result"];
        if (success) {
            success(token);
        }
        NSLog(@"前部dict****** %@",dict);
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}



@end
