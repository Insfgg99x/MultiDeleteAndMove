//
//  Model.h
//  MultiDelete
//
//  Created by 夏桂峰 on 15/11/26.
//  Copyright © 2015年 夏桂峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property(nonatomic,strong)NSString *desc;

+(instancetype)modelWithDesc:(NSString *)desc;

@end
